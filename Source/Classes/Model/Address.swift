//
//  Address.swift
//  Onboarding
//
//  Created by Vladimir Abramichev on 19/02/2018.
//  Copyright © 2018 Mobiquity. All rights reserved.
//

import Foundation

struct Address: Decodable {
    let email: String
    let first: String
    let last: String    
    let addr2: String?
    let city: String?
    let fax: String?
    let contact_id: String?
    let addr1: String?
    let id: Int?
    let middle: String?
    let country: String?
    let phone: String?
    let addr4: String?
    let zip: String?
    let addr3: String?
}
