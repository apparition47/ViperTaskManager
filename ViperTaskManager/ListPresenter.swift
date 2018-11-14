//
//  ListPresenter.swift
//  ViperTaskManager
//
//  Created by Aaron Lee on 19/11/16.
//  Copyright © 2016 One Fat Giraffe. All rights reserved.
//

import UIKit
import Swinject


protocol ListPresenterProtocol: class {
    func fetchProjects(callback: @escaping ([Project]) -> ())
    func showDetailProject(project: Project)
    func addNewProject(name: String)
    func exit()
    func removeProject(project: Project, callback: @escaping (_ error: Error?) -> ())
}

protocol ListInterfaceProtocol: class {
    var presenter: ListPresenterProtocol!  { get set }
}

class ListPresenter {
    
    weak private var interface: ListInterfaceProtocol!
    private let interactor: ListInteractorInputProtocol
    private let router: ListRouterInputProtocol
    
    
    init(interface: ListInterfaceProtocol, interactor: ListInteractorInputProtocol, router: ListRouterInputProtocol) {
        self.interface = interface
        self.interactor = interactor
        self.router = router
    }
    
}


extension ListPresenter: ListPresenterProtocol {
    func fetchProjects(callback: @escaping ([Project]) -> ()) {
        self.interactor.fetchProjects() { result -> Void in
            callback(result)
        }
    }
    
    func showDetailProject(project: Project) {
        self.router.presentDetailViewController(fromViewController: self.interface as! UIViewController, project: project)
    }
    
    func removeProject(project: Project, callback: @escaping (_ error: Error?) -> ()) {
        self.interactor.removeProject(project: project) { (error) -> Void in
            callback(error)
        }
    }
    
    func addNewProject(name: String) {
//        self.router.presentAddViewController(fromViewController: self.interface as! UIViewController)
        self.interactor.createProject(name: name) { (result, error) -> Void in
            if (error != nil) {
                print("error what")
            } else {
                self.router.presentDetailViewController(fromViewController: self.interface as! UIViewController, project: result!)
            }
        }
    }
    
    func exit() {
        self.router.dismissListViewController(viewController: self.interface as! UIViewController)
    }
}

extension ListPresenter: ListInteractorOutputProtocol {
    
}

