//
//  Helper.swift
//  CellDemo
//
//  Created by libowen on 2017/7/20.
//  Copyright © 2017年 libowen. All rights reserved.
//

import UIKit

class Helper {
    
}

extension Helper {
    
    /// 读取plist返回数组
    public class func readPlist(forResource name: String?, ofType ext: String?) -> [Any]{
        
        let path = Bundle.main.path(forResource: name , ofType: ext)
        let fileManager = FileManager.default
        let plistData = fileManager.contents(atPath: path!)
        
        let tempArray: [[String: Any]] = try! PropertyListSerialization.propertyList(from: plistData!, options: [], format: nil) as! [[String : Any]]
        
        return tempArray
    }
    // 构造模型数组
//    var cells = [ListCellModel]()
//    cells = tempArray.map{
//        ListCellModel(
//            index: $0["index"] as! String,
//            title: $0["title"] as! String
//        )
//    }

}
