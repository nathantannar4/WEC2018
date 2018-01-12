//
//  FormerInputAccessoryView.swift
//  WEC2018
//
//  Created by Nathan Tannar on 1/12/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit

class TextInputAccessoryView: UIToolbar {
    
    private weak var view: UIView?
    
    init(view: UIView?) {
        super.init(frame: CGRect(origin: CGPoint(), size: CGSize(width: 0, height: 44)))
        self.view = view
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        barTintColor = .white
        tintColor = .primaryColor
        clipsToBounds = true
        isUserInteractionEnabled = true
        
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(TextInputAccessoryView.handleDoneButton))
        let rightSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        setItems([flexible, doneButton, rightSpace], animated: false)
        
        let topLineView = UIView()
        topLineView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        topLineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(topLineView)
        
        let bottomLineView = UIView()
        bottomLineView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        bottomLineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomLineView)
        
        let leftLineView = UIView()
        leftLineView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        leftLineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(leftLineView)
        
        let rightLineView = UIView()
        rightLineView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        rightLineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(rightLineView)
        
        let constraints = [
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-0-[topLine(0.5)]",
                options: [],
                metrics: nil,
                views: ["topLine": topLineView]
            ),
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:[bottomLine(0.5)]-0-|",
                options: [],
                metrics: nil,
                views: ["bottomLine": bottomLineView]
            ),
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-10-[leftLine]-10-|",
                options: [],
                metrics: nil,
                views: ["leftLine": leftLineView]
            ),
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-10-[rightLine]-10-|",
                options: [],
                metrics: nil,
                views: ["rightLine": rightLineView]
            ),
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-0-[topLine]-0-|",
                options: [],
                metrics: nil,
                views: ["topLine": topLineView]
            ),
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-0-[bottomLine]-0-|",
                options: [],
                metrics: nil,
                views: ["bottomLine": bottomLineView]
            ),
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-84-[leftLine(0.5)]",
                options: [],
                metrics: nil,
                views: ["leftLine": leftLineView]
            ),
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:[rightLine(0.5)]-74-|",
                options: [],
                metrics: nil,
                views: ["rightLine": rightLineView]
            )
        ]
        addConstraints(constraints.flatMap { $0 })
    }
    
    @objc dynamic func handleDoneButton() {
        view?.endEditing(true)
    }
}

