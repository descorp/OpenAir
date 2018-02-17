//
//  RequestBuilderCanAddTimesheetsTestsSpec.swift
//  OpenAirSwift
//
//  Created by Vladimir Abramichev on 25/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Onboarding

class RequestBuilderCanAddTimesheetsTestsSpec: QuickSpec {
    
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
            
            it("can create request to add timesheet") {
                
                let startDate = Date()
                let endDate = Date()
                let userid = "userid"
                
                let login = Login(login: userName, password: password, company: company)
                let timesheet = Timesheet(starts: startDate, ends: endDate, userid: userid)
                let request = requestBuilder.create(.auth(login: login), .add(timesheet))
                
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
                    <Add type="Timesheet">
                        <Timesheet>
                            <name>\(startDate.shortISO8610) to \(endDate.shortISO8610)</name>
                            <userid>\(userid)</userid>
                            <starts>
                                <Date>
                                    <year>\(startDate.year)</year>
                                    <month>\(startDate.month)</month>
                                    <day>\(startDate.day)</day>
                                </Date>
                            </starts>
                            <ends>
                                <Date>
                                    <year>\(endDate.year)</year>
                                    <month>\(endDate.month)</month>
                                    <day>\(endDate.day)</day>
                                </Date>
                            </ends>
                        </Timesheet>
                    </Add>
                </request>
                """
                
                expect(request).toNot(beNil())
                expect(request).to(equal(actual.minifiedXml))
            }
        }
    }
}

