//
//  ProjectTask.swift
//  OpenAir
//
//  Created by Sameh Mabrouk on 31/03/2017.
//  Copyright © 2017 Sameh Mabrouk. All rights reserved.
//

import Foundation

public struct ProjectTask {
    public var name: String!
    public var id: String!
    
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
