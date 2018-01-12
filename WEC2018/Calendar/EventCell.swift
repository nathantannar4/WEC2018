
//
//  EventCell.swift
//  UserClient
//
//  Created by Nathan Tannar on 1/7/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit

class EventCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    class var reuseIdentifier: String {
        return "EventCell"
    }
    
    weak var controller: UIViewController?
    
    var dataSourceItem: Any? {
        didSet {
            guard let event = dataSourceItem as? PlannerEvent else { return }
            
            titleTextView.text = event.title
            notesTextView.text = event.notes
            
            if let startDate = event.startDate {
                timeLabel.text = startDate.string(dateStyle: .none, timeStyle: .short)
                dateLabel.text = "\(startDate.monthNameShort) \(startDate.dayTwoDigit_Int), \(startDate.yearFourDigit)"
                
                if let endDate = event.endDate {
                    let seconds = endDate.timeIntervalSince(startDate)
                    let minutes = seconds / 60
                    if minutes < 60 {
                        lengthLabel.text = "\(Int(minutes)) Minutes"
                    } else {
                        let hours = minutes / 60
                        lengthLabel.text = "\(Int(hours)) Hours"
                        let remainingMinutes = Int((hours - Double(Int(hours))) * 60)
                        if remainingMinutes > 0 {
                            lengthLabel.text = "\(Int(hours)) Hours\n\(remainingMinutes) Minutes"
                        } else {
                            lengthLabel.text = "\(Int(hours)) Hours"
                        }
                    }
                } else {
                    lengthLabel.text = nil
                }
            }
        }
    }
    
    let titleTextView: InputTextView = {
        let textView = InputTextView()
        textView.placeholder = "Title"
        textView.isUserInteractionEnabled = false
        textView.tintColor = .primaryColor
        textView.font = .boldSystemFont(ofSize: 18)
        return textView
    }()
    
    let dateLabel = UILabel(style: Stylesheet.Labels.subtitle) {
        $0.textColor = .darkGray
    }
    
    let timeLabel = UILabel(style: Stylesheet.Labels.title) {
        $0.textColor = .primaryColor
        $0.font = UIFont.systemFont(ofSize: 36, weight: .bold)
    }
    
    let lengthLabel = UILabel(style: Stylesheet.Labels.title) {
        $0.textColor = .darkGray
        $0.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    }
    
    let notesTextView: InputTextView = {
        let textView = InputTextView()
        textView.placeholder = "Notes"
        textView.isUserInteractionEnabled = false
        textView.tintColor = .primaryColor
        textView.font = .systemFont(ofSize: 13)
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods [Public]
    
    func setupViews() {
        
        clipsToBounds = false
        backgroundColor = .white
        layer.cornerRadius = 5
        apply(Stylesheet.Global.shadow)
        
        addSubview(titleTextView)
        addSubview(dateLabel)
        addSubview(lengthLabel)
        addSubview(timeLabel)
        addSubview(notesTextView)
        
        dateLabel.anchor(topAnchor, left: leftAnchor, right: nil, topConstant: 12, leftConstant: 12, rightConstant: 4, heightConstant: 15)
        timeLabel.anchor(dateLabel.bottomAnchor, left: dateLabel.leftAnchor, topConstant: 4, heightConstant: 32)
        
        lengthLabel.anchor(nil, left: timeLabel.rightAnchor, bottom: timeLabel.bottomAnchor, right: nil, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 0)
        
        titleTextView.anchor(timeLabel.bottomAnchor, left: dateLabel.leftAnchor, right: rightAnchor, topConstant: 4, rightConstant: 12, heightConstant: 30)
        
        notesTextView.anchor(titleTextView.bottomAnchor, left: titleTextView.leftAnchor, bottom: bottomAnchor, right: titleTextView.rightAnchor, bottomConstant: 4)
    }
    
}
