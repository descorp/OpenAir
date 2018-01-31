//
//  Command.swift
//  OpenAirSwift_iOS
//
//  Created by Vladimir Abramichev on 25/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

public enum Methods: String {
    case all
    case equalTo = "equal to"
    case notEqualTo = "not equal to"
    case order
    case notExported = "not exported"
}

public enum Attributes {
    case limit(Int)
    case filter(String)
    case field(String)
    case method(Methods)
    
    public var asString: String {
        switch self {
        case .limit(let value):
            return "limit=\"\(value)\""
        case .filter(let value):
            return "filter=\"\(value)\""
        case .field(let value):
            return "field=\"\(value)\""
        case .method(let value):
            return "method=\"\(value.rawValue)\""
        }
    }
}

public enum Command {
    case time
    case read(dataType: String, body: [OpenAirDTO], attributes: [Attributes])
    case readSimple(dataType: String, attributes: [Attributes])
    case readObject(data: OpenAirDTO, attributes: [Attributes])
    case add(OpenAirDTO)
    case addWithLookup(OpenAirDTO, lookup: String)
    case modify(OpenAirDTO)
    case delete(OpenAirDTO)
    case createAccount(company: OpenAirDTO, user: OpenAirDTO)
    case createUser(company: OpenAirDTO, user: OpenAirDTO)
    case auth(login: Login)
    case remoteAuth(login: Login)
    case whoami
    case approve(OpenAirDTO, approval: Approval?)
    case reject(OpenAirDTO, approval: Approval?)
    case unapprove(OpenAirDTO, approval: Approval?)
    case submit(OpenAirDTO, approval: Approval?)
    case report(OpenAirDTO)
}
