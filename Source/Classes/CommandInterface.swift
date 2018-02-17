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
    case read(dataType: String, body: [OpenAirOutgoingDTO], attributes: [Attributes])
    case readSimple(dataType: String, attributes: [Attributes])
    case readObject(data: OpenAirOutgoingDTO, attributes: [Attributes])
    case add(OpenAirOutgoingDTO)
    case addWithLookup(OpenAirOutgoingDTO, lookup: String)
    case modify(OpenAirOutgoingDTO)
    case delete(OpenAirOutgoingDTO)
    case createAccount(company: OpenAirOutgoingDTO, user: OpenAirOutgoingDTO)
    case createUser(company: OpenAirOutgoingDTO, user: OpenAirOutgoingDTO)
    case auth(login: Login)
    case remoteAuth(login: Login)
    case whoami
    case approve(OpenAirOutgoingDTO, approval: Approval?)
    case reject(OpenAirOutgoingDTO, approval: Approval?)
    case unapprove(OpenAirOutgoingDTO, approval: Approval?)
    case submit(OpenAirOutgoingDTO, approval: Approval?)
    case report(OpenAirOutgoingDTO)
}
