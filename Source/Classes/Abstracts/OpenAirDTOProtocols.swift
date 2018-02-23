//
//  OpenAirDTO.swift
//  OpenAirSwift_iOS
//
//  Created by Vladimir Abramichev on 24/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

/// Protocol that all DTO objects should implement to be converter into XML
public protocol XmlEncodable {
    static var datatype: String { get }
    var xml: String { get }
}

