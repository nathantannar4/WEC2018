//
//  NotesTableViewCell.swift
//  WEC2018
//
//  Created by Shayne Kelly II on 2018-01-12.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    
    class var reuseIdentifier: String {
        return "NoteTableViewCell"
    }

    //MARK: Properties
    var contentLabel: UILabel = UILabel()
    var dateLabel: UILabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView() {
        
        addSubview(contentLabel)
        addSubview(dateLabel)
        
        contentLabel.anchor(topAnchor, left: leftAnchor, bottom: dateLabel.topAnchor, right: rightAnchor, topConstant: 8, leftConstant: 24, bottomConstant: 4, rightConstant: 24, widthConstant: 0, heightConstant: 0)
        dateLabel.anchor(contentLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 24, bottomConstant: 8, rightConstant: 24, widthConstant: 0, heightConstant: 0)
        
        dateLabel.textColor = UIColor.gray
    }
}
