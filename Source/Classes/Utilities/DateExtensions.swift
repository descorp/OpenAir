//
//  NSDate+Utilities.swift
//  OpenAir
//
//  Created by Sameh Mabrouk on 28/12/16.
//  Updatef by Vladimir Abramichev on 30/01/2018.
//  Copyright © 2016 Sameh Mabrouk. All rights reserved.
//

import Foundation

/// extension to Date that get start date of current week. It uses Gregorian calendar with Monday set as a first day in the week
extension Date {
    struct GregorianCalendar {
        static var UTC: Calendar {
            get {
                var calendar = Calendar(identifier: .gregorian)
                calendar.timeZone = TimeZone(secondsFromGMT: 0)!
                return calendar
            }
        }
    }

    /// Get start of the week date
    public func startOfWeek(starts: DayOfWeek = .Mon) -> Date {
        var components = GregorianCalendar.UTC.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        components.weekday = (starts.rawValue % 6) + 2 - (starts.rawValue / 6)
        return GregorianCalendar.UTC.date(from: components)!
    }

    /// Get end of the week date
    public func endOfWeek(starts: DayOfWeek = .Mon) -> Date {
        return startOfWeek(starts: starts).add(days: 7)
    }
}

/// Provide access to date components
extension Date {
    
    /// Get year form date
    public var year: Int {
        return GregorianCalendar.UTC.component(.year, from: self)
    }
    
    /// Get month form date
    public var month: Int {
        return GregorianCalendar.UTC.component(.month, from: self)
    }
    
    /// Get day form date
    public var day: Int {
        return GregorianCalendar.UTC.component(.day, from: self)
    }
    
    /// Get hour form date
    public var hour: Int {
        return GregorianCalendar.UTC.component(.hour, from: self)
    }
    
    /// Get minute form date
    public var minute: Int {
        return GregorianCalendar.UTC.component(.minute, from: self)
    }
    
    /// Get second form date
    public var second: Int {
        return GregorianCalendar.UTC.component(.second, from: self)
    }
    
    /// Get timezone form date
    public var timezone: Int {
        return GregorianCalendar.UTC.component(.timeZone, from: self)
    }
}

/// Provide usefull operatins on date
extension Date {
    
    /// Add specific amount of years to the date
    public func add(years: Int) -> Date {
        return GregorianCalendar.UTC.date(byAdding: DateComponents(year: years), to: self)!
    }
    
    /// Add specific amount of months to the date
    public func add(months: Int) -> Date {
        return GregorianCalendar.UTC.date(byAdding: DateComponents(month: months), to: self)!
    }
    
    /// Add specific amount of days to the date
    public func add(days: Int) -> Date {
        return GregorianCalendar.UTC.date(byAdding: DateComponents(day: days), to: self)!
    }
    
    /// Add specific amount of hours to the date
    public func add(hours: Int) -> Date {
        return GregorianCalendar.UTC.date(byAdding: DateComponents(hour: hours), to: self)!
    }
    
    /// Add specific amount of minutes to the date
    public func add(minutes: Int) -> Date {
        return GregorianCalendar.UTC.date(byAdding: DateComponents(minute: minutes), to: self)!
    }
    
    /// Add specific amount of seconds to the date
    public func add(seconds: Int) -> Date {
        return GregorianCalendar.UTC.date(byAdding: DateComponents(second: seconds), to: self)!
    }

    /// Add specific amount of seconds to the date
    public static func dateFromComponents(dateComponents: DateComponents) -> Date?{
        return GregorianCalendar.UTC.date(from: dateComponents)
    }
    
    /// Get short date representation of date in format YYYY-MM-DD
    public var shortISO8610: String {
        return String.init(format: "%.2d-%.2d-%.2d", self.year, self.month, self.day)
    }
}
