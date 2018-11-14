//
//  DetailInteractor.swift
//  ViperTaskManager
//
//  Created by Aaron Lee on 19/11/16.
//  Copyright © 2016 One Fat Giraffe. All rights reserved.
//

import Foundation


protocol DetailInteractorInputProtocol: class {
    var presenter: DetailInteractorOutputProtocol! { get set }

    func updateTask(task: Task, callback: @escaping (_ result: Task?, _ error: Error?) -> ())
}

protocol DetailInteractorOutputProtocol: class {

}

class DetailInteractor {
    weak var presenter: DetailInteractorOutputProtocol!
    
    var dataManager: DetailDataManagerInputProtocol!
}

extension DetailInteractor: DetailInteractorInputProtocol {
    func updateTask(task: Task, callback: @escaping (_ result: Task?, _ error: Error?) -> ()) {
        self.dataManager.updateTask(task: task) { (result, error) in
            if (error == nil) {
                self.dataManager.updateTaskInPersistentStore(task: task)
            }
            callback(task, error)
        }
    }
    
}

extension DetailInteractor: DetailDataManagerOutputProtocol {
    
}
