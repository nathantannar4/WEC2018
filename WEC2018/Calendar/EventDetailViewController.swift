//
//  EventDetailViewController.swift
//  UserClient
//
//  Created by Nathan Tannar on 1/7/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import Parse
import ParseLiveQuery
import SwiftyPickerPopover

class EventDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    let event: PlannerEvent?
    
    lazy var tasksQuery: PFQuery<Task> = {
        if event?.objectId == nil {
            return Task.query()?.whereKey("user", equalTo: PFUser.current() ?? "").includeKey("user").whereKey("event", equalTo: "").addDescendingOrder("updatedAt") as! PFQuery<Task>
        }
        return Task.query()?.whereKey("user", equalTo: PFUser.current() ?? "").includeKey("user").whereKey("event", equalTo: event ?? "").addDescendingOrder("updatedAt") as! PFQuery<Task>
    }()
    
    var subscription: Subscription<Task>? = nil
    
    var client: Client?
    
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
    
    lazy var taskButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.primaryColor.darker(by: 10)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.setTitle("Add\nTask", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.3), for: .highlighted)
        button.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
        button.apply(Stylesheet.Global.shadow)
        return button
    }()
    
    private lazy var textInputAccessoryView = TextInputAccessoryView(view: self.view)
    
    // MARK: - Initialization
    
    init(event: PlannerEvent) {
        self.event = event
        super.init(nibName: nil, bundle: nil)
        cell.dataSourceItem = event
        if event.objectId == nil {
            cell.dateLabel.text = "Date"
            cell.timeLabel.text = "Time"
            cell.lengthLabel.text = "Duration"
            taskButton.isHidden = true
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
        
        tableView.tableFooterView = UIView()
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.reuseIdentifier)
        
        
        loadTasks()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3) {
            self.saveButton.alpha = 1
            self.closeButton.alpha = 1
            self.tableView.alpha = 1
            self.taskButton.alpha = 1
        }
        
        subscription = Client.shared.subscribe(tasksQuery)
        subscription?.handle(Event.created) { query, task in
            DispatchQueue.main.sync {
                self.event?.tasks?.insert(task, at: 0)
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            }
        }
        subscription?.handle(Event.updated) { query, task in
            DispatchQueue.main.sync {
                if let index = self.event?.tasks?.index(where: { return $0.objectId == task.objectId }) {
                    self.event?.tasks?[index] = task
                    self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                }
            }
        }
        subscription?.handle(Event.deleted) { query, task in
            DispatchQueue.main.sync {
                if let index = self.event?.tasks?.index(where: { return $0.objectId == task.objectId }) {
                    self.event?.tasks?.remove(at: index)
                    self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                }
            }
        }
    }
    
    // MARK: - Setup
    
    func setupView() {
        
        view.backgroundColor = .white
        view.addSubview(cell)
        view.addSubview(closeButton)
        view.addSubview(tableView)
        view.addSubview(saveButton)
        view.addSubview(taskButton)
        
        cell.anchor(view.layoutMarginsGuide.topAnchor, left: view.layoutMarginsGuide.leftAnchor, right: view.layoutMarginsGuide.rightAnchor, heightConstant: 200)
        
        closeButton.anchor(view.layoutMarginsGuide.topAnchor, left: nil, bottom: nil, right: view.layoutMarginsGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 40, heightConstant: 40)
        
        tableView.anchor(cell.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        saveButton.anchor(nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 46, rightConstant: 16, widthConstant: 75, heightConstant: 75)
        saveButton.layer.cornerRadius = 75 / 2
        
        taskButton.anchor(nil, left: nil, bottom: saveButton.topAnchor, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 16, rightConstant: 16, widthConstant: 75, heightConstant: 75)
        taskButton.layer.cornerRadius = 75 / 2
        
        saveButton.alpha = 0
        closeButton.alpha = 0
        tableView.alpha = 0
        taskButton.alpha = 0
    }
    
    
    // MARK: - Networking
    
    
    
    // MARK: - User Actions
    
    @objc
    func didTapClose() {
        
        UIView.animate(withDuration: 0.3) {
            self.saveButton.alpha = 0
            self.closeButton.alpha = 0
            self.tableView.alpha = 0
            self.taskButton.alpha = 0
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
            .setLocale(Calendar.current.locale!)
            .setMinuteInterval(5)
            .setDoneButton(title: "Save", color: .primaryColor, action: { popover, date in
                // Update
                self.event?.endDate = date
                self.cell.timeLabel.text = date.string(dateStyle: .none, timeStyle: .short)
            })
            .setCancelButton(title: "Cancel", color: .darkGray, action: nil)
            .appear(originView: cell.timeLabel, baseViewController: self)
    }
    
    @objc
    func showDatePicker() {
        
        DatePickerPopover(title: "Day")
            .setDateMode(.date)
            .setLocale(Calendar.current.locale!)
            .setSelectedDate(Date())
            .setDoneButton(title: "Save", color: .primaryColor, action: { popover, date in
                // Update
                self.event?.startDate = date
                self.event?.endDate = date.addSec(60*60)
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
                let startDate = self?.event?.startDate ?? Date()
                self?.event?.startDate = startDate
                let endDate = Date(timeInterval: timeInterval, since: startDate)
                self?.event?.endDate = endDate
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
            })
            .setCancelButton(title: "Cancel", color: .darkGray, action: nil)
            .appear(originView: cell.lengthLabel, baseViewController: self)
    }

    @objc func didTapAdd() {
        showNewTaskDialog()
    }
    
    private func loadTasks() {
        
        tasksQuery.findObjectsInBackground(block: { (objects, error) in
            guard let objects = objects else {
                self.handleError(error?.localizedDescription)
                return
            }
            self.event?.tasks = objects
            self.tableView.reloadData()
        })
        
    }
    
}

extension EventDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UITableViewHeaderFooterView()
        header.contentView.backgroundColor = .primaryColor
        header.textLabel?.textColor = .white
        header.textLabel?.text = "Event Tasks"
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        return header
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return event?.tasks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.reuseIdentifier, for: indexPath) as! TaskTableViewCell
        
        let task = event?.tasks?[indexPath.row]
        cell.textLabel?.text = task?.title
        
        if task?.isDone?.boolValue == true {
            cell.accessoryType = .checkmark
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: task?.title ?? "")
            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            cell.textLabel?.attributedText = attributeString
        } else {
            cell.accessoryType = .none
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: task?.title ?? "")
            attributeString.removeAttribute(NSAttributedStringKey.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
            cell.textLabel?.attributedText = attributeString
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        event?.tasks?[indexPath.row].isDone = !(event?.tasks?[indexPath.row].isDone?.boolValue ?? false) as NSNumber
        event?.tasks?[indexPath.row].saveInBackground()
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.event?.tasks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, _) in
            self.event?.tasks?[indexPath.row].deleteInBackground()
        }
        return [deleteAction]
    }
    
    private func showNewTaskDialog() {
        let alertController = UIAlertController(title: "New Task", message: "Please type the task to be completed", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Done", style: .default) { (_) in
            guard let text = alertController.textFields?.first?.text else {
                self.showEmptyTaskAlert()
                return
            }
            let newTask = Task()
            newTask.user = PFUser.current()
            newTask.title = text
            newTask.date = Date()
            newTask.event = self.event
            newTask.saveInBackground(block: { (success, error) in
                guard success else {
                    self.handleError(error?.localizedDescription)
                    return
                }
            })
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Task"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func showEmptyTaskAlert() {
        let alertController = UIAlertController(title: "Error", message: "The task cannot be empty", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "Done", style: .cancel) { (_) in }
        
        alertController.addAction(doneAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}





