//
//  XMLParser.swift
//  OpenAirSwift_iOS
//
//  Created by Vladimir Abramichev on 02/02/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import SwiftyXMLParser
import PromiseKit

struct OpenAirXMLParser: XMLParserType {
    
    let commands: [Command]
    
    func isValid(xml: String) -> Bool {
        guard
            !xml.isEmpty,
            xml.first == Character("<"),
            xml.last == Character(">"),
            xml.isBracketsInbalance
        else {
            return false
        }
        
        return true
    }
    
    init(commands: Command...) {
        self.init(commands)
    }
    
    init(_ commands: [Command]) {
        self.commands = commands
    }
    
    func parse(xml: Data) -> Promise<Responce> {
        let xmlData = XML.parse(xml)
        guard
            let responceElement = xmlData["response"].element
        else {
            return Promise<Responce>(error: OpenAirError.invalidResponce)
        }
        
        return parseXml(root: responceElement)
    }
    
    func parse(xml: String) -> Promise<Responce> {
        let minifiedXml = xml.minifiedXml
        guard
            self.isValid(xml: minifiedXml),
            let xmlData = try? XML.parse(minifiedXml),
            let responceElement = xmlData["response"].element
        else {
            return Promise<Responce>(error: OpenAirError.invalidResponce)
        }
        
        return parseXml(root: responceElement)
    }
    
    private func parseXml(root: XML.Element) -> Promise<Responce> {
        
        if let statusAttribute = root.attributes.first, statusAttribute.key == "status" {
            let errorMessage = root.text ?? "Unknown Error"
            let errorCode = Int(statusAttribute.value) ?? -1
            
            return Promise<Responce>(error: OpenAirError.responce(errorCode, errorMessage))
        }
        
        guard
            commands.count == root.childElements.count
        else {
            return Promise<Responce>(error: OpenAirError.invalidResponce)
        }
        
        var responce = Responce(responces: [], status: nil)
        for (offset, element) in root.childElements.enumerated() {
            let command = commands[offset]
            
            guard
                element.name.caseInsensitiveCompare(command.name) == .orderedSame,
                let statusAttribute = element.attributes.first,
                statusAttribute.key == "status",
                let status = Int(statusAttribute.value)
            else {
                return Promise<Responce>(error: OpenAirError.invalidResponce)
            }

            guard
                !element.childElements.isEmpty
            else {
                responce.responces.append(CommandResponse(origine: command, status: status, content: nil))
                continue
            }
            
            let decoders = element.childElements.map { XmlDecoder(node: $0) }
            responce.responces.append(CommandResponse(origine: command, status: status, content: decoders))
        }
        
        return Promise<Responce>(value: responce)
    }
}

fileprivate extension String {
    
    var isBracketsInbalance: Bool {
        var bracketsStack = [String]()
        for charecter in self {
            let char = charecter.description
            switch char {
            case "\"":
                if bracketsStack.last == char {
                    bracketsStack.popLast()
                } else {
                    fallthrough
                }
            case "<":
                bracketsStack.append(char)
            case ">":
                if bracketsStack.last == "<" {
                    bracketsStack.popLast()
                } else {
                    return false
                }
            default:
                break
            }
        }
        return bracketsStack.isEmpty
    }
}
