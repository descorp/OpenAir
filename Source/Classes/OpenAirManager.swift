//
//  OpenAirManager.swift
//  OpenAirSwift
//
//  Created by Vladimir Abramichev on 01/02/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import PromiseKit

public enum OpenAirError: Error {
    case requestTerminated
    case urlError
    case invalidResponce
    case payloadGenerationError
    case requestParsingError
    case responceParsingError
    case responce(Int, String)
    case noContent
}

extension OpenAirError: Equatable {
    public static func ==(lhs: OpenAirError, rhs: OpenAirError) -> Bool {
        return String(describing: lhs) == String(describing: rhs)
    }
}

/** This class manage all XML API requests to OpenAir **/
public class OpenairAPIManager: NSObject, ApiManagerProvider  {

    let builder: PayloadBuilderType
    let api: APIAccessProviderType
    
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
        self.api = APIAccessProvider(url: address)
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
        self.init(with: config)
    }
    
    fileprivate func request(_ commands: Command...) -> Promise<Responce> {
        let xml = builder.create(commands as [Command])
        return api.request(payload: xml).then { responeBody in
            let xmlParser = OpenAirXMLParser(commands)
            return xmlParser.parse(xml: responeBody)
        }
    }

    func authorizeUserWith(username: String, password: String, completion: @escaping (Bool, LoginError?) -> Void) {
        
        let login = Login(login: username, password: password, company: "Mobiquity")
        let response = request(.auth(login: login))
        
//        switch response.something {
//        case .success:
            completion(true, nil)
//        case let .failure(error, message):
//            completion(false, LoginError.wrongCredentials )
//        }
    }
}

