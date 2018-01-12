//
//  TimerViewController.swift
//  WEC2018
//
//  Created by Nathan Tannar on 1/12/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    
    private var startLabel: UILabel = {
        let label = UILabel()
        label.text = "Start Time"
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.textAlignment = .center
        return label
    }()
    
    var startTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private var endLabel: UILabel = {
        let label = UILabel()
        label.text = "End Time"
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.textAlignment = .center
        return label
    }()
    
    var endTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    lazy var clock: TenClock = {
        let clock = TenClock()
        clock.delegate = self
        return clock
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let leftStackView = UIStackView(arrangedSubviews: [startLabel, startTimeLabel])
        leftStackView.axis = .vertical
        let rightStackView = UIStackView(arrangedSubviews: [endLabel, endTimeLabel])
        rightStackView.axis = .vertical
        let labelsStackView = UIStackView(arrangedSubviews: [leftStackView, rightStackView])
        labelsStackView.distribution = .fillEqually

        view.addSubview(labelsStackView)
        view.addSubview(clock)
        
        labelsStackView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 300)
        
        clock.anchor(labelsStackView.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 300)
    }
    
}

extension TimerViewController: TenClockDelegate {
    
    func timesChanged(_ clock: TenClock, startDate: Date, endDate: Date) {
        
        startTimeLabel.text = startDate.string(dateStyle: .none, timeStyle: .short)
        endTimeLabel.text = endDate.string(dateStyle: .none, timeStyle: .short)
    }
    
    func timesUpdated(_ clock: TenClock, startDate: Date, endDate: Date) {
        
        
    }
    
}

