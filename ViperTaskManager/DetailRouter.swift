//
//  DetailRouter.swift
//  ViperTaskManager
//
//  Created by Aaron Lee on 19/11/16.
//  Copyright © 2016 One Fat Giraffe. All rights reserved.
//

import UIKit
import Swinject


protocol DetailRouterInputProtocol: class {
    func dismissDetailViewController(viewController: UIViewController)
}

protocol DetailParentRouterProtocol: class {
    
}

class DetailRouter: DetailRouterInputProtocol {
    
    func dismissDetailViewController(viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}
