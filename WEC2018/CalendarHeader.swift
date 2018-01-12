//
//  CalendarHeader.swift
//  WEC2018
//
//  Created by Nathan Tannar on 1/12/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarHeader: JTAppleCollectionReusableView {
    
    class var reuseIdentifier: String {
        return "CalendarHeader"
    }
    
    var title = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        addSubview(title)
        title.fillSuperview()
        
    }
}
