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
    @NSManaged var isDone: NSNumber?
    @NSManaged var user: PFUser?
    
}

extension Task: PFSubclassing {
    
    static func parseClassName() -> String {
        return "Tasks"
    }
}
