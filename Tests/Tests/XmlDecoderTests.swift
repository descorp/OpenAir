//
//  XmlDecoderTests.swift
//  OnboardingTests
//
//  Created by Vladimir Abramichev on 09/02/2018.
//  Copyright © 2018 Mobiquity. All rights reserved.
//

import Foundation
import Quick
import Nimble
import SwiftyXMLParser
@testable import Onboarding

class XmlDecoderTests: QuickSpec {
    
    override func spec() {
        
        describe("Testing XmlDecoder") {
            
            it("can create Decoder from User XML") {
                let xml = XML.parse(FileLoader.load(name: "UserExample"))
                let userElement = xml.element!.childElements.first!
                let decoder = XmlDecoder(node: userElement)

                let user = try! User(from: decoder)
                expect(user).toNot(beNil())
                expect(user.name).to(equal("Userovich, User"))
                expect(user.id).to(equal(1445))
                expect(user.created.year).toNot(beNil())
                expect(user.created.month).toNot(beNil())
                expect(user.created.day).toNot(beNil())
            }
        }
    }
}





