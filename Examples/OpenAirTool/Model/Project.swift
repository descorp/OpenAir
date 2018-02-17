//
//  Project.swift
//  OpenAir
//
//  Created by Sameh Mabrouk on 31/12/16.
//  Copyright © 2016 Sameh Mabrouk. All rights reserved.
//

import Foundation

public class Project: Hashable {
    
    public var hashValue: Int {
        return id.hashValue
    }
    
    public static func ==(lhs: Project, rhs: Project) -> Bool {
        return lhs.id == rhs.id
    }
    
    public let id: String
    public let picklist_label: String
    
    init(id: String, label: String) {
        self.id = id
        self.picklist_label = label
    }
}
