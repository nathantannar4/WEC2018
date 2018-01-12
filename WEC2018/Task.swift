//
//  Task.swift
//  WEC2018
//
//  Created by Shayne Kelly II on 2018-01-12.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit

class Task {
    // MARK: Properties
    var task: String
    var isDone: Bool
    
    // MARK: Initialisation
    init(task: String) {
        self.task = task
        self.isDone = false
    }
}
