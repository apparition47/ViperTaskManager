//
//  ListInteractor.swift
//  ViperTaskManager
//
//  Created by Aaron Lee on 19/11/16.
//  Copyright © 2016 One Fat Giraffe. All rights reserved.
//

import Foundation

protocol ListInteractorInputProtocol: class {
    var presenter: ListInteractorOutputProtocol! { get set }
    
    func fetchProjects(callback: @escaping ([Project]) -> ())
    func removeProject(project: Project, callback: @escaping (_ error: Error?) -> ())
    func createProject(name: String, callback: @escaping (_ result: Project?, _ error: Error?) -> ())
}

protocol ListInteractorOutputProtocol: class {

}

class ListInteractor {
    weak var presenter: ListInteractorOutputProtocol!
    
    var dataManager: ListDataManagerInputProtocol!
}

extension ListInteractor: ListInteractorInputProtocol {
    func fetchProjects(callback: @escaping ([Project]) -> ()) {
        dataManager.fetchProjects() { (result, error) -> Void in
            if (error == nil) {
                self.dataManager.syncProjectsToPersistentStore(projects: result)
                callback(result)
            } else {
                // get from local if srv is down
                self.dataManager.fetchProjectsFromPersistentStore() { result -> Void in
                    callback(result)
                }
            }
        }
    }
    
    
    func removeProject(project: Project, callback: @escaping (_ error: Error?) -> ()) {
        dataManager.removeProject(project: project) { (error) in
            if (error == nil) {
                self.dataManager.removeProjectFromPersistentStore(project: project)
            }
            
            callback(error)
        }
    }
    
    func createProject(name: String, callback: @escaping (_ result: Project?, _ error: Error?) -> ()) {
        dataManager.createProject(name: name) { (result, error) -> Void in
            callback(result, error)
            if (error == nil) {
                self.dataManager.saveProjectInPersistentStore(project: result!)
            }
        }
    }
}

extension ListInteractor: ListDataManagerOutputProtocol {
    
}
