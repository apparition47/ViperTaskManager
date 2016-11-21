//
//  ListInteractor.swift
//  ViperTaskManager
//
//  Created by Aaron Lee on 29/02/16.
//  Copyright © 2016 One Fat Giraffe. All rights reserved.
//

import Foundation


protocol ListInteractorInputProtocol: class {
    
    weak var presenter: ListInteractorOutputProtocol! { get set }
    
    func fetchProjects(callback: ([Project]) -> ())
    func removeProject(project: Project, callback: (error: NSError?) -> ())
    func createProject(name: String, callback: (result: Project?, error: NSError?) -> ())
}

protocol ListInteractorOutputProtocol: class {

}

class ListInteractor {
    
    weak var presenter: ListInteractorOutputProtocol!
    
    var dataManager: ListDataManagerInputProtocol!
}

extension ListInteractor: ListInteractorInputProtocol {
    
    func fetchProjects(callback: ([Project]) -> ()) {
        // get from local if srv is down
        dataManager.fetchProjects() { (result, error) -> Void in
            if ((error) != nil) {
                callback(result)
            } else {
                callback(result)
            }
        }
    }
    
    
    func removeProject(project: Project, callback: (error: NSError?) -> ()) {
//        dataManager.removeProjectFromPersistentStore(project)
        dataManager.removeProject(project) { (error) in
            callback(error: error)
        }
    }
    
    func createProject(name: String, callback: (result: Project?, error: NSError?) -> ()) {
        dataManager.createProject(name) { (result, error) -> Void in
            callback(result: result, error: error)
            if (error == nil) {
                self.dataManager.saveProjectInPersistentStore(result!)
            }
        }
    }
}

extension ListInteractor: ListDataManagerOutputProtocol {
    
}
