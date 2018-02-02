//
//  APIAccessProvider.swift
//  OpenAirSwift_iOS
//
//  Created by Vladimir Abramichev on 02/02/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import PromiseKit

let OPEN_AIR_URL = "https://www.openair.com/api.pl"

public struct APIAccessProvider :  APIAccessProviderType {
    
    private var session = URLSession.shared
    let netSuitServerBaseURL: String
    
    init() {
        self.init(url: OPEN_AIR_URL)
    }
    
    public init(url: String) {
        netSuitServerBaseURL = url
    }
    
    public func request(payload xml: String) -> Promise<String> {
        guard let payload = xml.data(using: String.Encoding.utf8, allowLossyConversion: false) else {
            return Promise<String>(error: OpenAirError.payloadError)
        }
        
        guard let url = URL(string: netSuitServerBaseURL) else {
            return Promise<String>(error: OpenAirError.urlError)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = payload
        
        return session.dataTask(with: request).asString()
    }
}
