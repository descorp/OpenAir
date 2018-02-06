//
//  XMLParserValidationTests.swift
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

var BigXmlExample =
    """
    <?xml version="1.0"?>
        <catalog>
            <book id="bk101">
                <author>Gambardella, Matthew</author>
                <title>XML Developer's Guide</title>
                <genre>Computer</genre>
                <price>44.95</price>
                <publish_date>2000-10-01</publish_date>
                <description>An in-depth look at creating applications with XML.</description>
            </book>
            <book id="bk102">
                <author>Ralls, Kim</author>
                <title>Midnight Rain</title>
                <genre>Fantasy</genre>
                <price>5.95</price>
                <publish_date>2000-12-16</publish_date>
                <description>A former architect battles corporate zombies, an evil sorceress, and her own childhood to become queen of the world.</description>
            </book>
        <catalog>
    """

class XMLParserValidationTests: QuickSpec {
    
    override func spec() {
        
        var sut: XMLParserType!
        
        describe("Testing XMLParer's validation capabilities") {
            
            beforeEach {
                sut = OpenAirXMLParser()
            }
            
            it("can validate empty string") {
                expect(sut.isValid(xml: "")).to(beFalse())
            }
            
            it("can validate XML-like string") {
                expect(sut.isValid(xml: "< \" \" < ' ' >>")).to(beTrue())
            }
            
            it("can validate unbalanced XML-like string") {
                expect(sut.isValid(xml: "< \" < \" ' ' >>")).to(beFalse())
            }
            
            it("can validate unbalanced XML-like string") {
                expect(sut.isValid(xml: "< \" < \" ' > ' ")).to(beFalse())
            }
            
            it("can validate non xml") {
                expect(sut.isValid(xml: "XMLParserValidationTests.bigXmlExample")).to(beFalse())
            }
            
            it("can validate simple xml") {
                expect(sut.isValid(xml: BigXmlExample)).to(beTrue())
            }
        }
    }
}
