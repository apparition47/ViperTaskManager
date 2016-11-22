//
//  ListRouter.swift
//  ViperTaskManager
//
//  Created by Aaron Lee on 19/11/16.
//  Copyright © 2016 One Fat Giraffe. All rights reserved.
//

import UIKit
import Swinject


protocol ListRouterInputProtocol: class {

    func presentDetailViewController(fromViewController fromViewController: UIViewController, project: Project)
    
    func dismissListViewController(viewController viewController: UIViewController)
    
    var addAssembler: AddAssembler! { get set }
}

protocol ListParentRouterProtocol: class {
    
}

class ListRouter: ListRouterInputProtocol {
    
    var addAssembler: AddAssembler!
    
   
    func dismissListViewController(viewController viewController: UIViewController) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }

    func presentDetailViewController(fromViewController fromViewController: UIViewController, project: Project) {
        addAssembler.presentAddViewController(fromViewController: fromViewController, project: project)
    }
}
