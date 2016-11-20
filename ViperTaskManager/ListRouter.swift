//
//  ListRouter.swift
//  ViperTaskManager
//
//  Created by Aaron Lee on 29/02/16.
//  Copyright © 2016 One Fat Giraffe. All rights reserved.
//

import UIKit
import Swinject


protocol ListRouterInputProtocol: class {
//    func presentAddViewController(fromViewController fromViewController: UIViewController)
    func presentDetailViewController(fromViewController fromViewController: UIViewController, project: Project)
    
    func dismissListViewController(viewController viewController: UIViewController)
    
//    var detailContainerAssembler: DetailContainerAssembler! { get set }
    var addAssembler: AddAssembler! { get set }
}

protocol ListParentRouterProtocol: class {
    
}

class ListRouter: ListRouterInputProtocol {
    
//    var detailContainerAssembler: DetailContainerAssembler!
    var addAssembler: AddAssembler!
    
   
    func dismissListViewController(viewController viewController: UIViewController) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
//    func presentAddViewController(fromViewController fromViewController: UIViewController) {
//        addAssembler.presentAddViewController(fromViewController: fromViewController)
//    }
    
    func presentDetailViewController(fromViewController fromViewController: UIViewController, project: Project) {
        addAssembler.presentAddViewController(fromViewController: fromViewController, project: project)
    }
}
