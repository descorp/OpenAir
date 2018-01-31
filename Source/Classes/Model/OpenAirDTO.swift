//
//  OpenAirDTO.swift
//  OpenAirSwift_iOS
//
//  Created by Vladimir Abramichev on 24/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

public protocol OpenAirDTO: class {
    static var datatype: String { get }
    var xml: String { get }
}

func unwrap<T>(_ any: T) -> Any {
    let mirror = Mirror(reflecting: any)
    guard mirror.displayStyle == .optional, let first = mirror.children.first else {
        return any
    }
    return unwrap(first.value)
}

public extension OpenAirDTO {
    
    static var datatype: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    
    var xml: String {
        let children = Mirror(reflecting: self).children.filter({ $0.label != nil })
        let keysValues = children.flatMap { ($0.label!, unwrap($0.value) as AnyObject ) }
        
        var parameters: [String] = []
        let typename = type(of: self).datatype
        
        for (name, value) in keysValues.filter({ !($1 is NSNull) }) {
            if let object = value as? OpenAirDTO {
                parameters.append("<\(name)>\(object.xml)</\(name)>")
                continue
            }
            
            parameters.append("<\(name)>\(value)</\(name)>")
        }
        
        return "<\(typename)>\(parameters.xml)</\(typename)>"
    }
}
