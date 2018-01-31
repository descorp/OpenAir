//
//  CommandImplementation.swift
//  OpenAirSwift_iOS
//
//  Created by Vladimir Abramichev on 25/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation


extension Command {
    
    public var xml: String {
        var tag = ""
        var content = ""
        var attributes = ""
        
        switch self {
        // MARK: Time
        case .time:
            tag = "Time"
            break
            
        // MARK: Add
        case .add(let object):
            tag = "Add"
            content = object.xml
            attributes = " type=\"\(type(of:object).datatype)\""
            break
        case .addWithLookup(let object, let lookout):
            tag = "Add"
            content = object.xml
            attributes = " type=\"\(type(of:object).datatype)\" lookout=\"\(lookout)\""
            break
            
        // MARK: Modify
        case .modify(let object):
            tag = "Modify"
            content = object.xml
            attributes = " type=\"\(type(of:object).datatype)\""
            break
            
        // MARK: Delete
        case .delete(let object):
            tag = "Delete"
            content = object.xml
            attributes = " type=\"\(type(of:object).datatype)\""
            break
        // MARK: CreateAccount
        case .createAccount(let company, let user):
            tag = "CreateAccount"
            content = company.xml + user.xml
            break
            
        // MARK: CreateUser
        case .createUser(let company, let user):
            tag = "CreateUser"
            content = company.xml + user.xml
            break
            
        // MARK: Auth
        case .auth(let login):
            tag = "Auth"
            content = login.xml
            break
            
        // MARK: RemoteAuth
        case .remoteAuth(let login):
            tag = "RemoteAuth"
            content = login.xml
            break
            
        // MARK: Whoami
        case .whoami:
            tag = "Whoami"
            break
            
        // MARK: Approve
        case .approve(let object, let approval):
            tag = "Approve"
            content = object.xml + (approval?.xml ?? "")
            attributes = " type=\"\(type(of:object).datatype)\""
            break
            
        // MARK: Reject
        case .reject(let object, let approval):
            tag = "Reject"
            content = object.xml + (approval?.xml ?? "")
            attributes = " type=\"\(type(of:object).datatype)\""
            break
            
        // MARK: Unapprove
        case .unapprove(let object, let approval):
            tag = "Unapprove"
            content = object.xml + (approval?.xml ?? "")
            attributes = " type=\"\(type(of:object).datatype)\""
            break
            
        // MARK: Submit
        case .submit(let object, let approval):
            tag = "Submit"
            content = object.xml + (approval?.xml ?? "")
            attributes = " type=\"\(type(of:object).datatype)\""
            break
            
        // MARK: Report
        case .report(let object):
            tag = "Report"
            content = object.xml
            attributes = " type=\"\(type(of:object).datatype)\""
            break
            
        // MARK: Read
        case .read(let dataType, let body, let rawAttributes):
            tag = "Read"
            content = Command.getXml(from: body)
            attributes = rawAttributes.reduce(" type=\"\(dataType)\"") { (current, next) in
                return "\(current) \(next.asString)"
            }
            break
        case .readSimple(let dataType, let rawAttributes):
            tag = "Read"
            attributes = rawAttributes.reduce(" type=\"\(dataType)\"") { (current, next) in
                return "\(current) \(next.asString)"
            }
            break
        case .readObject(let data, let rawAttributes):
            tag = "Read"
            content = data.xml
            let datatype = type(of: data).datatype
            attributes = rawAttributes.reduce(" type=\"\(datatype)\"") { (current, next) in
                return "\(current) \(next.asString)"
            }
            break
        }
        
        return "<\(tag)\(attributes)>\(content)</\(tag)>"
    }
}
