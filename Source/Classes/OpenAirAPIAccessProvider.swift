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
    private let HttpMethod = "POST"
    private let session = URLSession.shared
    let baseURL: String
    
    init() {
        self.init(url: OPEN_AIR_URL)
    }
    
    public init(url: String) {
        baseURL = url
    }
    
    public func request(payload xml: String) -> Promise<String> {
        guard
            let payload = xml.data(using: String.Encoding.utf8, allowLossyConversion: false)
        else {
            return Promise<String>(error: OpenAirError.payloadGenerationError)
        }
        
        guard let url = URL(string: baseURL) else {
            return Promise<String>(error: OpenAirError.urlError)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod
        request.httpBody = payload
        
        return session.dataTask(with: request).asString()
    }
}
