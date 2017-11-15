//
//  ViewController.swift
//  CellDemo
//
//  Created by libowen on 2017/7/20.
//  Copyright © 2017年 libowen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView!
    var listModels: [ListCellModel]?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "CellList"
        
        tableView = UITableView()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
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
    
    /// MARK: - table view data source
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
        // 验证closure的使用
        cell?.cellTapClosure = {
            print("Tap cell index: \(indexPath.row)")
        }
        cell?.listCellModel = listModels?[indexPath.row]
        return cell!
    }
    
    /// MARK: - table view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        if indexPath.row == 4 {
            let showXibCellVC: ShowXibCellViewController = ShowXibCellViewController()
            self.show(showXibCellVC, sender: nil)
        } else if indexPath.row == 5 {
            let friendsVC: QQFriendsList = self.storyboard?.instantiateViewController(withIdentifier: "QQFriendListVC") as! QQFriendsList
            self.show(friendsVC, sender: nil)
        } else if indexPath.row == 6 {
            let findVC: FindFriendHelpListVC = FindFriendHelpListVC(style: .plain)
            self.navigationController?.show(findVC, sender: nil)
        }
    }

}

