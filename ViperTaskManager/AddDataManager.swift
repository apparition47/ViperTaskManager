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
//        Alamofire.Manager.sharedInstance.request(method, url, parameters: parameters, encoding: ParameterEncoding.URL, headers: nil).responseJSON { (response) -> Void in
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
    
}
