//
//  NoteTableViewController.swift
//  WEC2018
//
//  Created by Shayne Kelly II on 2018-01-12.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import Parse
import ParseLiveQuery

class NoteTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var notes = [Note]()
    
    lazy var notesQuery: PFQuery<Note> = {
        return Note.query()?.whereKey("user", equalTo: PFUser.current() ?? "").includeKey("user").addDescendingOrder("updatedAt") as! PFQuery<Note>
    }()
    
    var subscription: Subscription<Note>? = nil
    
    var client: Client?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Notes"
        tabBarItem = UITabBarItem(title: title, image: #imageLiteral(resourceName: "icon_note"), tag: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(didTapLogout))
        navigationItem.backBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
        

        tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: NoteTableViewCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
        
        loadNotes()
    }
    
    private func loadNotes() {
        
        notesQuery.findObjectsInBackground(block: { (objects, error) in
            guard let objects = objects else {
                self.handleError(error?.localizedDescription)
                return
            }
            self.notes = objects
            self.tableView.reloadData()
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.apply(Stylesheet.ViewController.navigationBar)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        subscription = Client.shared.subscribe(notesQuery)
        subscription?.handle(Event.created) { query, note in
            DispatchQueue.main.sync {
                self.notes.insert(note, at: 0)
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            }
        }
        subscription?.handle(Event.updated) { query, note in
            DispatchQueue.main.sync {
                if let index = self.notes.index(where: { return $0.objectId == note.objectId }) {
                    self.notes[index] = note
                    self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                }
            }
        }
        subscription?.handle(Event.deleted) { query, note in
            DispatchQueue.main.sync {
                if let index = self.notes.index(where: { return $0.objectId == note.objectId }) {
                    self.notes.remove(at: index)
                    self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                }
            }
        }
    }
    
    @objc
    func didTapAdd() {
        
        let newNote = Note()
        newNote.user = PFUser.current()
        newNote.date = Date()
        let newNoteViewController = NewNoteViewController(for: newNote)
        navigationController?.pushViewController(newNoteViewController, animated: true)
    }
    
    @objc
    func didTapLogout() {
        
        PFUser.logOutInBackground { (error) in
            guard error == nil else {
                self.handleError(error?.localizedDescription)
                return
            }
            Router.navigateTo(.welcome, animated: true)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.reuseIdentifier, for: indexPath) as! NoteTableViewCell
        
        let note = notes[indexPath.row]
        cell.textLabel?.text = note.content
        cell.detailTextLabel?.text = note.date?.timeElapsedDescription()

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let newNoteViewController = NewNoteViewController(for: notes[indexPath.row])
        navigationController?.pushViewController(newNoteViewController, animated: true)

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, _) in
            self.notes[indexPath.row].deleteInBackground()
        }
        return [deleteAction]
    }

}
