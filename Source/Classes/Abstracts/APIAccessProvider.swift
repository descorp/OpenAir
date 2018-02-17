//
//  APIAccessProvider.swift
//  OpenAirSwift_iOS
//
//  Created by Vladimir Abramichev on 02/02/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import PromiseKit

public protocol APIAccessProviderType {
    func request(payload xml: String) -> Promise<String>
}
