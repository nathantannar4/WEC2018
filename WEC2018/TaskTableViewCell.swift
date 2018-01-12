//
//  TaskTableViewCell.swift
//  WEC2018
//
//  Created by Shayne Kelly II on 2018-01-12.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    class var reuseIdentifier: String {
        return "TaskTableViewCell"
    }
    
    //MARK: Properties
    var contentLabel: UILabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView() {
        
        addSubview(contentLabel)
        
        contentLabel.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 16, leftConstant: 24, bottomConstant: 16, rightConstant: 24, widthConstant: 0, heightConstant: 0)
    }
}
