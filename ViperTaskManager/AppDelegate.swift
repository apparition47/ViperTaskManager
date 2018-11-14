//
//  AppDelegate.swift
//  ViperTaskManager
//
//  Created by Aaron Lee on 19/11/16.
//  Copyright © 2016 One Fat Giraffe. All rights reserved.
//

import UIKit
import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
    
    var window: UIWindow?
    let serviceLocatorAssembler = ServiceLocatorAssembler()
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        // Override point for customization after application launch.
        self.configureAppearance()
        
        let config = Realm.Configuration(schemaVersion: 4, migrationBlock: { migration, oldSchemaVersion in
            // We haven’t migrated anything yet, so oldSchemaVersion == 0
            if (oldSchemaVersion < 1) {
                // Nothing to do!
                // Realm will automatically detect new properties and removed properties
                // And will update the schema on disk automatically
            }
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        let rootAssembler = serviceLocatorAssembler.assembler.resolver.resolve(RootAssembler.self)!
        rootAssembler.presentRootViewController(fromViewController: window!.rootViewController!)
    }
    
    func configureAppearance() {
        window?.backgroundColor = MaterialColor.black
        window?.tintColor = MaterialColor.lightBlue
        
        UINavigationBar.appearance().barTintColor = MaterialColor.lightBlue
        UINavigationBar.appearance().tintColor = MaterialColor.white
        
        let titleTextAttributes: [NSAttributedString.Key: AnyObject] = [NSAttributedString.Key.foregroundColor: MaterialColor.white]
            UINavigationBar.appearance().titleTextAttributes = titleTextAttributes
            
            UISearchBar.appearance().barTintColor = MaterialColor.lightBlue
            UISearchBar.appearance().tintColor = MaterialColor.white
            //        if #available(iOS 9.0, *) {
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = MaterialColor.black
            //        } else {
            //            UITextField.appearanceWhenContainedWithin(UISearchBar.self).tintColor = MaterialColor.black
            //        }
            
            UITextField.appearance().keyboardAppearance = .dark
            UITextView.appearance().keyboardAppearance = .dark
    }
    
}

