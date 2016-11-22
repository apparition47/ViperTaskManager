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
    
    weak var interactor: DetailDataManagerOutputProtocol! { get set }
    
    func updateTaskInPersistentStore(task: Task)
    func updateTask(task: Task, callback: (result: Task?, error: NSError?) -> ())
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
        let taskEntity = realm.objects(TaskEntity).filter(predicate)[0]
        
        taskEntity.title = task.title
        taskEntity.completed = task.completed
        taskEntity.deadline = task.deadline
        
        realm.addWithNotification(taskEntity, update: true)
        
        try! realm.commitWrite()
    }
    
    func updateTask(task: Task, callback: (result: Task?, error: NSError?) -> ()) {
        let method = Alamofire.Method.PATCH
        let url = tasksServerEndpoint + "projects/" + task.projectId + "/tasks/" + task.taskId
        let parameters: [String:AnyObject] = ["title": "\(task.title)", "deadline": task.deadline.timeIntervalSince1970, "completed": "\(task.completed)"]
        
        Alamofire.Manager.sharedInstance.request(method, url, parameters: parameters, encoding: ParameterEncoding.URLEncodedInURL, headers: nil).responseJSON { (response) -> Void in
            switch response.result {
            case .Success(let JSON):
                let taskJson = JSON as! [String: AnyObject]
                
                var deadlineInt: Int
                if (taskJson["deadline"] is NSNull) {
                    deadlineInt = 0
                } else {
                    deadlineInt = taskJson["deadline"] as! Int
                }
                
                let task = Task(taskId: taskJson["id"] as! String, projectId: taskJson["project_id"] as! String, title: taskJson["title"] as! String, deadline: NSDate(timeIntervalSince1970: NSTimeInterval(deadlineInt)), completed: taskJson["completed"] as! Bool)
                print(task.completed)
                
                callback(result: task, error: nil)
                
            case .Failure(let error):
                print(error)
                callback(result: nil, error: error)
            }
        }
    }
}
