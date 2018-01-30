//
//  Task.swift
//  OpenAirSwift_iOS
//
//  Created by Vladimir Abramichev on 24/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

public class Task: OpenAirDTO {
    let date: OpenAirDate
    let hours: Int
    let timesheetid: String
    let userid: String
    let projectid: String
    let projecttaskid: String
    
    public init(date: Date, hours: Int, timesheetid: String, userid: String, projectid: String, projecttaskid: String) {
        self.date = OpenAirDate(year: date.year, month: date.month, day: date.day)
        self.hours = hours
        self.timesheetid = timesheetid
        self.userid = userid
        self.projectid = projectid
        self.projecttaskid = projecttaskid
    }
}