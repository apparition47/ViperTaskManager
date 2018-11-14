//
//  ListDataManager.swift
//  ViperTaskManager
//
//  Created by Aaron Lee on 19/11/16.
//  Copyright © 2016 One Fat Giraffe. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire


protocol ListDataManagerInputProtocol: class {
    var interactor: ListDataManagerOutputProtocol! { get set }
    
    func fetchProjectsFromPersistentStore(callback: ([Project]) -> ())
    func fetchProjects(callback: @escaping (_ result: [Project], _ error: Error?) -> ())
    func saveProjectInPersistentStore(project: Project)
    func removeProjectFromPersistentStore(project: Project)
    func createProject(name: String, callback: @escaping (_ result: Project?, _ error: Error?) -> ())
    func removeProject(project: Project, callback: @escaping (_ error: Error?) -> ())
    func syncProjectsToPersistentStore(projects: [Project])
}

protocol ListDataManagerOutputProtocol: class {
    var dataManager: ListDataManagerInputProtocol! { get set }
}

class ListDataManager {
    weak var interactor: ListDataManagerOutputProtocol!
}

extension ListDataManager: ListDataManagerInputProtocol {
    func fetchProjects(callback: @escaping (_ result: [Project], _ error: Error?) -> ()) {
        let method = HTTPMethod.get
        let url = tasksServerEndpoint + "projects"
        
        Alamofire.SessionManager.default.request(url, method: method, parameters: nil).responseJSON { (response) -> Void in
            switch response.result {
            case .success(let JSON):
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
                        
                        let task = Task(taskId: taskJson["id"] as! String, projectId: taskJson["project_id"] as! String, title: taskJson["title"] as! String, deadline: Date(timeIntervalSince1970: TimeInterval(deadlineInt)), completed: taskJson["completed"] as! Bool)
                        tasks.append(task)
                    }
                    let task = Project(projectId: projectJson["id"] as! String, name: projectJson["name"] as! String, sortBy: "title", tasks: tasks)
                    projects.append(task)
                }
                callback(projects, nil)
            case .failure(let error):
                print(error)
                callback([], error)
            }
        }
    }
    
    func fetchProjectsFromPersistentStore(callback: ([Project]) -> ()) {
        let realm = try! Realm()

        let projectEntities = realm.objects(ProjectEntity.self)

        var projects: [Project] = []
        for projectEntity in projectEntities {
            let tasks = projectEntity.tasks.map { Task(taskId: $0.taskId, projectId: $0.projectId, title: $0.title, deadline: $0.deadline, completed: $0.completed ) }
            let project = Project(projectId: projectEntity.projectId, name: projectEntity.name, sortBy: projectEntity.sortBy, tasks: Array(tasks))
            projects.append(project)
        }
        callback(projects)
    }
    
    func saveProjectInPersistentStore(project: Project) {
        let realm = try! Realm()
        realm.beginWrite()
        
        let projectEntity = ProjectEntity(project: project)
        
        realm.add(projectEntity, update: false)
        
        try! realm.commitWrite()
    }
    
    func removeProjectFromPersistentStore(project: Project) {
        let realm = try! Realm()

        realm.beginWrite()

        let predicate = NSPredicate(format: "projectId = %@", argumentArray: [project.projectId])
        let projectEntities = realm.objects(ProjectEntity.self).filter(predicate)

        realm.delete(projectEntities)
        
        // remove tasks associated with project
        let predicate2 = NSPredicate(format: "projectId = %@", argumentArray: [project.projectId])
        let taskEntities = realm.objects(TaskEntity.self).filter(predicate2)
        
        realm.delete(taskEntities)

        try! realm.commitWrite()
    }

    func createProject(name: String, callback: @escaping (_ result: Project?, _ error: Error?) -> ()) {
        let method = HTTPMethod.post
        let url = tasksServerEndpoint + "projects"
        let parameters: [String: String] = ["name": "\(name)"]
        
        Alamofire.SessionManager.default.request(url, method: method, parameters: parameters).responseJSON { (response) -> Void in
            switch response.result {
            case .success(let JSON):
                let projectJson = JSON as! [String: AnyObject]
                let tasksJson = projectJson["tasks"] as! [[String: AnyObject]]
                var tasks: [Task] = []
                for taskJson in tasksJson {
                    let task = Task(taskId: taskJson["id"] as! String, projectId: taskJson["project_id"] as! String, title: taskJson["title"] as! String, deadline: Date(timeIntervalSince1970: TimeInterval(taskJson["deadline"] as! Int)), completed: taskJson["completed"] as! Bool)
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
    
    func removeProject(project: Project, callback: @escaping (_ error: Error?) -> ()) {
        let method = HTTPMethod.delete
        let url = tasksServerEndpoint + "projects/" + project.projectId
        
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
    
    func syncProjectsToPersistentStore(projects: [Project]) {
        let realm = try! Realm()
        
        realm.beginWrite()
        
        // delete all projects
        realm.deleteAll()
        
        // write new ones
        for project in projects {
            let projectEntity = ProjectEntity(project: project)
            realm.add(projectEntity, update: false)
        }
        
        try! realm.commitWrite()
    }
    
}
