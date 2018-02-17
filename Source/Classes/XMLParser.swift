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
    
    func parse(xml: String) -> Promise<Responce> {
        return Promise<Responce>(error: OpenAirError.requestParsingError)
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
