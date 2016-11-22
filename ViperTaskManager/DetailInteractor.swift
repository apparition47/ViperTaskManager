//
//  DetailInteractor.swift
//  ViperTaskManager
//
//  Created by Aaron Lee on 19/11/16.
//  Copyright © 2016 One Fat Giraffe. All rights reserved.
//

import Foundation


protocol DetailInteractorInputProtocol: class {
    
    weak var presenter: DetailInteractorOutputProtocol! { get set }
    
    func updateTask(task: Task, callback: (result: Task?, error: NSError?) -> ())
}

protocol DetailInteractorOutputProtocol: class {

}

class DetailInteractor {
    
    weak var presenter: DetailInteractorOutputProtocol!
    
    var dataManager: DetailDataManagerInputProtocol!

}

extension DetailInteractor: DetailInteractorInputProtocol {


    func updateTask(task: Task, callback: (result: Task?, error: NSError?) -> ()) {
        self.dataManager.updateTask(task) { (result, error) in
            if (error == nil) {
                self.dataManager.updateTaskInPersistentStore(task)
            }
            callback(result: task, error: error)
        }
    }
    
}

extension DetailInteractor: DetailDataManagerOutputProtocol {
    
}
