//
//  DetailPresenter.swift
//  ViperTaskManager
//
//  Created by Aaron Lee on 29/02/16.
//  Copyright © 2016 One Fat Giraffe. All rights reserved.
//

import UIKit
import Swinject


protocol DetailPresenterProtocol: class {
    
    func getDetailTask(task: Task)
//    func getWeatherForTask(task: Task)
    func done(task: Task)
}

protocol DetailInterfaceProtocol: class {
    
    var presenter: DetailPresenterProtocol!  { get set }
    
//    func showEmpty()
//    func showTask(task: Task)
//    func showWeatherForTask(weather: [Weather], task: Task)
}

class DetailPresenter {
    
    weak private var interface: DetailInterfaceProtocol!
    private let interactor: DetailInteractorInputProtocol
    private let router: DetailRouterInputProtocol
    
    
    init(interface: DetailInterfaceProtocol, interactor: DetailInteractorInputProtocol, router: DetailRouterInputProtocol) {
        self.interface = interface
        self.interactor = interactor
        self.router = router
    }
}


extension DetailPresenter: DetailPresenterProtocol {
    
    func getDetailTask(task: Task) {
        self.interactor.getDetailTask(task)
    }
    
//    func getWeatherForTask(task: Task) {
//        self.interactor.getWeatherForTask(task)
//    }
    
    func done(task: Task) {
        self.interactor.updateTask(task) { (result, error) -> Void in
            if (error != nil) {
                print("error updating task")
                // TODO persist
            }
            
            self.router.dismissDetailViewController(viewController: self.interface as! UIViewController)
        }
        
    }
}

extension DetailPresenter: DetailInteractorOutputProtocol {
    
//    func foundDetailTask(task: Task) {
//        guard task.isLocationEnable() == true else {
//            self.interface.showEmpty()
//            return
//        }
//        self.interface.showTask(task)
//    }
//    
//    func foundWeatherForTask(weather: [Weather], task: Task) {
//        self.interface.showWeatherForTask(weather, task: task)
//    }
}

