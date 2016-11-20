//
//  Task.swift
//  ViperTaskManager
//
//  Created by Aaron Lee on 2016-11-17.
//  Copyright © 2016 One Fat Giraffe. All rights reserved.
//

import Foundation
import RealmSwift

struct Task {
    let taskId: String
    let projectId: String
    let title: String
    let deadline: NSDate
    let completed: Bool
}


class TaskEntity: Object {
    dynamic var taskId: String = ""
    dynamic var projectId: String = ""
    dynamic var title: String = "New Task"
    dynamic var deadline: NSDate = NSDate(timeIntervalSince1970: 0)
    dynamic var completed: Bool = false
    
    override static func primaryKey() -> String? {
        return "taskId"
    }
    
    convenience init(task: Task) {
        self.init()
        
        self.taskId = task.taskId
        self.projectId = task.projectId
        self.title = task.title
        self.deadline = task.deadline
        self.completed = task.completed
    }
}
