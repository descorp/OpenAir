//
//  Date.swift
//  OpenAirSwift_iOS
//
//  Created by Vladimir Abramichev on 24/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

public struct DateTime: XmlEncodable, Decodable {
    
    let year: Int?
    let month: Int?
    let day: Int?
    let hour: Int?
    let minute: Int?
    let second: Int?
    
    /// Type of a data in OpenAir objects domain.
    /// For serialisation purposes you might want to have different implementations of the same datatype model
    public static var datatype: String {
        return "Date"
    }
    
    public init(from date: Date) {
        year = date.year
        month = date.month
        day = date.day
        hour = date.hour
        minute = date.minute
        second = date.second
    }
    
    init(year: Int, month: Int, day: Int, hour: Int? = nil, minute: Int? = nil, second: Int? = nil) {
        self.year = year
        self.month = month
        self.day = day
        self.hour = hour
        self.minute = minute
        self.second = second    
    }
}
