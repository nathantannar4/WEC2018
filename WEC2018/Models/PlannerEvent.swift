//
//  Event.swift
//  WEC2018
//
//  Created by Nathan Tannar on 1/12/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import Parse

class PlannerEvent: PFObject {
    
    @NSManaged var title: String?
    @NSManaged var notes: String?
    @NSManaged var startDate: Date?
    @NSManaged var endDate: Date?
    @NSManaged var isAllDay: NSNumber?
    @NSManaged var tasks: [Task]?
    @NSManaged var user: PFUser?
}

extension PlannerEvent: PFSubclassing {
    
    static func parseClassName() -> String {
        return "Events"
    }
}

