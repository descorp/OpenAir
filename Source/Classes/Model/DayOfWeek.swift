//
//  DayOfWeek.swift
//  OpenAir
//
//  Created by Sameh Mabrouk on 11/01/17.
//  Copyright © 2017 Sameh Mabrouk. All rights reserved.
//

import Foundation

public enum DayOfWeek: String {
    case Monday = "Monday"
    case Tuesday = "Tuesday"
    case Wednesday = "Wednesday"
    case Thursday = "Thursday"
    case Friday = "Friday"
    case Saturday = "Saturday"
    case Sunday = "Sunday"
    
    
    public var description: String {
        get {
            return self.rawValue
        }
    }
    
    public var dayNumber: Int {
        get {
            return self.hashValue
        }
    }
    
    private static let days = [Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday]
    
    public static func fromNumber(number: Int) -> DayOfWeek {
        // FIXME check number index out of bounds
        return days[number]
    }
}
