//
//  RequestBuilderCanGetSpecificTimesheetsTestsSpec.swift
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

class RequestBuilderCanGetSpecificTimesheetsTestsSpec: QuickSpec {
    
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
            
            it("can create request to get timesheet for specific date") {
                
                let method = "all"
                let filter = "date-equal-to"
                let limit = 1
                let field = "starts"
                let date = Date()
                
                let login = Login(login: userName, password: password, company: company)
                let specificDate = DateTime(year: date.year, month: date.month, day: date.day)
                let request = requestBuilder.create(.auth(login: login),
                                                    .read(dataType: "Timesheet",
                                                          body: [specificDate],
                                                          attributes: [.method(.all),
                                                                       .limit(limit),
                                                                       .filter(filter),
                                                                       .field(field)]))
                
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
                    <Read type="Timesheet" method="\(method)" limit="\(limit)" filter="\(filter)" field="\(field)">
                        <Date>
                            <year>\(date.year)</year>
                            <month>\(date.month)</month>
                            <day>\(date.day)</day>
                        </Date>
                    </Read>
                </request>
                """
                
                expect(request).toNot(beNil())
                expect(request).to(equal(actual.minifiedXml))
            }
        }
    }
}

