//
//  DetailAssembler.swift
//  ViperTaskManager
//
//  Created by Aaron Lee on 29/02/16.
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
        let viewController = self.viewController()
        viewController.task = task
        
        fromViewController.navigationController!.pushViewController(viewController, animated: true)
    }
    
//    func presentDetailViewController(fromViewController fromViewController: UIViewController, inView view: UIView, task: Task) {
//        let childViewController = self.viewController()
//        childViewController.task = task
//
//        fromViewController.addChildViewController(childViewController)
//        view.addSubview(childViewController.view)
//        
//        childViewController.view.translatesAutoresizingMaskIntoConstraints = false
//        
//        let childView = childViewController.view
//        let views: [String : AnyObject] = ["childView": childView]
//        
//        var childViewLayoutConstraint: [NSLayoutConstraint] = []
//        childViewLayoutConstraint += NSLayoutConstraint.constraintsWithVisualFormat("|-(0)-[childView]-(0)-|", options: [], metrics: nil, views: views)
//        childViewLayoutConstraint += NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[childView]-(0)-|", options: [], metrics: nil, views: views)
//        NSLayoutConstraint.activateConstraints(childViewLayoutConstraint)
//        
//        childViewController.didMoveToParentViewController(fromViewController)
//    }
    
    func storyboard() -> SwinjectStoryboard {
        return SwinjectStoryboard.create(name: "List", bundle: NSBundle.mainBundle(), container: resolver)
    }
    
    func viewController() -> DetailViewController {
        return storyboard().instantiateViewControllerWithIdentifier("DetailViewControllerID") as! DetailViewController
    }
    
}