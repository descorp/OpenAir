//
//  RequestBuilder.swift
//  OpenAirSwift_iOS
//
//  Created by Vladimir Abramichev on 24/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

public struct RequestBuilder: PayloadBuilderType {
    
    static let Header = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>"
    let request: RequestConfiguration
    
    public init(for request: RequestConfiguration) {
        self.request = request
    }
    
    public func create(command: Command) -> String {
        
        let requestContent =
        """
        \(RequestBuilder.Header)
        \(request.xmlHeader)
        \(command.xml)
        \(request.xmlFooter)
        """
        return requestContent.minifiedXml
    }
    
    public func create(_ commands: [Command]) -> String {
        let commandsContent = commands.reduce("") { (current, next) in
            return current + "\r" + next.xml
        }
        
        let requestContent =
        """
        \(RequestBuilder.Header)
        \(request.xmlHeader)
        \(commandsContent)
        \(request.xmlFooter)
        """
        return requestContent.minifiedXml
    }
    
    public func create(_ commands: Command...) -> String {
        return create(commands)
    }
}
