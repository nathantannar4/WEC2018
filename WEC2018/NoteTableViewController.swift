//
//  NoteTableViewController.swift
//  WEC2018
//
//  Created by Shayne Kelly II on 2018-01-12.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit

class NoteTableViewController: UITableViewController {
    
    //MARK: Properties
    var notes = [Note]()
    
    //MARK: Private functions
    private func loadNotes() {
        notes = [Note(content: "Yooo", date: Date()),
                 Note(content: "Yooooooo", date: Date()),
                 Note(content: "Yooo bruh this is a really extremely long note. It's so fucking long I can't even handle it bruh", date: Date())]
    }
    
    @objc func didTapAdd() {
        editNote(content: nil)
    }
    
    private func editNote(content: String?) {
        let newNoteViewController = NewNoteViewController()
        newNoteViewController.contentString = content
        self.navigationController?.pushViewController(newNoteViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
        loadNotes()

        tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: NoteTableViewCell.reuseIdentifier)
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
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        self.title = "Notes"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.reuseIdentifier, for: indexPath) as! NoteTableViewCell
        
        let note = notes[indexPath.row]
        cell.contentLabel.text = note.content
        cell.dateLabel.text = note.date.timeElapsedDescription()

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        editNote(content: notes[indexPath.row].content)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notes.count;
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
