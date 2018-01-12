//
//  NewNoteView.swift
//  WEC2018
//
//  Created by Shayne Kelly II on 2018-01-12.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit

class NewNoteView: UIView {
    
    //MARK: Properties
    var titleText: InputTextView = InputTextView()
    var dateLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.backgroundColor = .white
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        
        titleText.placeholder = "Note"
        addSubview(titleText)
        addSubview(dateLabel)
        
        dateLabel.anchor(topAnchor, left: leftAnchor, bottom: titleText.topAnchor, right: rightAnchor, topConstant: 20, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 30)
        titleText.anchor(dateLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 300, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 0)
        
        dateLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        dateLabel.textAlignment = .center
        titleText.becomeFirstResponder()
        
    }
}
