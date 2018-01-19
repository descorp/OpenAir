//
//  Project.swift
//  OpenAir
//
//  Created by Sameh Mabrouk on 31/12/16.
//  Copyright © 2016 Sameh Mabrouk. All rights reserved.
//

import Foundation

public struct Project {
    public var picklist_label: String!
    public var id: String!
    
    public init(id: String, picklist_label: String) {
        self.id = id
        self.picklist_label = picklist_label
    }
}
