//
//  FriendModel.swift
//  CellDemo
//
//  Created by owen on 17/11/7.
//  Copyright © 2017年 libowen. All rights reserved.
//

import Foundation
import UIKit

class FriendsList {
    
    struct Friend {
        var id: String
        var name: String
        
    }
    
    var isExpanded: Bool
    var relations: String
    var imageString: String
    var friends: [Friend]?
    
    init(isExpanded: Bool, relations: String, imageString: String, friends: [Friend]?) {
        self.isExpanded = isExpanded
        self.relations = relations
        self.imageString = imageString
        self.friends = friends
    }
}

