//
//  ServiceLocatorContainer.swift
//  ViperTaskManager
//
//  Created by Aaron Lee on 24/02/16.
//  Copyright © 2016 One Fat Giraffe. All rights reserved.
//
//  Generated by Swift-Viper templates. Find latest version at https://github.com/Nikita2k/SwiftViper
//

import Foundation
import Swinject

class ServiceLocatorContainer: Assembly {
    func assemble(container: Container) {
        container.register(RootAssembler.self) { r in
            let delegate = UIApplication.shared.delegate as! AppDelegate
            return RootAssembler(parentAssembler: delegate.serviceLocatorAssembler.assembler)
        }
    }
}
