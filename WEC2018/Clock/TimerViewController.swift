//
//  TimerViewController.swift
//  WEC2018
//
//  Created by Nathan Tannar on 1/12/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import SwiftyPickerPopover

class TimerViewController: UIViewController {
    
    var startDate = Date()
    var endDate = Date().addSec(60*60)
    var timer = Timer()
    var count: TimeInterval = 0
    
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
        clock.tintColor = .primaryColor
        clock.centerTextColor = .primaryColor
        return clock
    }()
    
    lazy var endTimerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.setTitle("End", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.3), for: .highlighted)
        button.addTarget(self, action: #selector(didTapEndTimer), for: .touchUpInside)
        button.alpha = 0
        button.apply(Stylesheet.Global.shadow)
        return button
    }()
    
    lazy var startTimerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .primaryColor
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.setTitle("Start\nTimer", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.3), for: .highlighted)
        button.addTarget(self, action: #selector(didTapStartTimer), for: .touchUpInside)
        button.apply(Stylesheet.Global.shadow)
        return button
    }()
    
    private var enlapsedLabel: UILabel = {
        let label = UILabel()
        label.text = "Time Elapsed"
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    let countdownLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()
    
    private var remainingLabel: UILabel = {
        let label = UILabel()
        label.text = "Time Remaining"
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    let countUpLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Timer"
        tabBarItem = UITabBarItem(title: title, image: #imageLiteral(resourceName: "icon_timer"), tag: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
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
        view.addSubview(startTimerButton)
        view.addSubview(endTimerButton)
        
        labelsStackView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        
        clock.anchor(labelsStackView.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor)
        clock.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        
        startTimerButton.anchor(nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 46, rightConstant: 16, widthConstant: 75, heightConstant: 75)
        startTimerButton.layer.cornerRadius = 75 / 2
        
        endTimerButton.anchor(nil, left: nil, bottom: startTimerButton.topAnchor, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 16, rightConstant: 16, widthConstant: 75, heightConstant: 75)
        endTimerButton.layer.cornerRadius = 75 / 2
        
        let timelapseLabelsStackView = UIStackView(arrangedSubviews: [enlapsedLabel, countUpLabel, remainingLabel, countdownLabel])
        timelapseLabelsStackView.axis = .vertical
        timelapseLabelsStackView.alignment = .top
        timelapseLabelsStackView.distribution = .fillEqually
        view.addSubview(timelapseLabelsStackView)
        timelapseLabelsStackView.anchor(endTimerButton.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: startTimerButton.bottomAnchor, right: startTimerButton.leftAnchor, leftConstant: 16, rightConstant: 16)
        
        reload()
    }
    
    func reload() {
        
        startDate = Date()
        endDate = Date().addSec(60*60)
        count = 0
        clock.startDate = startDate
        clock.endDate = endDate
        startTimeLabel.text = startDate.string(dateStyle: .none, timeStyle: .short)
        endTimeLabel.text = endDate.string(dateStyle: .none, timeStyle: .short)
        startTimerButton.backgroundColor = .primaryColor
        startTimerButton.setTitle("Start", for: .normal)
        clock.disabled = false
        countUpLabel.text = timeString(time: count)
        countdownLabel.text = timeString(time: count)
        endTimerButton.alpha = 0
    }
    
    @objc
    func didTapStartTimer() {
        
        let isDisabled = !clock.disabled
        clock.disabled = isDisabled
        startTimerButton.backgroundColor = isDisabled ? UIColor.primaryColor.darker(by: 10) : UIColor.primaryColor.lighter(by: 10)
        
        AnimationClass.flipAnimation(startTimerButton) {}
        
        UIView.animate(withDuration: 0.3) {
            self.endTimerButton.alpha = 1
            if isDisabled {
                self.startTimerButton.setTitle("Pause", for: .normal)
                self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.handeTimer), userInfo: nil, repeats: true)
            } else {
                self.startTimerButton.setTitle("Resume", for: .normal)
                self.timer.invalidate()
            }
        }
    }
    
    @objc
    func didTapEndTimer() {
        
        UIView.animate(withDuration: 0.3) {
            self.endTimerButton.alpha = 0
        }
        timer.invalidate()
        AnimationClass.flipAnimation(startTimerButton) {}
        reload()
    }
    
    @objc
    func handeTimer() {
        
        count += 0.001
        countUpLabel.text = timeString(time: count)
        let remaining: TimeInterval = endDate.timeIntervalSince(startDate) - count
        countdownLabel.text = timeString(time: remaining)
    }
    
    func timeString(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        let miliseconds = Int(time * 100) % 100
        print(miliseconds)
        return String(format: "%02i:%02i:%02i:%02d", hours, minutes, seconds, miliseconds)
    }
    
}

extension TimerViewController: TenClockDelegate {
    
    func timesChanged(_ clock: TenClock, startDate: Date, endDate: Date) {
        
        self.startDate = startDate
        self.endDate = endDate
        startTimeLabel.text = startDate.string(dateStyle: .none, timeStyle: .short)
        endTimeLabel.text = endDate.string(dateStyle: .none, timeStyle: .short)
    }
    
    func timesUpdated(_ clock: TenClock, startDate: Date, endDate: Date) {
        
        self.startDate = startDate
        self.endDate = endDate
        startTimeLabel.text = startDate.string(dateStyle: .none, timeStyle: .short)
        endTimeLabel.text = endDate.string(dateStyle: .none, timeStyle: .short)
    }
    
}

