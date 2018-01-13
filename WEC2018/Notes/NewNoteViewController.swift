//
//  NewNoteViewController.swift
//  WEC2018
//
//  Created by Shayne Kelly II on 2018-01-12.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit

class NewNoteViewController: UIViewController {
    
    let note: Note
    
    var newNoteView = NewNoteView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Note"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: self,
                                                            action: #selector(didTapSave))

        view.addSubview(newNoteView)
        newNoteView.fillSuperview()
        
        newNoteView.dateLabel.text = note.date?.string(dateStyle: .medium, timeStyle: .short)
        
        newNoteView.titleText.text = note.content
        newNoteView.titleText.onTextDidChange {
            self.note.content = $0
        }
        
    }
    
    init(for note: Note) {
        self.note = note
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func didTapSave() {
        
        note.date = Date()
        note.saveInBackground { (success, error) in
            guard success else {
                self.handleError(error?.localizedDescription)
                return
            }
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
