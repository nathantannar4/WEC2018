//
//  AppDelegate.swift
//  WEC2018
//
//  Created by Nathan Tannar on 1/12/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import Parse
import AlertHUDKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    /// A visual effect view for security when biometric authentication is on
    private var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        return blurView
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        UIApplication.shared.statusBarStyle = .lightContent
        
        // AlertHUDKit Defaults
        Alert.Defaults.Color.Info = .primaryColor
        Alert.Defaults.Color.Danger = .red
        Alert.Defaults.Color.Success = .primaryColor
        Alert.Defaults.Font.Info = .boldSystemFont(ofSize: 14)
        Alert.Defaults.Font.Warning = .boldSystemFont(ofSize: 14)
        Alert.Defaults.Font.Danger = .boldSystemFont(ofSize: 14)
        Alert.Defaults.Font.Success = .boldSystemFont(ofSize: 14)
        
        connectToParseServer()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        if PFUser.current() != nil {
            window?.rootViewController = Router.controllerFor(.home)
        } else {
            window?.rootViewController = Router.controllerFor(.welcome)
        }
        addSecurityBlurEffect()
        window?.makeKeyAndVisible()
                
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
        toggleSecurityBlur(isLocked: true)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
        toggleSecurityBlur(isLocked: false)
    }
    
    func connectToParseServer() {
        
        PlannerEvent.registerSubclass()
        Task.registerSubclass()
        Note.registerSubclass()
        
        Parse.enableLocalDatastore()
        Parse.initialize(with: ParseClientConfiguration(block: {
            $0.applicationId = "758c0e8286b1ea728d6f941f2f6e3fe4db49cef8"
            $0.clientKey = "6fa4e837b886f5a0b7fc902c31cac8fa6b37a31e"
            $0.server = "https://nathantannar.me/api/sand"
        }))
    }
    
    // MARK: - Auth Security Blur
    
    private func addSecurityBlurEffect() {
        
        if blurView.superview == nil {
            // Delay to account for launch screen annimation
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                self.window?.addSubview(self.blurView)
                self.blurView.fillSuperview()
            })
        }
    }
    
    private func toggleSecurityBlur(isLocked: Bool) {
        
        if isLocked {
            if !Auth.shared.granted {
                Auth.shared.unlock(completion: { result in
                    self.blurView.isHidden = result
                })
            } else {
                self.blurView.isHidden = true
            }
        } else {
            if Auth.shared.isSetup {
                Auth.shared.lock()
                blurView.isHidden = false
            }
        }
    }

}
