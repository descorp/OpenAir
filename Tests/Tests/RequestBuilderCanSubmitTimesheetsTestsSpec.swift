//
//  RequestBuilderCanSubmitTimesheetsTestsSpec.swift
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

class RequestBuilderCanSubmitTimesheetsTestsSpec: QuickSpec {
    
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
            
            it("can create request to submit the timesheet ") {
                
                let timesheetId = ""
                let login = Login(login: userName, password: password, company: company)
                let timesheet = Timesheet(id: timesheetId)
                let request = requestBuilder.create(.auth(login: login),
                                                    .submit(timesheet, approval: nil))
                
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
                    <Submit type="Timesheet">
                        <Timesheet>
                            <id>\(timesheetId)</id>
                        </Timesheet>
                    </Submit>
                </request>
                """
                
                expect(request).toNot(beNil())
                expect(request).to(equal(actual.minifyedXml))
            }
        }
    }
}

