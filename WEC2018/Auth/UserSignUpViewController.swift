//
//  UserSignUpViewController.swift
//  UserClient
//
//  Created by Nathan Tannar on 1/2/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import AlertHUDKit
import Parse

class UserSignUpViewController: UserLoginViewController {
    
    // MARK: - Properties
    
    var confirmPasswordTextField: UITextField = {
        let textField = UIAnimatedTextField()
        textField.placeholder = "Confirm Password"
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.tintColor = .primaryColor
        return textField
    }()

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign Up"
        loginButton.setTitle("Sign Up", for: .normal)
        passwordViewToggleButton.isHidden = true
        passwordResetButton.isHidden = true
    }
    
    override func setupViews() {
        super.setupViews()
        
        view.addSubview(confirmPasswordTextField)
        confirmPasswordTextField.anchor(passwordTextField.bottomAnchor, left: emailTextField.leftAnchor, right: emailTextField.rightAnchor, topConstant: 30, heightConstant: 44)
    }
    
    // MARK: - User Actions
    
    override func handleLogin() {
        
        guard passwordTextField.text == confirmPasswordTextField.text else {
            handleError("Passwords do not match")
            return
        }
        super.handleLogin()
    }
    
    override func authorize(_ email: String, password: String) {
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let user = PFUser()
        user.username = email
        user.email = email
        user.password = password
        
        user.signUpInBackground { (success, error) in
            UIApplication.shared.endIgnoringInteractionEvents()
            if success {
                self.dismiss(animated: true, completion: {
                    Router.navigateTo(.home, animated: true)
                })
            } else {
                self.handleError(error?.localizedDescription)
            }
        }
        
    }
}
