//
//  OpenAirDTO+Utillities.swift
//  OpenAirSwift_iOS
//
//  Created by Vladimir Abramichev on 26/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

extension Array where Element == String {
    public var xml: String {
        return self.reduce("") { (current, next) in
            return current + next
        }
    }
}

extension Array where Element: OpenAirDTO {
    public func xmlForEach() -> String {
        return self.reduce("") { (current, next) in
            return current + next.xml
        }
    }
}

extension Command {
    
    static func getXml(from array: [OpenAirDTO]) -> String {
        return array.reduce("") { (current, next) in
            return "\(current)\(next.xml)"
        }
    }
}
