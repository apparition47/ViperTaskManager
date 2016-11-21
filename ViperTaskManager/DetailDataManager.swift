//
//  DetailDataManager.swift
//  ViperTaskManager
//
//  Created by Aaron Lee on 02/03/16.
//  Copyright © 2016 One Fat Giraffe. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire
import SwiftFetchedResultsController


protocol DetailDataManagerInputProtocol: class {
    
    weak var interactor: DetailDataManagerOutputProtocol! { get set }
    
    func getDetailTask(task: Task, callback: (Task) -> ())
//    func getWeatherForTask(task: Task, callback: ([Weather]) -> ())
    func updateTaskInPersistentStore(task: Task)
}

protocol DetailDataManagerOutputProtocol: class {
    
    var dataManager: DetailDataManagerInputProtocol! { get set }
}


class DetailDataManager {
    
    weak var interactor: DetailDataManagerOutputProtocol!
}

extension DetailDataManager: DetailDataManagerInputProtocol {
    
    func getDetailTask(task: Task, callback: (Task) -> ()) {
//        let method = Alamofire.Method.GET
//        let url = "https://maps.googleapis.com/maps/api/place/details/json"
//        let parameters = ["placeid": "\(task.placeID)", "key": googleMapKey]
//        
//        Alamofire.Manager.sharedInstance.request(method, url, parameters: parameters, encoding: ParameterEncoding.URLEncodedInURL, headers: nil).responseJSON { (response) -> Void in
//            switch response.result {
//            case .Success(let JSON):
//                let result = JSON["result"] as! [String: AnyObject]
//                let geometry = result["geometry"] as! [String: AnyObject]
//                let location = geometry["location"] as! [String: AnyObject]
//                let lat = location["lat"] as! Double
//                let lng = location["lng"] as! Double
//                let task = Task(title: task.title, ID: task.ID, placeID: task.placeID, lat: lat, lng: lng)
//                callback(task)
//
//            case .Failure(let error):
//                print(error)
//                callback(task)
//            }
//        }
    }
    
//    func getWeatherForTask(task: Task, callback: ([Weather]) -> ()) {
//        let method = Alamofire.Method.GET
//        let url = "http://api.openweathermap.org/data/2.5/forecast"
//        let parameters: [String: AnyObject] = ["lat": task.lat, "lon": task.lng, "units": "metric", "cnt": 1, "APPID": openWeatherMapKey]
//        
//        Alamofire.Manager.sharedInstance.request(method, url, parameters: parameters, encoding: ParameterEncoding.URLEncodedInURL, headers: nil).responseJSON { (response) -> Void in
//            switch response.result {
//            case .Success(let JSON):
//                guard let list = JSON["list"] as? [[String: AnyObject]] else {
//                    callback([])
//                    return
//                }
//                var weatherList: [Weather] = []
//                for weatherData in list {
//                    let weather = Weather(dt: weatherData["dt"] as! Double, temp: weatherData["main"]!["temp"] as! Double, pressure: weatherData["main"]!["pressure"] as! Double, icon: weatherData["weather"]![0]["icon"] as! String)
//                    weatherList.append(weather)
//                }
//                callback(weatherList)
//                
//            case .Failure(let error):
//                print(error)
//                callback([])
//            }
//        }
//    }
    
    func updateTaskInPersistentStore(task: Task) {
        let realm = try! Realm()
        
        realm.beginWrite()
//        let predicate = NSPredicate(format: "ID = %@", argumentArray: [task.taskId])
//        let taskEntities = realm.objects(TaskEntity).filter(predicate)
//        
//        for taskEntity in taskEntities {
//            taskEntity.lat = task.lat
//            taskEntity.lng = task.lng
//        }
//        
//        realm.addWithNotification(taskEntities, update: true)
        
        try! realm.commitWrite()
    }
}
