//
//  TodoTableViewController.swift
//  WEC2018
//
//  Created by Shayne Kelly II on 2018-01-12.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import Parse
import ParseLiveQuery

class TodoTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var tasks = [Task]()
    
    lazy var tasksQuery: PFQuery<Task> = {
        return Task.query()?.whereKey("user", equalTo: PFUser.current() ?? "").includeKey("user").addDescendingOrder("updatedAt") as! PFQuery<Task>
    }()
    
    var subscription: Subscription<Task>? = nil
    
    var client: Client?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "To-Do"
        tabBarItem = UITabBarItem(title: title, image: #imageLiteral(resourceName: "icon_todo"), tag: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapAdd() {
        showNewTaskDialog()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
        tableView.tableFooterView = UIView()
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.reuseIdentifier)
        
        loadTasks()
    }
 
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.reuseIdentifier, for: indexPath) as! TaskTableViewCell
    
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.title
        
        if task.isDone?.boolValue == true {
            cell.accessoryType = .checkmark
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: task.title ?? "")
            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            cell.textLabel?.attributedText = attributeString
        } else {
            cell.accessoryType = .none
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: task.title ?? "")
            attributeString.removeAttribute(NSAttributedStringKey.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
            cell.textLabel?.attributedText = attributeString
        }
            
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tasks[indexPath.row].isDone = !(tasks[indexPath.row].isDone?.boolValue ?? false) as NSNumber
        tasks[indexPath.row].saveInBackground()
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, _) in
            self.tasks[indexPath.row].deleteInBackground()
        }
        return [deleteAction]
    }
    
    private func loadTasks() {
        
        tasksQuery.findObjectsInBackground(block: { (objects, error) in
            guard let objects = objects else {
                self.handleError(error?.localizedDescription)
                return
            }
            self.tasks = objects
            self.tableView.reloadData()
        })
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.apply(Stylesheet.ViewController.navigationBar)
        
        subscription = Client.shared.subscribe(tasksQuery)
        subscription?.handle(Event.created) { query, task in
            DispatchQueue.main.sync {
                self.tasks.insert(task, at: 0)
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            }
        }
        subscription?.handle(Event.updated) { query, task in
            DispatchQueue.main.sync {
                if let index = self.tasks.index(where: { return $0.objectId == task.objectId }) {
                    self.tasks[index] = task
                    self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                }
            }
        }
        subscription?.handle(Event.deleted) { query, task in
            DispatchQueue.main.sync {
                if let index = self.tasks.index(where: { return $0.objectId == task.objectId }) {
                    self.tasks.remove(at: index)
                    self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                }
            }
        }
    }
}
