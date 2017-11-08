//
//  FriendModel.swift
//  CellDemo
//
//  Created by owen on 17/11/7.
//  Copyright © 2017年 libowen. All rights reserved.
//

import Foundation

struct FriendsList {
    
    struct Friend {
        var id: String
        var name: String
        
    }
    
    var isExpanded: Bool
    var relations: String
    var friends: [Friend]?
    
    init(isExpanded: Bool, relations: String, friends: [Friend]?) {
        self.isExpanded = isExpanded
        self.relations = relations
        self.friends = friends
    }
}

