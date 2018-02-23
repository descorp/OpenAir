//
//  APIAccessProviderTests.swift
//  OnboardingTests
//
//  Created by Vladimir Abramichev on 08/02/2018.
//  Copyright © 2018 Mobiquity. All rights reserved.
//

import Foundation
import Quick
import Nimble
#if os(iOS)
    @testable import OpenAirSwift_iOS
#else
    @testable import OpenAirSwift_Mac
#endif

class APIAccessProviderTests: QuickSpec {
    
    override func spec() {
        
        describe("Testing APIAccessProvider") {
            it("APIAccessProvider throw error whet URL is invalid") {
                let sut = APIAccessProvider(url: "some url")
                var result: OpenAirError!
                sut.request(payload: "some payload").catch { error in
                    result = error as! OpenAirError
                }
                
                expect(result).toEventually(equal(OpenAirError.urlError))
            }
            
            it("APIAccessProvider can make network request") {
                let sut = APIAccessProvider(url: "https://www.openair.com/api.pl")
                let payload =
                """
                <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
                <request API_ver="1.0" client="testTool" client_ver="1.0" namespace="default" key="SomeKey">
                    <Time/>
                </request>
                """
                var result: String!
                
                
                sut.request(payload: payload).then { responce in
                    result = responce
                }
                
                expect(result).toEventuallyNot(beNil(), timeout: 10000)
            }
        }
    }
}
