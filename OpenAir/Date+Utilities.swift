//
//  NSDate+Utilities.swift
//  OpenAir
//
//  Created by Sameh Mabrouk on 28/12/16.
//  Copyright © 2016 Sameh Mabrouk. All rights reserved.
//

import Foundation

typealias CalendarDateComponents = (Int, Int, Int)

/** extension to Date that get start date of current week, in Gregorian calendar Sunday is first day in the week **/
extension Date {
    struct Gregorian {
        static let calendar = Calendar(identifier: .gregorian)
    }
    var startOfWeek: Date? {
        return Gregorian.calendar.date(from: Gregorian.calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
    }
    
    var endOfWeek: Date? {
        return Gregorian.calendar.date(byAdding: .day, value: 6, to: startOfWeek!)
    }
    
    var calendarComponents: CalendarDateComponents? {
        let currentYear = Gregorian.calendar.component(.year, from: self)
        let currentMonth = Gregorian.calendar.component(.month, from: self)
        let currentDay = Gregorian.calendar.component(.day, from: self)
        
        return (currentYear, currentMonth, currentDay)
    }
    
    func days(days:Int) -> Date? {
        var dayComponenet = DateComponents()
        dayComponenet.day = days
        
        guard let days =  Gregorian.calendar.date(byAdding: dayComponenet, to: self) else { return nil}
        return days
    
    }
    
    func dateComponentsByAddingDays(days: Int) -> Date? {
        return self.days(days: days)
    }
    
    static func dateFromComponents(dateComponents: DateComponents) -> Date?{
        return Gregorian.calendar.date(from: dateComponents)
    }
}
