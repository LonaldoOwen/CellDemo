//
//  ViewController.swift
//  CellDemo
//
//  Created by libowen on 2017/7/20.
//  Copyright © 2017年 libowen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    var tableView: UITableView!
    var listModels: [ListCellModel]?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView = UITableView()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.rowHeight = 100
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let views: [String: Any] = ["table": tableView, "root": view]
        let tableView_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|[table]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        view.addConstraints(tableView_H)
        let tableView_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|[table]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        view.addConstraints(tableView_V)
        
        let dataArray = Helper.readPlist(forResource: "List", ofType: "plist") as! [[String: Any]]
        listModels = dataArray.map{
            ListCellModel(
                index: $0["index"] as! String,
                title: $0["title"] as! String
            )
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (listModels?.count)!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "ListCell"
        var cell: ListCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? ListCell
        if cell == nil {
            cell = ListCell(style: .default, reuseIdentifier: identifier)
        }
        cell?.listCellModel = listModels?[indexPath.row]
        return cell!
    }

}

