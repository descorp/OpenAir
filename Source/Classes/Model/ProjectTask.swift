//
//  ProjectTask.swift
//  OpenAir
//
//  Created by Sameh Mabrouk on 31/03/2017.
//  Updated by Vladimir Abramichev on 24/01/2018.
//  Copyright © 2017 Sameh Mabrouk. All rights reserved.
//

import Foundation

public class ProjectTask: OpenAirOutgoingDTO {
    public static var datatype: String = "Projecttask"
    
    public let projectid: String?
    
    init(projectId: String) {
        self.projectid = projectId
    }
}
