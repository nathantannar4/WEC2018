//
//  Router.swift
//  Shared
//
//  Created by Nathan Tannar on 1/1/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import Parse

class Router {
    
    enum Endpoint {
        case welcome, home
    }
    
    class func controllerFor(_ endpoint: Endpoint) -> UIViewController {
        switch endpoint {
        case .welcome:
            UIApplication.shared.statusBarStyle = .default
            return WelcomeViewController()
        case .home:
            
            guard let currentUser = PFUser.current() else { return WelcomeViewController() }
            
            UIApplication.shared.statusBarStyle = .lightContent
            
            let viewControllers = [
                UINavigationController(rootViewController: NoteTableViewController()),
                TimerViewController(),
                CalendarViewController()
            ]
            
            let tabBarController = UITabBarController()
            tabBarController.tabBar.isTranslucent = false
            tabBarController.tabBar.barTintColor = .white
            tabBarController.tabBar.tintColor = .primaryColor
            tabBarController.setViewControllers(viewControllers, animated: false)
            return tabBarController
        }
    }
    
    class func navigateTo(_ endpoint: Endpoint, animated: Bool) {
        
        UIApplication.shared.presentedWindow?.switchRootViewController(
            controllerFor(endpoint),
            animated: animated,
            duration: 0.3,
            options: .transitionFlipFromRight,
            completion: nil)
    }
    
}
