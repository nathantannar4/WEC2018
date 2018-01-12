//
//  CalendarCell.swift
//  WEC2018
//
//  Created by Nathan Tannar on 1/12/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import JTAppleCalendar
import ViewAnimator

class CalendarCell: JTAppleCell {
    
    class var reuseIdentifier: String {
        return "CalendarCell"
    }
    
    var dateLabel = UILabel()
    var selectedView = AnimationView()
    
    override var isSelected: Bool { didSet { updateSelected() } }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        selectedView.backgroundColor = .primaryColor
        addSubview(selectedView)
        addSubview(dateLabel)
        dateLabel.anchorCenterToSuperview()
        selectedView.anchorCenterToSuperview()
        selectedView.anchor(widthConstant: 50, heightConstant: 50)
        selectedView.layer.cornerRadius = 25
        selectedView.isHidden = true
    }
    
    func updateSelected() {
        
        selectedView.isHidden = !isSelected
        
        if isSelected {
            selectedView.animateWithBounceEffect(withCompletionHandler: nil)
        }
    }
    
}
