//
//  User.swift
//  OpenAirSwift_iOS
//
//  Created by Vladimir Abramichev on 24/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

struct User: Decodable {
    let id: Int
    let name: String
    let job_codeid: Int
    let created: DateTime
}
