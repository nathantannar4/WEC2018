//
//  UserLoginViewController.swift
//  UserClient
//
//  Created by Nathan Tannar on 1/1/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import AlertHUDKit
import Parse

class UserLoginViewController: UILoginViewController {
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.apply(Stylesheet.ViewController.view)
        tintColor = .primaryColor
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(dismissAnimated))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.apply(Stylesheet.ViewController.navigationBar)
    }
    
    // MARK: - User Actions
    
    override func authorize(_ email: String, password: String) {
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        PFUser.logInWithUsername(inBackground: email, password: password) { (user, error) in
            UIApplication.shared.endIgnoringInteractionEvents()
            if error == nil, user != nil {
                Router.navigateTo(.home, animated: true)
            } else {
                self.handleError(error?.localizedDescription)
            }
        }
    }
    
    override func presentError(_ text: String) {
        
        Ping(text: text, style: .danger).show(animated: true, duration: 1)
    }
    
    override func handlePasswordReset() {
        
        let alert = UIAlertController(title: "Reset Password", message: "Please enter your accounts email", preferredStyle: .alert)
        alert.removeTransparency()
        alert.view.tintColor = .primaryColor
        alert.addTextField { $0.placeholder = "Email" }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            let email = alert.textFields?.first?.text ?? ""
            UIApplication.shared.beginIgnoringInteractionEvents()
            PFUser.requestPasswordResetForEmail(inBackground: email, block: { success, error in
                UIApplication.shared.endIgnoringInteractionEvents()
                if success {
                    self?.handleSuccess("An email has been sent with a reset link")
                } else {
                    self?.handleError(error?.localizedDescription)
                }
            })
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
