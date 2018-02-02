//
//  XMLParserType.swift
//  OpenAirSwift_iOS
//
//  Created by Vladimir Abramichev on 02/02/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import PromiseKit

protocol XMLParserType {
    func parse<T>(xml: String) -> Promise<T>
    func isValid(xml: String) -> Bool
}