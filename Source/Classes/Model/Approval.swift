//
//  Approval.swift
//  OpenAirSwift
//
//  Created by Vladimir Abramichev on 31/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

public class Approval: OpenAirDTO {
    let cc: String
    let note: String
    
    public init(cc: String, note: String) {
        self.cc = cc
        self.note = note
    }
}
