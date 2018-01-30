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
    
    public var description: String {
        get {
            return DayOfWeek.names[self]!
        }
    }
    
    public var dayNumber: Int {
        get {
            return self.rawValue
        }
    }
    
    private static let names = [DayOfWeek.Mon: "Monday",
                                DayOfWeek.Tue: "Tuesday",
                                DayOfWeek.Wed: "Wednesday",
                                DayOfWeek.Thu: "Thursday",
                                DayOfWeek.Fri: "Friday",
                                DayOfWeek.Sat: "Saturday",
                                DayOfWeek.Sun: "Sunday" ]
    
    public static func at(number: Int) -> DayOfWeek {
        return DayOfWeek.init(rawValue: number % 7)!
    }
}

