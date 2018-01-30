//
//  RequestBuilderCanAuthenticateTestsSpec.swift
//  OpenAirSwift
//
//  Created by Vladimir Abramichev on 25/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble

#if os(iOS)
    @testable import OpenAirSwift_iOS
#else
    @testable import OpenAirSwift_Mac
#endif


class RequestBuilderCanAuthenticateTestsSpec: QuickSpec {

    override func spec() {
        describe("Request builder tests") {

            let apiKey = "apiKey"
            let namespace = "namespace"
            let company = "company"
            let userName = "userName"
            let password = "password"
            let client = "tests app"
            let client_ver = "0.1.0"
            
            let request = RequestConfiguration(key: apiKey, namespace: namespace, client: client, client_ver: client_ver)
            let requestBuilder = RequestBuilder(for: request)
            
            it("can create Auth request") {
                
                let datatype = "User"
                let method = "all"
                let limit = 1
                
                let login = Login(login: userName, password: password, company: company)
                let request = requestBuilder.create(.auth(login: login), .readSimple(dataType: datatype, attributes: [.method(.all), .limit(limit)]))
                
                let actual =
                """
                <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
                <request API_ver="1.0" client="\(client)" client_ver="\(client_ver)" namespace="\(namespace)" key="\(apiKey)">
                    <Auth>
                        <Login>
                            <user>\(userName)</user>
                            <password>\(password)</password>
                            <company>\(company)</company>
                        </Login>
                    </Auth>
                    <Read type="\(datatype)" method="\(method)" limit="\(limit)"></Read>
                </request>
                """
                
                expect(request).toNot(beNil())
                expect(request).to(equal(actual.minifyedXml))
            }
        }
    }
}
