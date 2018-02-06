//
//  OpenAirDTO.swift
//  OpenAirSwift_iOS
//
//  Created by Vladimir Abramichev on 24/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

public protocol XMLSerialisable {
    var xml: String { get }
}

public protocol OpenAirOutgoingDTO: class, XMLSerialisable {
    static var datatype: String { get }
}

public protocol OpenAirIncomingDTO: class {
    static var datatype: String { get }
    init(dict: [String: Any])
}
