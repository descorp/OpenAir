//
//  FileLoader.swift
//  OnboardingTests
//
//  Created by Vladimir Abramichev on 14/02/2018.
//  Copyright © 2018 Mobiquity. All rights reserved.
//

import Foundation

class FileLoader {
    static func load(name: String) -> Data {
        let bundle = Bundle(for: self)
        let path = bundle.path(forResource: name, ofType: "xml")!
        let referenceData = NSData(contentsOfFile: path)!
        return Data(referencing: referenceData)
    }
}
