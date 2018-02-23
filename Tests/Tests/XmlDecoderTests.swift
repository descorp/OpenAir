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
#if os(iOS)
    @testable import OpenAirSwift_iOS
#else
    @testable import OpenAirSwift_Mac
#endif

class XmlDecoderTests: QuickSpec {
    
    override func spec() {
        
        describe("Testing XmlDecoder") {
            
            it("can create Decoder from DateTime XML") {
                let xml = XML.parse(FileLoader.load(name: "DateTimeExample"))
                let userElement = xml.element!.childElements.first!
                let decoder = XmlDecoder(node: userElement)
                
                let date = try! DateTime(from: decoder)
                expect(date).toNot(beNil())
                expect(date.year).toNot(beNil())
                expect(date.month).toNot(beNil())
                expect(date.day).toNot(beNil())
            }
            
            it("can create Decoder from Addres XML") {
                let xml = XML.parse(FileLoader.load(name: "AddressExample"))
                let userElement = xml.element!.childElements.first!
                let decoder = XmlDecoder(node: userElement)
                
                let address = try! Address(from: decoder)
                expect(address).toNot(beNil())
                expect(address.first).toNot(beNil())
                expect(address.last).toNot(beNil())
                expect(address.email).toNot(beNil())
                expect(address.fax).to(beNil())
            }
            
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





