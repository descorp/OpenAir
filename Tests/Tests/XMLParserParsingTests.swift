//
//  XMLParserParsingTests.swift
//  OpenAirTool
//
//  Created by Vladimir Abramichev on 02/02/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

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
        
        var sut: XMLParserType!
        
        describe("Testing XMLParer's parsing capabilities") {
            
            beforeEach {
                sut = OpenAirXMLParser()
            }
            
            it("can parse empty string") {
                let actual = "" as! Responce
                var result: Responce!
                
                sut.parse(xml: "").then{ responce in
                    result = responce as! Responce
                }
                
                expect(result).toNot(beNil())
                expect(result == actual).toEventually(beTrue())
            }
        }
    }
}

extension Responce: Comparable {
    
}
