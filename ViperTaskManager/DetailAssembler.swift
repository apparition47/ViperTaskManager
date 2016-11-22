//
//  DetailAssembler.swift
//  ViperTaskManager
//
//  Created by Aaron Lee on 19/11/16.
//  Copyright © 2016 One Fat Giraffe. All rights reserved.
//

import UIKit
import Swinject


class DetailAssembler: Assembler {

    required init(parentAssembler: Assembler) {
        try! super.init(assemblies: [DetailContainer()], parentAssembler: parentAssembler)
    }
}

extension DetailAssembler {
    

    func presentDetailViewController(fromViewController fromViewController: UIViewController, task: Task) {
        let viewController = storyboard().instantiateViewControllerWithIdentifier("DetailViewControllerID") as! DetailViewController
        viewController.task = task
        
        let navigationController = UINavigationController(rootViewController: viewController)
        
        let idiom = UIDevice.currentDevice().userInterfaceIdiom
        switch idiom {
        case .Phone:
            fromViewController.presentViewController(navigationController, animated: true, completion: nil)
            
        case .Pad:
            let splitViewController = UISplitViewController()
            let detailNavigationController = UINavigationController()
            splitViewController.viewControllers = [navigationController, detailNavigationController]
            
            splitViewController.presentsWithGesture = false
            splitViewController.preferredDisplayMode = .AllVisible
            
            fromViewController.presentViewController(splitViewController, animated: true, completion: nil)
            
        default:
            fatalError("Device is not supported yet")
        }
    }
    
    func storyboard() -> SwinjectStoryboard {
        return SwinjectStoryboard.create(name: "List", bundle: NSBundle.mainBundle(), container: resolver)
    }
    

}
