//
//  OpenAirDateTests.swift
//  OpenAirSwift
//
//  Created by Vladimir Abramichev on 29/01/2018.
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


class OpenAirDateTests: QuickSpec {
    
    override func spec() {
        describe("OpenAir Date DTO object") {
            it("can be created from Date") {
                let date = Date()
                let sut = OpenAirDate(from: date)
                
                expect(sut.year).to(equal(date.year))
                expect(sut.month).to(equal(date.month))
                expect(sut.day).to(equal(date.day))
                expect(sut.hour).to(equal(date.hour))
                expect(sut.minute).to(equal(date.minute))
                expect(sut.second).to(equal(date.second))
            }
            
            it("can be created from parameters directly") {
                let year = 2018
                let month = 12
                let day = 30
                let hour = 12
                let minute = 44
                let second = 55
                
                let sut = OpenAirDate(year: year,
                                      month: month,
                                      day: day,
                                      hour: hour,
                                      minute: minute,
                                      second: second)
                
                expect(sut.year).to(equal(year))
                expect(sut.month).to(equal(month))
                expect(sut.day).to(equal(day))
                expect(sut.hour).to(equal(hour))
                expect(sut.minute).to(equal(minute))
                expect(sut.second).to(equal(second))
            }
            
            it("can be represented as xml") {
                let date = Date()
                let sut = OpenAirDate(from: date)
                
                let actual =
                """
                <Date>
                    <year>\(date.year)</year>
                    <month>\(date.month)</month>
                    <day>\(date.day)</day>
                    <hour>\(date.hour)</hour>
                    <minute>\(date.minute)</minute>
                    <second>\(date.second)</second>
                </Date>
                """
                
                expect(sut.xml.minifyedXml).to(equal(actual.minifyedXml))
            }
            
            it("can be represented as aprtial xml") {
                let year = 2018
                let month = 12
                let day = 30
                let hour = 12
                
                let sut = OpenAirDate(year: year,
                                      month: month,
                                      day: day,
                                      hour: hour)
                
                let actual =
                """
                <Date>
                    <year>\(year)</year>
                    <month>\(month)</month>
                    <day>\(day)</day>
                    <hour>\(hour)</hour>
                </Date>
                """
                
                expect(sut.xml.minifyedXml).to(equal(actual.minifyedXml))
            }
        }
    }
}


