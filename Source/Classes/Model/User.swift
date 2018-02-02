//
//  User.swift
//  OpenAirSwift_iOS
//
//  Created by Vladimir Abramichev on 24/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

open class User: OpenAirOutgoingDTO {
    let id: String
    let name: String
    
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
