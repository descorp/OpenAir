//
//  OpenAirManager.swift
//  OpenAirSwift
//
//  Created by Vladimir Abramichev on 01/02/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

let OPEN_AIR_URL = "https://www.openair.com/api.pl"

public typealias OpenairAPIManagerCompletionHandler = (_ success: Bool, _ result: Any?) -> ()

import Foundation

public protocol Responce {
    var origine: Command { get }
    var content: [String: Any] { get }
}

public protocol Promise {
    var responces: [Responce] { get }
}

private class PromiseClass: Promise {
    var responces = [Responce]()
}

/** This class manage all XML API requests to OpenAir **/
public class OpenairAPIManager: NSObject {
    
    // XML API constants
    let netSuitServerBaseURL: String
    let builder: RequestBuilder
    
    private var session = URLSession.shared
    
    /**
     
     Initiate new instance of manager to access OpenAir API
     
     The namespace and APIkey parameters are used to verify that
     the request is coming from a valid partner that has permission to use OpenAir API
     
     - Parameters:
     - request: configuration of request.
     - address: Url of your OpenAir server. By default OpenAir XML API address
     **/
    public init(with config: RequestConfiguration, byUrl address: String) {
        self.builder = RequestBuilder(for: config)
        self.netSuitServerBaseURL = address
    }
    
    /**
     
     Initiate new instance of manager to access OpenAir API
     
     The namespace and APIkey parameters are used to verify that
     the request is coming from a valid partner that has permission to use default OpenAir API
     
     - Parameters:
     - apiKey: secret APIKey of your organisation.
     - nameSpace: namespace of your organisation. By default value is *default*
     **/
    public convenience init(with config: RequestConfiguration) {
        self.init(with: config, byUrl: OPEN_AIR_URL)
    }
    
    public func request(_ commands: Command...) -> Promise {
        let xml = builder.create(commands as [Command])
        
        if let payload = xml.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            sendRequest(requestPayload: payload)
        }
        
        return PromiseClass()
    }
    
    func sendRequest(requestPayload: Data) {
        
        guard let url = URL(string: netSuitServerBaseURL) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = requestPayload
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                
            }
        }
        task.resume()
    }
}

