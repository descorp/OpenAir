//
//  Project.swift
//  OpenAir
//
//  Created by Sameh Mabrouk on 31/12/16.
//  Updated by Vladimir Abramichev on 24/01/2018.
//  Copyright © 2016 Sameh Mabrouk. All rights reserved.
//

import Foundation

public class Project : OpenAirDTO {
    let id: String
    let picklist_label: String
    
    init(id: String, label: String) {
        self.id = id
        self.picklist_label = label
    }
}
