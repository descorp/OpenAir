//
//  OpenAirDTO+Utillities.swift
//  OpenAirSwift_iOS
//
//  Created by Vladimir Abramichev on 26/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

func unwrap<T>(_ any: T) -> Any {
    let mirror = Mirror(reflecting: any)
    guard mirror.displayStyle == .optional, let first = mirror.children.first else {
        return any
    }
    return unwrap(first.value)
}

public extension XmlEncodable {
    
    static var datatype: String {
        let str = "\(type(of: Self.self))".components(separatedBy: ".").first!
        return str
    }
    
    var xml: String {
        let children = Mirror(reflecting: self).children.filter({ $0.label != nil })
        let keysValues = children.flatMap { ($0.label!, unwrap($0.value) as AnyObject ) }
        
        var parameters: [String] = []
        let typename = type(of: self).datatype
        
        for (name, value) in keysValues.filter({ !($1 is NSNull) }) {
            if let object = value as? XmlEncodable {
                parameters.append("<\(name)>\(object.xml)</\(name)>")
                continue
            }
            
            parameters.append("<\(name)>\(value)</\(name)>")
        }
        
        return "<\(typename)>\(parameters.xml)</\(typename)>"
    }
}

extension Array where Element == String {
    public var xml: String {
        return self.reduce("") { (current, next) in
            return current + next
        }
    }
}

extension Array where Element: XmlEncodable {
    public func xmlForEach() -> String {
        return self.reduce("") { (current, next) in
            return current + next.xml
        }
    }
}

extension Command {
    
    static func getXml(from array: [XmlEncodable]) -> String {
        return array.reduce("") { (current, next) in
            return "\(current)\(next.xml)"
        }
    }
}
