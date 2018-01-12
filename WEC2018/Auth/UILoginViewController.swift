/*
 MIT License
 
 Copyright © 2017 Nathan Tannar.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import UIKit
import SystemConfiguration.CaptiveNetwork

open class UILoginViewController: UIViewController {
    
    public enum LoginError {
        case noEmail, noPassword, invalidEmail, invalidPassword, unknownUser, incorrectPassword, networkError
    }
    
    // MARK: - Properties
    
    open var emailTextField: UITextField = {
        let textField = UIAnimatedTextField()
        textField.placeholder = "Email"
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        return textField
    }()
    
    open var passwordTextField: UITextField = {
        let textField = UIAnimatedTextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        return textField
    }()
    
    open lazy var passwordViewToggleButton: UIButton = { [weak self] in
        let button = UIButton()
        button.tintColor = UIColor(red: 0, green: 0.5, blue: 1, alpha: 1)
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        button.setImage(UIImage(named: "icon_unlock")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(handlePasswordViewToggle), for: .touchUpInside)
        button.adjustsImageWhenHighlighted = false
        return button
    }()
    
    open lazy var loginButton: UIButton = { [weak self] in
        let button = UIButton()
        button.backgroundColor = UIColor(red: 0, green: 0.5, blue: 1, alpha: 1)
        button.layer.cornerRadius = 22
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(UIColor(white: 1, alpha: 0.3), for: .highlighted)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    open lazy var passwordResetButton: UIButton = { [weak self] in
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.medium)
        button.contentHorizontalAlignment = .left
        button.setTitle("Reset Password", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(UIColor(white: 0, alpha: 0.3), for: .highlighted)
        button.addTarget(self, action: #selector(handlePasswordReset), for: .touchUpInside)
        return button
    }()
    
    open var minimumPasswordLength = 8
    
    open var tintColor: UIColor? {
        didSet {
            emailTextField.tintColor = tintColor
            passwordTextField.tintColor = tintColor
            passwordViewToggleButton.tintColor = tintColor
            loginButton.backgroundColor = tintColor
            passwordResetButton.setTitleColor(tintColor, for: .normal)
            passwordResetButton.setTitleColor(tintColor?.withAlphaComponent(0.3), for: .highlighted)
        }
    }
    
    fileprivate var loginButtonConstraints: [NSLayoutConstraint]?
    fileprivate var keyboardIsHidden: Bool = true
    
    // MARK: - View Life Cycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        view.backgroundColor = .groupTableViewBackground
        setupViews()
        registerObservers()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        navigationController?.navigationBar.isTranslucent = false
    }
    
    open func setupViews() {
        
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(passwordViewToggleButton)
        view.addSubview(loginButton)
        view.addSubview(passwordResetButton)
        
        emailTextField.anchor(view.layoutMarginsGuide.topAnchor, left: view.layoutMarginsGuide.leftAnchor, right: view.layoutMarginsGuide.rightAnchor, topConstant: 44, heightConstant: 44)
        passwordTextField.anchor(emailTextField.bottomAnchor, left: emailTextField.leftAnchor, right: emailTextField.rightAnchor, topConstant: 30, heightConstant: 44)
        passwordViewToggleButton.anchor(passwordTextField.topAnchor, bottom: passwordTextField.bottomAnchor, right: passwordTextField.rightAnchor, widthConstant: 44)
        loginButtonConstraints = loginButton.anchor(bottom: view.layoutMarginsGuide.bottomAnchor, right: view.layoutMarginsGuide.rightAnchor, bottomConstant: 16, widthConstant: 100, heightConstant: 44)
        passwordResetButton.anchor(passwordTextField.bottomAnchor, left: passwordTextField.leftAnchor, topConstant: 16, widthConstant: 200, heightConstant: 30)
    }
    
    fileprivate func registerObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChangeFrame(notification:)), name: .UIKeyboardDidChangeFrame, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Methods [Public]
    
    open func authorize(_ email: String, password: String) {
        
    }
    
    open func handleError(_ error: LoginError) {
        
        switch error {
        case .incorrectPassword:
            presentError("Incorrect Password")
        case .invalidEmail:
            presentError("Invalid Email")
        case .invalidPassword:
            presentError("Passwords must be \(minimumPasswordLength) characters or more")
        case .networkError:
            presentError("Oops! Network connection unavailable")
        case .noEmail:
            presentError("Please enter your email")
        case .noPassword:
            presentError("Please enter your password")
        case .unknownUser:
            presentError("Unknown User")
        }
    }
    
    open func presentError(_ text: String) {
        print(text)
    }
    
    // MARK: - User Actions
    
    @objc
    open func handleLogin() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        guard let emailText = emailTextField.text, let passwordText = passwordTextField.text else { return }
        guard !emailText.isEmpty else { return handleError(.noEmail) }
        guard !passwordText.isEmpty else { return handleError(.noPassword) }
        guard emailText.isValidEmail else { return handleError(.invalidEmail) }
        guard passwordText.count >= minimumPasswordLength else { return handleError(.invalidPassword) }
        guard UIApplication.shared.isConnectedToNetwork else { return handleError(.networkError) }
        authorize(emailText, password: passwordText)
    }
    
    @objc
    open func handlePasswordViewToggle() {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        if passwordTextField.isSecureTextEntry {
            passwordViewToggleButton.setImage(
                UIImage(named: "icon_unlock")?.withRenderingMode(.alwaysTemplate),
                for: .normal)
        } else {
            passwordViewToggleButton.setImage(
                UIImage(named: "icon_lock")?.withRenderingMode(.alwaysTemplate),
                for: .normal)
        }
    }
    
    @objc
    open func handlePasswordReset() {
        
    }
    
    @objc
    func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Keyboard Observer
    
    @objc
    open func keyboardDidChangeFrame(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, !keyboardIsHidden, let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber {
            guard let constant = self.loginButtonConstraints?.first?.constant else { return }
            guard keyboardSize.height <= constant else { return }
            UIView.animate(withDuration: TimeInterval(truncating: duration), animations: { () -> Void in
                self.loginButtonConstraints?.first?.constant = -keyboardSize.height + self.view.layoutMargins.bottom - 16
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc
    open func keyboardWillShow(notification: NSNotification) {
        keyboardIsHidden = false
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber {
            UIView.animate(withDuration: TimeInterval(truncating: duration), animations: { () -> Void in
                self.loginButtonConstraints?.first?.constant = -keyboardSize.height + self.view.layoutMargins.bottom - 16
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc
    open func keyboardWillHide(notification: NSNotification) {
        keyboardIsHidden = true
        if let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber {
            UIView.animate(withDuration: TimeInterval(truncating: duration), animations: { () -> Void in
                self.loginButtonConstraints?.first?.constant = -16
                self.view.layoutIfNeeded()
            })
        }
    }
    
}
