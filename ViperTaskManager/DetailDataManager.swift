//
//  DetailDataManager.swift
//  ViperTaskManager
//
//  Created by Aaron Lee on 19/11/16.
//  Copyright © 2016 One Fat Giraffe. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire
import SwiftFetchedResultsController


protocol DetailDataManagerInputProtocol: class {
    var interactor: DetailDataManagerOutputProtocol! { get set }
    
    func updateTaskInPersistentStore(task: Task)
    func updateTask(task: Task, callback: @escaping (_ result: Task?, _ error: Error?) -> ())
}

protocol DetailDataManagerOutputProtocol: class {
    var dataManager: DetailDataManagerInputProtocol! { get set }
}

class DetailDataManager {
    weak var interactor: DetailDataManagerOutputProtocol!
}

extension DetailDataManager: DetailDataManagerInputProtocol {
    func updateTaskInPersistentStore(task: Task) {
        let realm = try! Realm()
        
        realm.beginWrite()
        let predicate = NSPredicate(format: "taskId = %@", argumentArray: [task.taskId])
        let taskEntity = realm.objects(TaskEntity.self).filter(predicate)[0]
        
        taskEntity.title = task.title
        taskEntity.completed = task.completed
        taskEntity.deadline = task.deadline
        
        realm.add(taskEntity, update: true)
        
        try! realm.commitWrite()
    }
    
    func updateTask(task: Task, callback: @escaping (_ result: Task?, _ error: Error?) -> ()) {
        let method = HTTPMethod.patch
        let url = tasksServerEndpoint + "projects/" + task.projectId + "/tasks/" + task.taskId
        let parameters: [String:AnyObject] = ["title": "\(task.title)" as AnyObject, "deadline": task.deadline.timeIntervalSince1970 as AnyObject, "completed": "\(task.completed)" as AnyObject]
        
        Alamofire.SessionManager.default.request(url, method: method, parameters: parameters).responseJSON { (response) -> Void in
            switch response.result {
            case .success(let JSON):
                let taskJson = JSON as! [String: AnyObject]
                
                var deadlineInt: Int
                if (taskJson["deadline"] is NSNull) {
                    deadlineInt = 0
                } else {
                    deadlineInt = taskJson["deadline"] as! Int
                }
                
                let task = Task(taskId: taskJson["id"] as! String, projectId: taskJson["project_id"] as! String, title: taskJson["title"] as! String, deadline: Date(timeIntervalSince1970: TimeInterval(deadlineInt)), completed: taskJson["completed"] as! Bool)
                print(task.completed)
                
                callback(task, nil)
            case .failure(let error):
                print(error)
                callback(nil, error)
            }
        }
    }
}
