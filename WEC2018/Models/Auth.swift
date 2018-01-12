//
//  Auth.swift
//  WEC2018
//
//  Created by Nathan Tannar on 1/12/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import LocalAuthentication
import BiometricAuthentication

class Auth: NSObject {
    
    static var shared = Auth()
    
    // MARK: - Properties
    
    var granted: Bool {
        return isGranted || !isSetup
    }
    
    var isSetup: Bool {
        if BioMetricAuthenticator.shared.faceIDAvailable() {
            return true
        } else {
            guard LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) else {
                return false
                
            }
            return true
        }
    }
    
    private var isGranted: Bool = false
    
    // MARK: - Initialization
    
    private override init() {
        super.init()
    }
    
    // MARK: - Methods [Public]
    
    func method() -> String {
        
        if BioMetricAuthenticator.shared.faceIDAvailable() {
            return "Face ID"
        } else {
            guard LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) else {
                return "Passcode Lock"
                
            }
            return "Touch ID"
        }
    }
    
    func unlock(completion: @escaping (Bool)->Void) {
        authenticateUser { result in
            self.isGranted = result
            completion(result)
        }
    }
    
    func lock() {
        isGranted = false
    }
    
    func destroy(completion: @escaping (Bool)->Void) {
        authenticateUser { result in
            if result {
                self.isGranted = false
            }
            completion(result)
        }
    }
    
    // MARK: - Methods [Private]
    
    func authenticateUser(completion: @escaping (Bool)->Void) {
        
        if BioMetricAuthenticator.canAuthenticate() {
            authenticateWithBiometrics(completion: { success in
                if success {
                    completion(true)
                } else {
                    self.authenticateWithPassword(success: {
                        completion(true)
                    })
                }
            })
        } else {
            self.authenticateWithPassword(success: {
                completion(true)
            })
        }
    }
    
    private func authenticateWithBiometrics(completion: @escaping (Bool)->Void) {
        BioMetricAuthenticator.authenticateWithBioMetrics(reason: "", cancelTitle: nil, success: {
            completion(true)
        }) { error in
            if error == .fallback || error == .biometryLockedout{
                completion(false)
            }
        }
    }
    
    private func authenticateWithPassword(success: @escaping ()->Void) {
        BioMetricAuthenticator.authenticateWithPasscode(reason: "", cancelTitle: nil, success: {
            success()
        }) { (error) in
            print(error)
        }
    }
}
