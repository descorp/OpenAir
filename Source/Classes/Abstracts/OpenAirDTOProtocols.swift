//
//  OpenAirDTO.swift
//  OpenAirSwift_iOS
//
//  Created by Vladimir Abramichev on 24/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

public protocol OpenAirOutgoingDTO: class {
    static var datatype: String { get }
    var xml: String { get }
}

public protocol OpenAirIncomingDTO: class {
    static var datatype: String { get }
    var xml: String { get }
}
