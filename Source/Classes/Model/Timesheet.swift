//
//  Timesheet.swift
//  OpenAirSwift_iOS
//
//  Created by Vladimir Abramichev on 24/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

public class Timesheet: OpenAirOutgoingDTO {
    
    let id: String?
    let name: String?
    let userid: String?
    let starts: DateTime?
    let ends: DateTime?
    
    public init(starts: Date, ends: Date, userid: String, name: String? = nil) {
        self.name = name ?? "\(starts.shortISO8610) to \(ends.shortISO8610)"
        self.starts = DateTime(year: starts.year, month: starts.month, day: starts.day)
        self.ends = DateTime(year: ends.year, month: ends.month, day: ends.day)
        self.userid = userid
        id = nil
    }
    
    public init(id: String) {
        self.id = id
        starts = nil
        ends = nil
        name = nil
        userid = nil
    }
}
