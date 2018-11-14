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
    let deadline: Date
    let completed: Bool
}


class TaskEntity: Object {
    @objc dynamic var taskId: String = ""
    @objc dynamic var projectId: String = ""
    @objc dynamic var title: String = "New Task"
    @objc dynamic var deadline: Date = Date(timeIntervalSince1970: 0)
    @objc dynamic var completed: Bool = false
    
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
