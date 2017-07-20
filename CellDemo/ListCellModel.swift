//
//  ListCellModel.swift
//  CellDemo
//
//  Created by libowen on 2017/7/20.
//  Copyright © 2017年 libowen. All rights reserved.
//

import UIKit

struct ListCellModel {
    
    let index: String
    let title: String
    
    init(index: String, title: String) {
        self.index = index
        self.title = title
    }
}
