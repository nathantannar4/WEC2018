//
//  NewNoteViewController.swift
//  WEC2018
//
//  Created by Shayne Kelly II on 2018-01-12.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit

class NewNoteViewController: UIViewController {
    
    var newNoteView: NewNoteView!
    var contentString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Edit Note"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapSave))

        newNoteView = NewNoteView()
        self.view.addSubview(newNoteView)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy HH:mm"
        newNoteView.dateLabel.text = dateFormatter.string(from: Date())
        if (contentString != nil) {
            newNoteView.titleText.text = contentString
        }
        newNoteView.fillSuperview()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func didTapSave() {
        // ....
    }
}
