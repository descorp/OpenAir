//
//  RequestBuilderCanGetProjectsTasksTestsSpec.swift
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

class RequestBuilderCanGetProjectsTasksTestsSpec: QuickSpec {
    
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
            
            it("can create request to get project's tasks") {
                
                let limit = 10
                let projectId = "projectId"
                
                let login = Login(login: userName, password: password, company: company)
                let projectTask = ProjectTask(projectId: projectId)
                let request = requestBuilder.create(.auth(login: login),
                                                    .readObject(data: projectTask, attributes: [.method(.equalTo),.limit(limit)]))
                
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
                    <Read type="Projecttask" method="equal to" limit="\(limit)">
                        <Projecttask>
                            <projectid>\(projectId)</projectid>
                        </Projecttask>
                    </Read>
                </request>
                """
                
                expect(request).toNot(beNil())
                expect(request).to(equal(actual.minifiedXml))
            }
        }
    }
}

