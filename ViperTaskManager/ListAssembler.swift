//
//  ListAssembler.swift
//  ViperTaskManager
//
//  Created by Aaron Lee on 19/11/16.
//  Copyright © 2016 One Fat Giraffe. All rights reserved.
//

import UIKit
import Swinject
import SwinjectStoryboard

class ListAssembler {
    let assembler: Assembler
    
    init(parentAssembler: Assembler) {
        assembler = Assembler([ListContainer()], parent: parentAssembler)
    }
}

extension ListAssembler {
    func presentListViewController(fromViewController: UIViewController) {
        let viewController = storyboard().instantiateViewController(withIdentifier: "ListTableViewControllerID") as! ListTableViewController
        
        let navigationController = UINavigationController(rootViewController: viewController)

        let idiom = UIDevice.current.userInterfaceIdiom
        switch idiom {
        case .phone:
            fromViewController.present(navigationController, animated: true, completion: nil)
            
        case .pad:
            let splitViewController = UISplitViewController()
            let detailNavigationController = UINavigationController()
            splitViewController.viewControllers = [navigationController, detailNavigationController]
            
            splitViewController.presentsWithGesture = false
            splitViewController.preferredDisplayMode = .allVisible

            fromViewController.present(splitViewController, animated: true, completion: nil)
            
        default:
            fatalError("Device is not supported yet")
        }
    }
    
    func storyboard() -> UIStoryboard {
        return SwinjectStoryboard.create(name: "List", bundle: Bundle.main, container: assembler.resolver)
    }
}
