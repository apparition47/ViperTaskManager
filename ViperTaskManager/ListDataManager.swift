//
//  ListDataManager.swift
//  ViperTaskManager
//
//  Created by Aaron Lee on 02/03/16.
//  Copyright © 2016 One Fat Giraffe. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire


protocol ListDataManagerInputProtocol: class {
    
    weak var interactor: ListDataManagerOutputProtocol! { get set }
    
//    func fetchCitiesFromPersistentStore(callback: ([Task]) -> ())
//    func removeTaskFromPersistentStore(task: Task)
    func fetchProjects(callback: (result: [Project], error: NSError?) -> ())
    func saveProjectInPersistentStore(project: Project)
    func removeProjectFromPersistentStore(project: Project)
    func createProject(name: String, callback: (result: Project?, error: NSError?) -> ())
    func removeProject(project: Project, callback: (error: NSError?) -> ())
}

protocol ListDataManagerOutputProtocol: class {
    
    var dataManager: ListDataManagerInputProtocol! { get set }
}


class ListDataManager {
    
    weak var interactor: ListDataManagerOutputProtocol!
}

extension ListDataManager: ListDataManagerInputProtocol {
    
//    func fetchCitiesFromPersistentStore(callback: ([Task]) -> ()) {
//        let realm = try! Realm()
//
//        let taskEntities = realm.objects(TaskEntity)
//        
//        var tasks: [Task] = []
//        for taskEntity in taskEntities {
//            let task = Task(title: taskEntity.title, ID: taskEntity.ID, placeID: taskEntity.placeID, lat: taskEntity.lat, lng: taskEntity.lng)
//            tasks.append(task)
//        }
//        callback(tasks)
//    }
//    
//    func removeTaskFromPersistentStore(task: Task) {
//        let realm = try! Realm()
//
//        realm.beginWrite()
//
//        let predicate = NSPredicate(format: "ID = %@", argumentArray: [task.ID])
//        let taskEntities = realm.objects(TaskEntity).filter(predicate)
//        
//        realm.deleteWithNotification(taskEntities)
//
//        try! realm.commitWrite()
//    }
    
    
    func fetchProjects(callback: (result: [Project], error: NSError?) -> ()) {
        let method = Alamofire.Method.GET
        let url = tasksServerEndpoint + "projects"
        
        Alamofire.Manager.sharedInstance.request(method, url, parameters: nil, encoding: ParameterEncoding.URLEncodedInURL, headers: nil).responseJSON { (response) -> Void in
            switch response.result {
            case .Success(let JSON):
                let projectsJson = JSON as! [[String: AnyObject]]
                var projects: [Project] = []
                for projectJson in projectsJson {
                    let tasksJson = projectJson["tasks"] as? [[String: AnyObject]] ?? []
                    var tasks: [Task] = []
                    for taskJson in tasksJson {
                        
                        var deadlineInt: Int
                        if (taskJson["deadline"] is NSNull) {
                            deadlineInt = 0
                        } else {
                            deadlineInt = taskJson["deadline"] as! Int
                        }
                        
                        let task = Task(taskId: taskJson["id"] as! String, projectId: taskJson["project_id"] as! String, title: taskJson["title"] as! String, deadline: NSDate(timeIntervalSince1970: NSTimeInterval(deadlineInt)), completed: taskJson["completed"] as! Bool)
                        tasks.append(task)
                    }
                    let task = Project(projectId: projectJson["id"] as! String, name: projectJson["name"] as! String, sortBy: "title", tasks: tasks)
                    projects.append(task)
                }
                callback(result: projects, error: nil)
                
            case .Failure(let error):
                print(error)
                callback(result: [], error: error)
            }
        }
    }
    
    func fetchProjectsFromPersistentStore(callback: ([Project]) -> ()) {
        let realm = try! Realm()

        let projectEntities = realm.objects(ProjectEntity)

        var projects: [Project] = []
        for projectEntity in projectEntities {
            let tasks = projectEntity.tasks.map{ Task(taskId: $0.taskId, projectId: $0.projectId, title: $0.title, deadline: $0.deadline, completed: $0.completed ) }
            let project = Project(projectId: projectEntity.projectId, name: projectEntity.name, sortBy: projectEntity.sortBy, tasks: tasks)
            projects.append(project)
        }
        callback(projects)
    }
    
    func saveProjectInPersistentStore(project: Project) {
        let realm = try! Realm()
        realm.beginWrite()
        
        let projectEntity = ProjectEntity(project: project)
        
        realm.addWithNotification(projectEntity, update: false)
        
        try! realm.commitWrite()
    }
    
    func removeProjectFromPersistentStore(project: Project) {
        let realm = try! Realm()

        realm.beginWrite()

        let predicate = NSPredicate(format: "ID = %@", argumentArray: [project.projectId])
        let projectEntities = realm.objects(ProjectEntity).filter(predicate)

        realm.deleteWithNotification(projectEntities)

        try! realm.commitWrite()
    }

    func createProject(name: String, callback: (result: Project?, error: NSError?) -> ()) {
        let method = Alamofire.Method.POST
        let url = tasksServerEndpoint + "projects"
        let parameters: [String:AnyObject] = ["name": "\(name)"]
        
        Alamofire.Manager.sharedInstance.request(method, url, parameters: parameters, encoding: ParameterEncoding.URLEncodedInURL, headers: nil).responseJSON { (response) -> Void in
            switch response.result {
            case .Success(let JSON):
                let projectJson = JSON as! [String: AnyObject]
                let tasksJson = projectJson["tasks"] as! [[String: AnyObject]]
                var tasks: [Task] = []
                for taskJson in tasksJson {
                    let task = Task(taskId: taskJson["id"] as! String, projectId: taskJson["project_id"] as! String, title: taskJson["title"] as! String, deadline: NSDate(timeIntervalSince1970: NSTimeInterval(taskJson["deadline"] as! Int)), completed: taskJson["completed"] as! Bool)
                    tasks.append(task)
                }
                
                let project = Project(projectId: projectJson["id"] as! String, name: projectJson["name"] as! String, sortBy: "title", tasks: tasks)
                
                callback(result: project, error: nil)
                
            case .Failure(let error):
                print(error)
                callback(result: nil, error: error)
            }
        }
    }
    
    func removeProject(project: Project, callback: (error: NSError?) -> ()) {
        let method = Alamofire.Method.DELETE
        let url = tasksServerEndpoint + "projects/" + project.projectId
//        let parameters: [String:AnyObject] = ["id": project.projectId]
        
        Alamofire.Manager.sharedInstance.request(method, url, parameters: nil, encoding: ParameterEncoding.URLEncodedInURL, headers: nil).responseString { (response) -> Void in
            switch response.result {
            case .Success( _):
                callback(error: nil)
                
            case .Failure(let error):
                print(error)
                callback(error: error)
            }
        }
    }
    
}
