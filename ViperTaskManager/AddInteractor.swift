//
//  AddInteractor.swift
//  ViperTaskManager
//
//  Created by Aaron Lee on 19/02/16.
//  Copyright © 2016 One Fat Giraffe. All rights reserved.
//
//  Generated by Swift-Viper templates. Find latest version at https://github.com/Nikita2k/SwiftViper
//

import Foundation


protocol AddInteractorInputProtocol: class {
    var presenter: AddInteractorOutputProtocol! { get set }

    func fetchTasks(projectId: String, callback: @escaping (_ result: [Task]?) -> ())
//    func saveProject(project: Project)
    func updateProject(project: Project, callback: @escaping (_ result: Project?, _ error: Error?) -> ())
    func updateProjectInPersistentStore(project: Project)
    func fetchSortBy(projectId: String, callback: (_ result: String) -> ())
    func createTask(projectId: String, title: String, callback: @escaping (_ result: Task?, _ error: Error?) -> ())
    func removeTask(task: Task, callback: @escaping (_ error: Error?) -> ())
}

protocol AddInteractorOutputProtocol: class {
   
}

class AddInteractor {
    weak var presenter: AddInteractorOutputProtocol!
    
    var dataManager: AddDataManagerInputProtocol!
}

extension AddInteractor: AddInteractorInputProtocol {
    func fetchTasks(projectId: String, callback: @escaping (_ result: [Task]?) -> ()) {
        self.dataManager.fetchTasks(projectId: projectId) { (result, error) in
            if (error == nil) {
                callback(result)
            } else {
                self.dataManager.fetchProjectFromPersistentStore(projectId: projectId, callback: { (result) in
                    callback(result.tasks)
                })
            }
        }
    }
    
    func saveTask(task: Task) {
        self.dataManager.saveTaskToPersistentStore(task: task)
    }
    
    func updateProject(project: Project, callback: @escaping (_ result: Project?, _ error: Error?) -> ()) {
        self.dataManager.updateProject(project: project) { (result, error) in
            if (error == nil) {
                self.dataManager.updateProjectInPersistentStore(project: project)
            }
            
            callback(result, error)
        }
    }
    
    func updateProjectInPersistentStore(project: Project) {
        self.dataManager.updateProjectInPersistentStore(project: project)
    }
    
    func fetchSortBy(projectId: String, callback: (_ result: String) -> ()) {
        self.dataManager.fetchProjectFromPersistentStore(projectId: projectId) { result in
            callback(result.sortBy)
        }
    }
    
    func createTask(projectId: String, title: String, callback: @escaping (_ result: Task?, _ error: Error?) -> ()) {
        self.dataManager.createTask(projectId: projectId, title: title) { (result, error) in
            if (error == nil) {
                self.dataManager.saveTaskToPersistentStore(task: result!)
            }
            callback(result, error)
        }
    }
    
    func removeTask(task: Task, callback: @escaping (_ error: Error?) -> ()) {
        self.dataManager.removeTask(task: task) { (error) in
            callback(error)
        }
    }
}

extension AddInteractor: AddDataManagerOutputProtocol {
    
}
