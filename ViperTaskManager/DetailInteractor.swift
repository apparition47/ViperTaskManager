//
//  DetailInteractor.swift
//  ViperTaskManager
//
//  Created by Aaron Lee on 29/02/16.
//  Copyright © 2016 One Fat Giraffe. All rights reserved.
//

import Foundation


protocol DetailInteractorInputProtocol: class {
    
    weak var presenter: DetailInteractorOutputProtocol! { get set }
    
    func getDetailTask(task: Task)
    func updateTask(task: Task, callback: (result: Task?, error: NSError?) -> ())
}

protocol DetailInteractorOutputProtocol: class {
    
//    func foundDetailTask(task: Task)
//    func foundWeatherForTask(weather: [Weather], task: Task)
}

class DetailInteractor {
    
    weak var presenter: DetailInteractorOutputProtocol!
    
    var dataManager: DetailDataManagerInputProtocol!

}

extension DetailInteractor: DetailInteractorInputProtocol {

    func getDetailTask(task: Task) {
        self.dataManager.getDetailTask(task) { [weak self] (task) -> () in
//            self?.dataManager.updateTaskInPersistentStore(task)
//            self?.presenter.foundDetailTask(task)
        }
    }
    
    func updateTask(task: Task, callback: (result: Task?, error: NSError?) -> ()) {
        self.dataManager.updateTask(task) { (result, error) in
            callback(result: task, error: error)
        }
    }
    
}

extension DetailInteractor: DetailDataManagerOutputProtocol {
    
}
