//
//  Task.swift
//  WEC2018
//
//  Created by Nathan Tannar on 1/12/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import Parse

class Task: PFObject {
    
    @NSManaged var event: PlannerEvent?
    @NSManaged var title: String?
    @NSManaged var date: Date?
    @NSManaged var completed: NSNumber?
    
}

extension Task: PFSubclassing {
    
    static func parseClassName() -> String {
        return "Task"
    }
}



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
