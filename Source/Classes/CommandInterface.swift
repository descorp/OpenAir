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
    case read(dataType: String, body: [XmlEncodable], attributes: [Attributes])
    case add(XmlEncodable)
    case addWithLookup(XmlEncodable, lookup: String)
    case modify(XmlEncodable)
    case delete(XmlEncodable)
    case createAccount(company: XmlEncodable, user: XmlEncodable)
    case createUser(company: XmlEncodable, user: XmlEncodable)
    case auth(login: Login)
    case remoteAuth(login: Login)
    case whoami
    case approve(XmlEncodable, approval: Approval?)
    case reject(XmlEncodable, approval: Approval?)
    case unapprove(XmlEncodable, approval: Approval?)
    case submit(XmlEncodable, approval: Approval?)
    case report(XmlEncodable)
    
    public var name: String {
        return String(describing: self).components(separatedBy: "(").first ?? ""
    }
}
