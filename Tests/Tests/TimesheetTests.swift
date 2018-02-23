//
//  TimesheetTests.swift
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

class TimesheetDtoTests: QuickSpec {
    
    override func spec() {
        describe("Timesheet DTO object") {
            it("can be presented as xml") {
                
                let startDate = Date()
                let endDate = Date().add(days: 3)
                let userid = "userid"
                
                let timesheet = Timesheet(starts: startDate, ends: endDate, userid: userid)
                
                let actual =
                """
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
                """
                
                expect(timesheet.xml).to(equal(actual.minifiedXml))
            }
        }
    }
}

