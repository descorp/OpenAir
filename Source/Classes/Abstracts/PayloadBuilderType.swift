//
//  PayloadBuilderType.swift
//  OpenAirSwift_iOS
//
//  Created by Vladimir Abramichev on 02/02/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

public protocol PayloadBuilderType {
    func create(command: Command) -> String
    func create(_ commands: Command...) -> String
    func create(_ commands: [Command]) -> String
}
