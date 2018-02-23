//
//  XMLParserParsingTests.swift
//  OpenAirTool
//
//  Created by Vladimir Abramichev on 02/02/2018.
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

class XMLParserParsingTests: QuickSpec {
    
    override func spec() {
        
        describe("Testing XMLParer's parsing capabilities") {
            
            let limit = 1
            let login = Login(user: "login", password: "password", company: "company")
            let commands: [Command] = [.auth(login: login),
                                       .read(dataType: "User",
                                             body: [],
                                             attributes: [.method(.all),
                                                          .limit(limit)])]
            let sut: XMLParserType = OpenAirXMLParser(commands)
            
            it("throw error if XML invalid") {
                var result: OpenAirError!
                let actual = OpenAirError.invalidResponce
                
                sut.parse(xml: "<>").catch{ error in
                    result = error as? OpenAirError
                }
                
                expect(result).toEventuallyNot(beNil())
                expect(result).toEventually(equal(actual))
            }
            
            it("throw error if XML empty") {
                var result: OpenAirError!
                let actual = OpenAirError.invalidResponce
                
                sut.parse(xml: "").catch{ error in
                    result = error as? OpenAirError
                }
                
                expect(result).toEventuallyNot(beNil())
                expect(result).toEventually(equal(actual))
            }
            
            it("throw error for responce with error") {
                let actual = OpenAirError.responce(505, "The namespace and key do not match")
                var result: OpenAirError!
                
                sut.parse(xml: errorResponce).catch { error in
                    result = error as? OpenAirError
                }
                
                expect(result).toEventuallyNot(beNil())
                expect(result).toEventually(equal(actual))
            }
            
            it("can parse auth XML responce") {
                var result: Responce!
                let data = FileLoader.load(name: "AuthResponceExample")
                sut.parse(xml: data).then { responce in
                    result = responce
                }

                expect(result).toEventuallyNot(beNil())
                expect(result.status).toEventually(beNil())
                expect(result.responces).toEventuallyNot(beEmpty())
                expect(result.responces[0]).toEventuallyNot(beNil())
                expect(result.responces[0].status).toEventually(equal(0))
                expect(result.responces[0].origine.name).toEventually(equal(commands[0].name))
                expect(result.responces[0].content).toEventually(beNil())

                expect(result.responces[1]).toEventuallyNot(beNil())
                expect(result.responces[1].status).toEventually(equal(0))
                expect(result.responces[1].origine.name).toEventually(equal(commands[1].name))
                expect(result.responces[1].content).toEventuallyNot(beNil())
                
                let user: User = try! result.responces[1].get()
                expect(user).toEventuallyNot(beNil())
            }
            
            it("can parse getProjects XML responce") {
                var result: Responce!
                let data = FileLoader.load(name: "GetProjectsResponceExample")
                sut.parse(xml: data).then { responce in
                    result = responce
                }
                
                expect(result).toEventuallyNot(beNil())
                expect(result.status).toEventually(beNil())
                expect(result.responces).toEventuallyNot(beEmpty())
                expect(result.responces[0]).toEventuallyNot(beNil())
                expect(result.responces[0].status).toEventually(equal(0))
                expect(result.responces[0].origine.name).toEventually(equal(commands[0].name))
                expect(result.responces[0].content).toEventually(beNil())
                
                expect(result.responces[1]).toEventuallyNot(beNil())
                expect(result.responces[1].status).toEventually(equal(0))
                expect(result.responces[1].origine.name).toEventually(equal(commands[1].name))
                expect(result.responces[1].content).toEventuallyNot(beEmpty())
                expect(result.responces[1].content!.count).toEventuallyNot(equal(44))
                
                let projects: [Project] = try! result.responces[1].getCollection()
                expect(projects).toEventuallyNot(beNil())
                expect(projects[0]).toEventuallyNot(beNil())
                expect(projects[0].name).toEventually(equal("Administrative"))
            }
            
            it("can parse successfull empty read responce") {
                var result: Responce!
                sut.parse(xml: noErrorEmptyResponce).then { responce in
                    result = responce
                }
                
                expect(result).toEventuallyNot(beNil())
                expect(result.status).toEventually(beNil())
                expect(result.responces).toEventuallyNot(beEmpty())
                expect(result.responces[0]).toEventuallyNot(beNil())
                expect(result.responces[0].status).toEventually(equal(0))
                expect(result.responces[0].origine.name).toEventually(equal(commands[0].name))
                expect(result.responces[0].content).toEventually(beNil())
                
                expect(result.responces[1]).toEventuallyNot(beNil())
                expect(result.responces[1].status).toEventually(equal(0))
                expect(result.responces[1].origine.name).toEventually(equal(commands[1].name))
                expect(result.responces[1].content).toEventually(beNil())
            }
        }
    }
}

let errorResponce =
"""
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<response status="505">The namespace and key do not match</response>
"""

let anauthorisedResponce =
"""
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<response>
    <Auth status = "401"></Auth >
    <Read status = "2"></Read >
</response>
"""

let noErrorEmptyResponce =
"""
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<response>
    <Auth status = "0"></Auth >
    <Read status = "0"></Read >
</response>
"""

