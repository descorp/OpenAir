//
//  TimeIntervalExtensions.swift
//  OpenAirSwift_iOS
//
//  Created by Vladimir Abramichev on 29/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

extension TimeInterval {
    
    public static func inHours(_ value: Int) -> TimeInterval {
        return TimeInterval(3600 * value)
    }
    
    public static func inDays(_ value: Int) -> TimeInterval {
        return TimeInterval(3600 * 24 * value)
    }
    
    public static func inMinutes(_ value: Int) -> TimeInterval {
        return TimeInterval(60 * value)
    }
    
    public var hours: Int {
        return Int(self) / 3600
    }
    
    public var days: Int {
        return Int(self) / 3600 / 24
    }
    
    public var minutes: Int {
        return (Int(self) / 60 ) % 60
    }
}
