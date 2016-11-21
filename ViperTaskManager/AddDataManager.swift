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
    
    weak var interactor: AddDataManagerOutputProtocol! { get set }
    
//    func fetchCitiesWithName(name: String, callback: ([Task]) -> ())
    func saveTaskToPersistentStore(task: Task)
    func updateProject(project: Project, callback: (result: Project?, error: NSError?) -> ())
    func updateProjectInPersistentStore(project: Project)
    func fetchProjectFromPersistentStore(projectId: String, callback: (result: Project) -> ())
    func createTask(projectId: String, title: String, callback: (result: Task?, error: NSError?) -> ())
}

protocol AddDataManagerOutputProtocol: class {
    
    var dataManager: AddDataManagerInputProtocol! { get set }
}


class AddDataManager {
    
    weak var interactor: AddDataManagerOutputProtocol!
}

extension AddDataManager: AddDataManagerInputProtocol {

//    func fetchCitiesWithName(name: String, callback: ([Task]) -> ()) {
//        let method = Alamofire.Method.GET
//        let url = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
//        let parameters = ["input": "\(name)", "types": "(tasks)", "key": googleMapKey]
//        
//        Alamofire.Manager.sharedInstance.request(method, url, parameters: parameters, encoding: ParameterEncoding.URLEncodedInURL, headers: nil).responseJSON { (response) -> Void in
//            switch response.result {
//            case .Success(let JSON):
//                let predictions = JSON["predictions"] as! [[String: AnyObject]]
//                var tasks: [Task] = []
//                for prediction in predictions {
//                    let task = Task(title: prediction["description"] as! String, ID: prediction["id"] as! String, placeID: prediction["place_id"] as! String, lat: 0.0, lng: 0.0)
//                    tasks.append(task)
//                }
//                callback(tasks)
//                
//            case .Failure(let error):
//                print(error)
//                callback([])
//            }
//        }
//    }
    
    func saveTaskToPersistentStore(task: Task) {
        let realm = try! Realm()
        realm.beginWrite()
        
//        let taskEntity = TaskEntity()
//        taskEntity.title = task.title
//        taskEntity.ID = task.ID
//        taskEntity.placeID = task.placeID
        
//        realm.addWithNotification(taskEntity, update: false)
        
        try! realm.commitWrite()
    }

    func saveProjectToPersistentStore(project: Project) {
        let realm = try! Realm()
        realm.beginWrite()
        
        let entity = ProjectEntity(project: project)
        
        realm.addWithNotification(entity, update: false)
        
        try! realm.commitWrite()
    }
    
    func updateProject(project: Project, callback: (result: Project?, error: NSError?) -> ()) {
        let method = Alamofire.Method.PATCH
        let url = tasksServerEndpoint + "projects/" + project.projectId
        let parameters = ["name": "\(project.name)"]
        
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
    
    // name and sortBy only
    func updateProjectInPersistentStore(project: Project) {
        let realm = try! Realm()
        realm.beginWrite()
        
        let predicate = NSPredicate(format: "projectId = %@", argumentArray: [project.projectId])
        let projectEntity = realm.objects(ProjectEntity).filter(predicate)[0]
        
        projectEntity.name = project.name
        projectEntity.sortBy = project.sortBy
        
        realm.addWithNotification(projectEntity, update: true)
        
        try! realm.commitWrite()
    }
    
    // mainly to get the sortBy field
    func fetchProjectFromPersistentStore(projectId: String, callback: (result: Project) -> ()) {
        let realm = try! Realm()
        
        let predicate = NSPredicate(format: "projectId = %@", argumentArray: [projectId])
        let firstProject = realm.objects(ProjectEntity).filter(predicate)[0]

        var tasks: [Task] = []
        for taskEntity in firstProject.tasks {
            let city = Task(taskId: taskEntity.taskId, projectId: taskEntity.projectId, title: taskEntity.title, deadline: taskEntity.deadline, completed: taskEntity.completed)
            tasks.append(city)
        }
        
        let project = Project(projectId: firstProject.projectId, name: firstProject.name, sortBy: firstProject.sortBy, tasks: tasks)
        
        callback(result: project)
    }
    
    func createTask(projectId: String, title: String, callback: (result: Task?, error: NSError?) -> ()) {
        let method = Alamofire.Method.POST
        let url = tasksServerEndpoint + "projects/" + projectId + "/tasks"
        let parameters: [String:AnyObject] = ["title": "\(title)"]
        
        Alamofire.Manager.sharedInstance.request(method, url, parameters: parameters, encoding: ParameterEncoding.URLEncodedInURL, headers: nil).responseJSON { (response) -> Void in
            switch response.result {
            case .Success(let JSON):
                let taskJson = JSON as! [String: AnyObject]
                
                // taskJson["deadline"] as! Int is null???
                let task = Task(taskId: taskJson["id"] as! String, projectId: taskJson["project_id"] as! String, title: taskJson["title"] as! String, deadline: NSDate(timeIntervalSince1970: 0), completed: taskJson["completed"] as! Bool)
                
                callback(result: task, error: nil)
                
            case .Failure(let error):
                print(error)
                callback(result: nil, error: error)
            }
        }
    }
}
