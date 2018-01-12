//
//  Note.swift
//  WEC2018
//
//  Created by Shayne Kelly II on 2018-01-12.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import Parse

class Note: PFObject {
    
    @NSManaged var content: String?
    @NSManaged var date: Date?
    @NSManaged var user: PFUser?
}

extension Note: PFSubclassing {
    
    static func parseClassName() -> String {
        return "Notes"
    }
}
