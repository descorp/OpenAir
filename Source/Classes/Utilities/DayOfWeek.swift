//
//  DayOfWeek.swift
//  OpenAir
//
//  Created by Sameh Mabrouk on 11/01/17.
//  Copyright © 2017 Sameh Mabrouk. All rights reserved.
//

import Foundation

public enum DayOfWeek: Int {
    case Mon = 0
    case Tue = 1
    case Wed = 2
    case Thu = 3
    case Fri = 4
    case Sat = 5
    case Sun = 6
    
    public var name: String {
        get {
            return DayOfWeek.names[self]!
        }
    }
    
    public var dayNumber: Int {
        get {
            return self.rawValue
        }
    }
    
    private static let names = [DayOfWeek.Mon: NSLocalizedString("Monday", comment: "Monday"),
                                DayOfWeek.Tue: NSLocalizedString("Tuesday", comment: "Tuesday"),
                                DayOfWeek.Wed: NSLocalizedString("Wednesday", comment: "Wednesday"),
                                DayOfWeek.Thu: NSLocalizedString("Thursday", comment: "Thursday"),
                                DayOfWeek.Fri: NSLocalizedString("Friday", comment: "Friday"),
                                DayOfWeek.Sat: NSLocalizedString("Saturday", comment: "Saturday"),
                                DayOfWeek.Sun: NSLocalizedString("Sunday", comment: "Sunday") ]
    
    public static func at(number: Int) -> DayOfWeek {
        return DayOfWeek.init(rawValue: number % 7)!
    }
}

