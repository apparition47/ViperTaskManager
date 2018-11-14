//
//  AddDataManager.swift
//  ViperTaskManager
//
//  Created by Aaron Lee on 01/03/16.
//  Copyright © 2016 One Fat Giraffe. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire
import SwiftFetchedResultsController


protocol AddDataManagerInputProtocol: class {
    var interactor: AddDataManagerOutputProtocol! { get set }
    
    func fetchTasks(projectId: String, callback: @escaping (_ result: [Task]?, _ error: Error?) -> ())
    func saveTaskToPersistentStore(task: Task)
    func updateProject(project: Project, callback: @escaping (_ result: Project?, _ error: Error?) -> ())
    func updateProjectInPersistentStore(project: Project)
    func fetchProjectFromPersistentStore(projectId: String, callback: (_ result: Project) -> ())
    func createTask(projectId: String, title: String, callback: @escaping (_ result: Task?, _ error: Error?) -> ())
    func removeTask(task: Task, callback: @escaping (_ error: Error?) -> ())
}

protocol AddDataManagerOutputProtocol: class {
    var dataManager: AddDataManagerInputProtocol! { get set }
}

class AddDataManager {
    weak var interactor: AddDataManagerOutputProtocol!
}

extension AddDataManager: AddDataManagerInputProtocol {
    func fetchTasks(projectId: String, callback: @escaping (_ result: [Task]?, _ error: Error?) -> ()) {
        let method = HTTPMethod.get
        let url = tasksServerEndpoint + "projects/" + projectId
        
        Alamofire.SessionManager.default.request(url, method: method, parameters: nil).responseJSON { (response) -> Void in
            switch response.result {
            case .success(let JSON):
                let projectJson = JSON as! [String: AnyObject]
                let tasksJson = projectJson["tasks"] as! [[String: AnyObject]]
                var tasks: [Task] = []
                for taskJson in tasksJson {
                    var deadlineInt: Int
                    if (taskJson["deadline"] is NSNull) {
                        deadlineInt = 0
                    } else {
                        deadlineInt = taskJson["deadline"] as! Int
                    }
                    let task = Task(taskId: taskJson["id"] as! String, projectId: taskJson["project_id"] as! String, title: taskJson["title"] as! String, deadline: Date(timeIntervalSince1970: TimeInterval(deadlineInt)), completed: taskJson["completed"] as! Bool)
                    tasks.append(task)
                }
                
                callback(tasks, nil)
            case .failure(let error):
                print(error)
                callback(nil, error)
            }
        }
    }
    
    func saveTaskToPersistentStore(task: Task) {
        let realm = try! Realm()
        realm.beginWrite()
        
        let taskEntity = TaskEntity(task: task)
        
        realm.add(taskEntity, update: false)
        
        try! realm.commitWrite()
    }

    func saveProjectToPersistentStore(project: Project) {
        let realm = try! Realm()
        realm.beginWrite()
        
        let entity = ProjectEntity(project: project)
        
        realm.add(entity, update: false)
        
        try! realm.commitWrite()
    }
    
    func updateProject(project: Project, callback: @escaping (_ result: Project?, _ error: Error?) -> ()) {
        let method = HTTPMethod.patch
        let url = tasksServerEndpoint + "projects/" + project.projectId
        let parameters = ["name": "\(project.name)"]
        
        Alamofire.SessionManager.default.request(url, method: method, parameters: parameters).responseJSON { (response) -> Void in
            switch response.result {
            case .success(let JSON):
                let projectJson = JSON as! [String: AnyObject]
                let tasksJson = projectJson["tasks"] as! [[String: AnyObject]]
                var tasks: [Task] = []
                for taskJson in tasksJson {
                    
                    let deadlineInt: Int
                    if (taskJson["deadline"] is NSNull) {
                        deadlineInt = 0
                    } else {
                        deadlineInt = taskJson["deadline"] as! Int
                    }
                    
                    let task = Task(taskId: taskJson["id"] as! String, projectId: taskJson["project_id"] as! String, title: taskJson["title"] as! String, deadline: Date(timeIntervalSince1970: TimeInterval(deadlineInt)), completed: taskJson["completed"] as! Bool)
                    tasks.append(task)
                }
                
                let project = Project(projectId: projectJson["id"] as! String, name: projectJson["name"] as! String, sortBy: "title", tasks: tasks)
                
                callback(project, nil)
            case .failure(let error):
                print(error)
                callback(nil, error)
            }
        }
    }
    
    // name and sortBy only
    func updateProjectInPersistentStore(project: Project) {
        let realm = try! Realm()
        realm.beginWrite()
        
        let predicate = NSPredicate(format: "projectId = %@", argumentArray: [project.projectId])
        let projectEntity = realm.objects(ProjectEntity.self).filter(predicate)[0]
        
        projectEntity.name = project.name
        projectEntity.sortBy = project.sortBy
        
        realm.add(projectEntity, update: true)
        
        try! realm.commitWrite()
    }
    
    // mainly to get the sortBy field
    func fetchProjectFromPersistentStore(projectId: String, callback: (_ result: Project) -> ()) {
        let realm = try! Realm()
        
        let predicate = NSPredicate(format: "projectId = %@", argumentArray: [projectId])
        let firstProject = realm.objects(ProjectEntity.self).filter(predicate)[0]

        var tasks: [Task] = []
        for taskEntity in firstProject.tasks {
            let city = Task(taskId: taskEntity.taskId, projectId: taskEntity.projectId, title: taskEntity.title, deadline: taskEntity.deadline, completed: taskEntity.completed)
            tasks.append(city)
        }
        
        let project = Project(projectId: firstProject.projectId, name: firstProject.name, sortBy: firstProject.sortBy, tasks: tasks)
        
        callback(project)
    }
    
    func createTask(projectId: String, title: String, callback: @escaping (_ result: Task?, _ error: Error?) -> ()) {
        let method = HTTPMethod.post
        let url = tasksServerEndpoint + "projects/" + projectId + "/tasks"
        let parameters: [String: String] = ["title": "\(title)"]
        
        Alamofire.SessionManager.default.request(url, method: method, parameters: parameters).responseJSON { (response) -> Void in
            switch response.result {
            case .success(let JSON):
                let taskJson = JSON as! [String: AnyObject]
                
                let deadlineInt: Int
                if (taskJson["deadline"] is NSNull) {
                    deadlineInt = 0
                } else {
                    deadlineInt = taskJson["deadline"] as! Int
                }
                
                let task = Task(taskId: taskJson["id"] as! String, projectId: taskJson["project_id"] as! String, title: taskJson["title"] as! String, deadline: Date(timeIntervalSince1970: TimeInterval(deadlineInt)), completed: taskJson["completed"] as! Bool)
                
                callback(task, nil)
            case .failure(let error):
                print(error)
                callback(nil, error)
            }
        }
    }
    
    func removeTask(task: Task, callback: @escaping (_ error: Error?) -> ()) {
        let method = HTTPMethod.delete
        let url = tasksServerEndpoint + "projects/" + task.projectId + "/tasks/" + task.taskId
        
        Alamofire.SessionManager.default.request(url, method: method, parameters: nil).responseString { (response) -> Void in
            switch response.result {
            case .success( _):
                callback(nil)
            case .failure(let error):
                print(error)
                callback(error)
            }
        }
    }
    
}
