//
//  DateExtensionsTests.swift
//  OpenAirSwift
//
//  Created by Vladimir Abramichev on 30/01/2018.
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

class DateExtensionsTests: QuickSpec {
    
    override func spec() {
        describe("Testing Date components") {
            var sut: Date!
            
            beforeEach {
                // Tuesday, 30 January 2018 07:56:55
                sut = Date(timeIntervalSince1970: 1517299015)
            }
            
            it("can get date components from Date") {
                expect(sut.year).to(equal(2018))
                expect(sut.month).to(equal(1))
                expect(sut.day).to(equal(30))
                expect(sut.hour).to(equal(7))
                expect(sut.minute).to(equal(56))
                expect(sut.second).to(equal(55))
            }
            
            it("can get short date format") {
                expect(sut.shortISO8610).to(equal("2018-01-30"))
            }
            
            it("can add components to the date") {
                expect(sut.add(years: 2).year).to(equal(2020))
                expect(sut.add(months: 2).month).to(equal(3))
                expect(sut.add(days: 2).day).to(equal(1))
                expect(sut.add(hours: 2).hour).to(equal(9))
                expect(sut.add(minutes: 5).minute).to(equal(1))
                expect(sut.add(seconds: 6).second).to(equal(1))
            }
            
            it("can get start of the week date (starting from Monday) ") {
                let startOfTheWeek = sut.startOfWeek()
                expect(startOfTheWeek.year).to(equal(2018))
                expect(startOfTheWeek.month).to(equal(1))
                expect(startOfTheWeek.day).to(equal(29))
                expect(startOfTheWeek.hour).to(equal(0))
                expect(startOfTheWeek.minute).to(equal(0))
                expect(startOfTheWeek.second).to(equal(0))
            }
            
            it("can get start of the week date (starting from Sunday) ") {
                let startOfTheWeek = sut.startOfWeek(starts: .Sun)
                expect(startOfTheWeek.year).to(equal(2018))
                expect(startOfTheWeek.month).to(equal(1))
                expect(startOfTheWeek.day).to(equal(28))
                expect(startOfTheWeek.hour).to(equal(0))
                expect(startOfTheWeek.minute).to(equal(0))
                expect(startOfTheWeek.second).to(equal(0))
            }
            
            it("can get end of the week date (starting from Monday) ") {
                let endOfTheWeek = sut.endOfWeek()
                expect(endOfTheWeek.year).to(equal(2018))
                expect(endOfTheWeek.month).to(equal(2))
                expect(endOfTheWeek.day).to(equal(5))
                expect(endOfTheWeek.hour).to(equal(0))
                expect(endOfTheWeek.minute).to(equal(0))
                expect(endOfTheWeek.second).to(equal(0))
            }
            
            it("can get end of the week date (starting from Sunday) ") {
                let endOfTheWeek = sut.endOfWeek(starts: .Sun)
                expect(endOfTheWeek.year).to(equal(2018))
                expect(endOfTheWeek.month).to(equal(2))
                expect(endOfTheWeek.day).to(equal(4))
                expect(endOfTheWeek.hour).to(equal(0))
                expect(endOfTheWeek.minute).to(equal(0))
                expect(endOfTheWeek.second).to(equal(0))
            }
        }
    }
}

