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
    var eventIcon = UIView()
    
    override var isSelected: Bool { didSet { updateSelected() } }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        eventIcon.backgroundColor = .primaryColor
        eventIcon.isHidden = true
        selectedView.backgroundColor = .primaryColor
        addSubview(selectedView)
        addSubview(dateLabel)
        addSubview(eventIcon)
        dateLabel.anchorCenterToSuperview()
        eventIcon.anchor(dateLabel.bottomAnchor, topConstant: 2, widthConstant: 5, heightConstant: 5)
        eventIcon.anchorCenterXToSuperview()
        eventIcon.layer.cornerRadius = 5 / 2
        selectedView.anchorCenterXToSuperview()
        selectedView.anchorCenterYToSuperview(constant: 2.5)
        selectedView.anchor(widthConstant: 50, heightConstant: 50)
        selectedView.layer.cornerRadius = 25
        selectedView.isHidden = true
    }
    
    func updateSelected() {
        
        selectedView.isHidden = !isSelected
        eventIcon.backgroundColor = isSelected ? .white : .primaryColor
        dateLabel.font = isSelected ? UIFont.boldSystemFont(ofSize: 15) : UIFont.systemFont(ofSize: 15)
        
        if isSelected {
            selectedView.animateWithBounceEffect(withCompletionHandler: nil)
        }
    }
    
}
