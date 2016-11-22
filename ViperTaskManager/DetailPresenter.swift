//
//  DetailPresenter.swift
//  ViperTaskManager
//
//  Created by Aaron Lee on 19/11/16.
//  Copyright © 2016 One Fat Giraffe. All rights reserved.
//

import UIKit
import Swinject


protocol DetailPresenterProtocol: class {
    
    func done(task: Task)
}

protocol DetailInterfaceProtocol: class {
    
    var presenter: DetailPresenterProtocol!  { get set }

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
    

    
    func done(task: Task) {
        self.interactor.updateTask(task) { (result, error) -> Void in
            if (error != nil) {
                print("error updating task")
            }
            
            self.router.dismissDetailViewController(viewController: self.interface as! UIViewController)
        }
        
    }
}

extension DetailPresenter: DetailInteractorOutputProtocol {

}

