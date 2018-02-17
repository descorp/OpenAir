//
//  Responce.swift
//  OpenAirSwift_iOS
//
//  Created by Vladimir Abramichev on 02/02/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

public protocol Responce {
    var origine: Command { get }
    var status: Int { get }
    var content: [OpenAirIncomingDTO]? { get }
}
