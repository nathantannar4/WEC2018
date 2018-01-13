//
//  EventDetailViewController.swift
//  UserClient
//
//  Created by Nathan Tannar on 1/7/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import Parse
import SwiftyPickerPopover

class EventDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var event: PlannerEvent?
    
    let cell: EventCell = {
        let cell = EventCell()
        cell.titleTextView.isUserInteractionEnabled = true
        cell.notesTextView.isUserInteractionEnabled = true
        cell.notesTextView.isScrollEnabled = true
        cell.layer.shadowOpacity = 0
        return cell
    }()
    
    lazy var closeButton: UIButton = { [weak self] in
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon_close"), for: .normal)
        button.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        return button
    }()
    
    lazy var tableView: UITableView = { [weak self] in
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .primaryColor
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.titleLabel?.textAlignment = .center
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.3), for: .highlighted)
        button.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
        button.apply(Stylesheet.Global.shadow)
        return button
    }()
    
    private lazy var textInputAccessoryView = TextInputAccessoryView(view: self.view)
    
    // MARK: - Initialization
    
    init(event: PlannerEvent? = nil) {
        super.init(nibName: nil, bundle: nil)
        if event == nil {
            self.event = PlannerEvent()
            self.event?.user = PFUser.current()
            tableView.isHidden = true
            cell.dateLabel.text = "Date"
            cell.timeLabel.text = "Time"
            cell.lengthLabel.text = "Duration"
        } else {
            self.event = event
            cell.dataSourceItem = event
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func didTapSave() {
        
        event?.saveInBackground(block: { (success, error) in
            guard success else {
                self.handleError(error?.localizedDescription)
                return
            }
            self.didTapClose()
        })
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cell.titleTextView.inputAccessoryView = textInputAccessoryView
        cell.titleTextView.onTextDidChange { [weak self] in
            self?.event?.title = $0
        }
    
        cell.notesTextView.inputAccessoryView = textInputAccessoryView
        cell.notesTextView.onTextDidChange { [weak self] in
            self?.event?.notes = $0
        }
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(showTimePicker))
        cell.timeLabel.isUserInteractionEnabled = true
        cell.timeLabel.addGestureRecognizer(tapGesture1)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(showDatePicker))
        cell.dateLabel.isUserInteractionEnabled = true
        cell.dateLabel.addGestureRecognizer(tapGesture2)
        
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(showLengthPicker))
        cell.lengthLabel.isUserInteractionEnabled = true
        cell.lengthLabel.addGestureRecognizer(tapGesture3)
        
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3) {
            self.saveButton.alpha = 1
            self.closeButton.alpha = 1
            self.tableView.alpha = 1
        }
    }
    
    // MARK: - Setup
    
    func setupView() {
        
        view.backgroundColor = .white
        view.addSubview(cell)
        view.addSubview(closeButton)
        view.addSubview(tableView)
        view.addSubview(saveButton)
        
        cell.anchor(view.layoutMarginsGuide.topAnchor, left: view.layoutMarginsGuide.leftAnchor, right: view.layoutMarginsGuide.rightAnchor, heightConstant: 200)
        
        closeButton.anchor(view.layoutMarginsGuide.topAnchor, left: nil, bottom: nil, right: view.layoutMarginsGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 40, heightConstant: 40)
        
        tableView.anchor(cell.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        saveButton.anchor(nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 46, rightConstant: 16, widthConstant: 75, heightConstant: 75)
        saveButton.layer.cornerRadius = 75 / 2
        
        saveButton.alpha = 0
        closeButton.alpha = 0
        tableView.alpha = 0
    }
    
    
    // MARK: - Networking
    
    
    
    // MARK: - User Actions
    
    @objc
    func didTapClose() {
        
        UIView.animate(withDuration: 0.3) {
            self.saveButton.alpha = 0
            self.closeButton.alpha = 0
            self.tableView.alpha = 0
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func handleDoneButton() {
        view.endEditing(true)
    }
    
    @objc
    func showTimePicker() {
        
        DatePickerPopover(title: "Time")
            .setDateMode(.time)
            .setMinuteInterval(5)
            .setDoneButton(title: "Save", color: .primaryColor, action: { popover, date in
                // Update
                self.cell.timeLabel.text = date.string(dateStyle: .none, timeStyle: .short)
            })
            .setCancelButton(title: "Cancel", color: .darkGray, action: nil)
            .appear(originView: cell.timeLabel, baseViewController: self)
    }
    
    @objc
    func showDatePicker() {
        
        DatePickerPopover(title: "Day")
            .setMinimumDate(Date())
            .setDateMode(.date)
            .setSelectedDate(Date())
            .setDoneButton(title: "Save", color: .primaryColor, action: { popover, date in
                // Update
                self.cell.dateLabel.text = "\(date.monthNameShort) \(date.dayTwoDigit_Int), \(date.yearFourDigit)"
            })
            .setCancelButton(title: "Cancel", color: .darkGray, action: nil)
            .appear(originView: cell.dateLabel, baseViewController: self)
    }
    
    @objc
    func showLengthPicker() {
        
        CountdownPickerPopover(title: "Length")
            .setSelectedTimeInterval(TimeInterval())
            .setDoneButton(title: "Save", color: .primaryColor, action: { [weak self] popover, timeInterval in
                // Update
                if let startDate = self?.event?.startDate {
                    let endDate = Date(timeInterval: timeInterval, since: startDate)
                    let seconds = endDate.timeIntervalSince(startDate)
                    let minutes = seconds / 60
                    if minutes < 60 {
                        self?.cell.lengthLabel.text = "\(Int(minutes)) Minutes"
                    } else {
                        let hours = minutes / 60
                        let remainingMinutes = Int((hours - Double(Int(hours))) * 60)
                        if remainingMinutes > 0 {
                            self?.cell.lengthLabel.text = "\(Int(hours)) Hours\n\(remainingMinutes) Minutes"
                        } else {
                            self?.cell.lengthLabel.text = "\(Int(hours)) Hours"
                        }
                    }
                }
            })
            .setCancelButton(title: "Cancel", color: .darkGray, action: nil)
            .appear(originView: cell.lengthLabel, baseViewController: self)
    }
}

extension EventDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UITableViewHeaderFooterView()
        header.contentView.backgroundColor = .primaryColor
        header.textLabel?.text = section == 0 ? "Vendors" : "Tasks"
        header.textLabel?.apply(Stylesheet.Labels.subtitle)
        header.textLabel?.textColor = .white
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.contentView.backgroundColor = UIColor(hex: "FAFAFA")
        cell.tintColor = .tertiaryColor
        cell.accessoryType = indexPath.row % 2 == 0 ? .checkmark : .none
        cell.textLabel?.text = "Task"
        cell.textLabel?.apply(Stylesheet.Labels.subtitle)
        cell.detailTextLabel?.text = "Due: \(Date().stringify())"
        return cell
    }
}

extension EventDetailViewController: UITableViewDelegate {
    
}

