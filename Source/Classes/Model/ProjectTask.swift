//
//  ProjectTask.swift
//  OpenAir
//
//  Created by Sameh Mabrouk on 31/03/2017.
//  Updated by Vladimir Abramichev on 24/01/2018.
//  Copyright © 2017 Sameh Mabrouk. All rights reserved.
//

import Foundation

public class ProjectTask: OpenAirDTO {
    public static var datatype: String = "Projecttask"
    
    let id: String?
    let projectid: String?
    let name: String?
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
        projectid = nil
    }
    
    init(projectId: String) {
        self.projectid = projectId
        id = nil
        name = nil
    }
}
