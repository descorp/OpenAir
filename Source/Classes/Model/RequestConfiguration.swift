//
//  Request.swift
//  OpenAirSwift_iOS
//
//  Created by Vladimir Abramichev on 24/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

public class RequestConfiguration {
    var API_version="1.0"
    let client_ver: String
    let client: String
    let namespace: String
    let key: String
    
    init(key: String,
         namespace: String = "deafult",
         client: String = "test app",
         client_ver: String = "1.0") {
        self.key = key
        self.namespace = namespace
        self.client = client
        self.client_ver = client_ver
    }
    
    var xmlHeader: String {
        return "<request API_ver=\"\(API_version)\" client=\"\(client)\" client_ver=\"\(client_ver)\" namespace=\"\(namespace)\" key=\"\(key)\">"
    }
    
    var xmlFooter: String {
        return "</request>"
    }
}
