//
//  WelcomeViewController.swift
//  WEC2018
//
//  Created by Nathan Tannar on 1/12/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import ViewAnimator

class WelcomeViewController: UIViewController {
    
    // MARK: - Properties
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.text = "Get My Life Together"
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var loginButton = UIButton(style: Stylesheet.Buttons.secondary) { [weak self] in
        $0.setTitle("Login", for: .normal)
        $0.addTarget(self,
                     action: #selector(WelcomeViewController.didTapLogin),
                     for: .touchUpInside)
    }
    
    lazy var signUpButton: UIButton = { [weak self] in
        let button = UIButton()
        let normalTitle = NSMutableAttributedString().normal("Don't have an account? ", font: .systemFont(ofSize: 14), color: .white).bold("Sign up here", size: 14, color: .white)
        let highlightedTitle = NSMutableAttributedString().normal("Don't have an account? ", font: .systemFont(ofSize: 14), color: UIColor.white.withAlphaComponent(0.3)).bold("Sign up here", size: 14, color: UIColor.white.withAlphaComponent(0.3))
        button.setAttributedTitle(normalTitle, for: .normal)
        button.setAttributedTitle(highlightedTitle, for: .highlighted)
        button.addTarget(self,
                         action: #selector(WelcomeViewController.didTapSignUp),
                         for: .touchUpInside)
        return button
    }()
    
    let contentView: UIView = {
        
        class ContentView: UIView {
            override func draw(_ rect: CGRect) {
                guard let context = UIGraphicsGetCurrentContext() else { return }
                context.beginPath()
                context.move(to: CGPoint(x: rect.minX, y: rect.minY + 100))
                context.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
                context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
                context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
                context.closePath()
                context.setFillColor(UIColor.primaryColor.cgColor)
                context.fillPath()
            }
        }
        let view = ContentView()
        view.backgroundColor = UIColor(hex: "FAFAFA")
        return view
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    // MARK: - Setup
    
    func setupView() {
        
        view.backgroundColor = UIColor(hex: "FAFAFA")
        view.addSubview(contentView)
        view.addSubview(imageView)
        view.addSubview(label)
        contentView.anchor(view.layoutMarginsGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 150)
        
        contentView.addSubview(loginButton)
        contentView.addSubview(signUpButton)
        loginButton.anchorCenterXToSuperview()
        loginButton.layer.cornerRadius = 22
        loginButton.anchor(bottom: view.layoutMarginsGuide.bottomAnchor, bottomConstant: 100, widthConstant: 200, heightConstant: 44)
        signUpButton.anchorCenterXToSuperview()
        signUpButton.anchor(loginButton.bottomAnchor, topConstant: 10)
        
        imageView.anchorCenterXToSuperview()
        imageView.centerYAnchor.constraint(equalTo: contentView.topAnchor, constant: 50).isActive = true
        imageView.anchor(widthConstant: 150, heightConstant: 150)
        
        label.anchorCenterXToSuperview()
        label.anchor(view.safeAreaLayoutGuide.topAnchor, topConstant: 50)
    }
    
    // MARK: - Networking
    
    // MARK: - User Actions
    
    @objc
    func didTapLogin() {
        
        present(UserLoginViewController().embeddedInNavigationController(),
                animated: true,
                completion: nil)
    }
    
    @objc
    func didTapSignUp() {
        
        present(UserSignUpViewController().embeddedInNavigationController(),
                animated: true,
                completion: nil)
    }
}
