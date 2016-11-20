//
//  RootHelper.swift
//  ViperTaskManager
//
//  Created by Aaron Lee on 26/02/16.
//  Copyright © 2016 One Fat Giraffe. All rights reserved.
//

import UIKit


class RouterHelper {
    
    class func navigationController() -> UINavigationController {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let rootNVC = delegate.window!.rootViewController as! UINavigationController
        return rootNVC
    }
    
    class func setRootViewController(viewController: UIViewController, animated: Bool) {
        self.navigationController().setViewControllers([viewController], animated: animated)
    }
    
}
