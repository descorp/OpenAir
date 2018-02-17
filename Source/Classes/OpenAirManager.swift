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
    case urlError
    case payloadError
    case requestParsingError
    case responceParsingError
}

/** This class manage all XML API requests to OpenAir **/
public class OpenairAPIManager: NSObject {
    
    let builder: PayloadBuilderType
    let xmlParser: XMLParserType
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
        self.xmlParser = OpenAirXMLParser()
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
    
    public func request(_ commands: Command...) -> Promise<Responce> {
        let xml = builder.create(commands as [Command])
        return api.request(payload: xml).then{ [weak self] responeBody in
            
            guard let strongSelf = self else {
                return Promise<Responce>(error: OpenAirError.urlError)
            }
            
            return strongSelf.xmlParser.parse(xml: responeBody)
        }
    }
}

