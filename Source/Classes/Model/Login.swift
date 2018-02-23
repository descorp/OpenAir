//
//  Login.swift
//  OpenAirSwift_iOS
//
//  Created by Vladimir Abramichev on 24/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

public struct Login: XmlEncodable {
    
    let user: String
    let password: String
    let company: String
}
