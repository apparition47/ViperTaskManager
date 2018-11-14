//
//  RootAssembly.swift
//  ViperTaskManager
//
//  Created by Aaron Lee on 20/02/16.
//  Copyright © 2016 One Fat Giraffe. All rights reserved.
//

import UIKit
import Swinject
import SwinjectStoryboard

class RootAssembler {
    let assembler: Assembler
    
    init(parentAssembler: Assembler) {
        assembler = Assembler([RootContainer()], parent: parentAssembler)
    }
}

extension RootAssembler {
    func presentRootViewController(fromViewController: UIViewController) {
        guard let navigationController = fromViewController as? UINavigationController else  {
            return
        }
        let viewController = storyboard().instantiateInitialViewController()! as! RootViewController
        
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func storyboard() -> SwinjectStoryboard {
        return SwinjectStoryboard.create(name: "Root", bundle: Bundle.main, container: assembler.resolver)
    }
}
