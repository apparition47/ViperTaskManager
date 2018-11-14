//
//  RootRouter.swift
//  ViperTaskManager
//
//  Created by Aaron Lee on 20/02/16.
//  Copyright © 2016 One Fat Giraffe. All rights reserved.
//
//  Generated by Swift-Viper templates. Find latest version at https://github.com/Nikita2k/SwiftViper
//

import UIKit
import Swinject


protocol RootRouterInputProtocol: class {
    func openListViewController(fromViewController: UIViewController)
    
    var listAssembler: ListAssembler! { get set }
}

protocol RootParentRouterProtocol: class {
    
}

class RootRouter: RootRouterInputProtocol {
    
    var listAssembler: ListAssembler!
    
    func openListViewController(fromViewController: UIViewController) {
        listAssembler.presentListViewController(fromViewController: fromViewController)
    }
    
}

extension RootRouter: ListParentRouterProtocol {
    
}
