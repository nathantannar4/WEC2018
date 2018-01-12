//
//  TodoTableViewController.swift
//  WEC2018
//
//  Created by Shayne Kelly II on 2018-01-12.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit

class TodoTableViewController: UITableViewController {
    
    //MARK: Properties
    var tasks = [Task]()
    
    //MARK: Private functions
    private func loadTasks() {
        tasks = [Task(task: "Do this shit"),
                 Task(task: "Lit to-do item"),
                 Task(task: "This sucks but I have to do it")]
    }
    
    @objc func didTapAdd() {
        showNewTaskDialog()
    }
    
    private func showNewTaskDialog() {
        let alertController = UIAlertController(title: "New Task", message: "Please type the task to be completed", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Done", style: .default) { (_) in
            let newTask = alertController.textFields?[0].text
            if (!(newTask?.isEmpty)!) {
                self.tasks.append(Task(task: newTask!))
                self.tableView.reloadData()
            } else {
                self.showEmptyTaskAlert()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = ""
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
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
        
        loadTasks()
        
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.reuseIdentifier)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        self.title = "To-do List"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.reuseIdentifier, for: indexPath) as! TaskTableViewCell
    
        let task = tasks[indexPath.row]
        cell.contentLabel.text = task.task
        
        if (task.isDone) {
            cell.accessoryType = .checkmark
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: cell.contentLabel.text!)
            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            cell.contentLabel.attributedText = attributeString
        } else {
            cell.accessoryType = .none
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: cell.contentLabel.text!)
            attributeString.removeAttribute(NSAttributedStringKey.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
            cell.contentLabel.attributedText = attributeString
        }
            
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tasks[indexPath.row].isDone = !tasks[indexPath.row].isDone
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count;
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            
            self.tasks.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
