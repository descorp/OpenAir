//
//  StringExtensions.swift
//  OpenAirSwift_iOS
//
//  Created by Vladimir Abramichev on 29/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

extension String {
    var minifyedXml: String {
        return self.components(separatedBy: .newlines).map{ $0.trimmingCharacters(in: .whitespaces)}.joined()
    }
}
