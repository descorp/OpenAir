//
//  Project.swift
//  OpenAir
//
//  Created by Sameh Mabrouk on 31/12/16.
//  Copyright © 2016 Sameh Mabrouk. All rights reserved.
//

import Foundation

class Project {
    var picklist_label: String!
    var id: String!
    
    init(id: String, picklist_label: String) {
        self.id = id
        self.picklist_label = picklist_label
    }
}
