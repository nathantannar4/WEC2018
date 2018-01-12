//
//  Note.swift
//  WEC2018
//
//  Created by Shayne Kelly II on 2018-01-12.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit

class Note {
    // MARK: Properties
    var content: String
    var date: Date
    
    // MARK: Initialisation
    init(content: String, date: Date) {
        self.content = content
        self.date = date
    }
}
