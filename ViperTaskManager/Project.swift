//
//  Project.swift
//  ViperTaskManager
//
//  Created by Aaron Lee on 2016-11-17.
//  Copyright © 2016 One Fat Giraffe. All rights reserved.
//

import Foundation
import RealmSwift

struct Project {
    let projectId: String
    let name: String
    let sortBy: String
    let tasks: Array<Task>
    
    func getUnfinishedTaskCount() -> Int {
        var count = 0;
        for task in tasks {
            if (!task.completed) {
                count += 1;
            }
        }
        return count
    }
}


class ProjectEntity: Object {
    dynamic var projectId: String = ""
    dynamic var name: String = "New Project"
    dynamic var sortBy: String = "title"
    let tasks: List<TaskEntity> = List<TaskEntity>()
    
    override static func primaryKey() -> String? {
        return "projectId"
    }
    
    convenience init(project: Project) {
        self.init()
        
        self.projectId = project.projectId
        self.name = project.name
        self.sortBy = project.sortBy
        project.tasks.map{ self.tasks.append(TaskEntity(task:$0)) }
    }
}
