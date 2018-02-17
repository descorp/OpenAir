//
//  Login.swift
//  OpenAirSwift_iOS
//
//  Created by Vladimir Abramichev on 24/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

public class Login: OpenAirOutgoingDTO {
    let user: String
    let password: String
    let company: String
    
    public init(login: String, password: String, company: String) {
        self.user = login
        self.password = password
        self.company = company
    }
}
