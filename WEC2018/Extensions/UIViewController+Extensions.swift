//
//  UIViewController+Extensions.swift
//  UserClient
//
//  Created by Nathan Tannar on 1/1/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import AlertHUDKit

extension UIViewController {
    
    func embeddedInNavigationController() -> UINavigationController {
        return UINavigationController(rootViewController: self)
    }
    
    @objc
    func dismissAnimated() {
        dismiss(animated: true, completion: nil)
    }
    
    func handleError(_ text: String? = nil) {
        let message = text?.capitalized ?? "Sorry, an error occurred"
        print(message)
        Ping(text: message, style: .danger).show(animated: true, duration: 1)
    }
    
    func handleSuccess(_ text: String? = nil) {
        let message = text?.capitalized ?? "Success"
        print(message)
        Ping(text: message, style: .success).show(animated: true, duration: 1)
    }
}
