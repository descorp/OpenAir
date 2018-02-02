//
//  XMLParser.swift
//  OpenAirSwift_iOS
//
//  Created by Vladimir Abramichev on 02/02/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import SwiftyXMLParser
import PromiseKit

struct XMLParser: XMLParserType {
    func isValid(xml: String) -> Bool {
        return xml.st
    }
    
    func parse<T>(xml: String) -> Promise<T> {
        return Promise<T>.init(error: OpenAirError.parsingError)
    }
}
