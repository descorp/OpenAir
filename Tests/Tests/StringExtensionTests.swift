//
//  StringExtensionTests.swift
//  OpenAirSwift
//
//  Created by Vladimir Abramichev on 07/02/2018.
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

class StringExtensionsTests: QuickSpec {
    
    override func spec() {
        describe("Testing Command.name method") {
            it("Can get name from Time command") {
                let command = Command.time
                
                expect(command.name).to(equal("time"))
            }
            
            it("Can get name from Read command") {
                
                let command = Command.read(dataType: "User", body: [], attributes: [.limit(1)])
                
                expect(command.name).to(equal("read"))
            }
        }
    }
}
