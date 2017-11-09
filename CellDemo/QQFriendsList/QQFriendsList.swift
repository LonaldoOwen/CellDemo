//
//  QQFriendsList.swift
//  CellDemo
//
//  Created by owen on 17/11/7.
//  Copyright © 2017年 libowen. All rights reserved.
//
/**
 *功能：模仿qq好友列表cell展开收起功能
 *注意：VC使用的storyboard（UITableViewController），section header和footer有默认高度值18；
 *如果不需要footer可将值设置为0；
 */

import UIKit

class QQFriendsList: UITableViewController {
    
    //
    var lists: [FriendsList]!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // 
        self.title = "QQFriendsList"
        
        // 解析数据，转化成model
        let dataArray: [[String: Any]] = Helper.readPlist(forResource: "Friends", ofType: "plist") as! [[String : Any]]
        lists = dataArray.map {
            FriendsList(
                isExpanded: $0["isExpanded"] as! Bool,
                relations: $0["relations"] as! String,
                imageString: $0["imageString"] as! String,
                friends: ($0["friends"] as! [[String: Any]]).map {
                    FriendsList.Friend(
                        id: $0["id"] as! String,
                        name: $0["name"] as! String
                    )
                }
            )
        }
        print("")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if self.lists != nil {
            return self.lists.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.lists[section].isExpanded {
            return (self.lists[section].friends?.count)!
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath)

        // Configure the cell...
        let frend = self.lists[indexPath.section].friends?[indexPath.row]
        cell.textLabel?.text = frend?.name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        /// 自定义section header view
        /// 使用的是UIView，在view上自定义content
        let headerView = SectionHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 80))
        //headerView.backgroundColor = UIColor.orange
        
        // 设置数据
        let item = self.lists[section]
        headerView.title.text = item.relations
        headerView.imageView.image = UIImage.init(named: item.imageString)
        headerView.tag = 100 + section
        
        // 处理tap action
        headerView.headerTapedHandler = {
            print("taped section: \(section)")
            /// 注意：
            /// 1、这里FriendsList要使用Class类型（reference type），这样更改item的store property时，lists就更新了
            /// 如果使用struct，不会自动更新（value type）
            /// 问题：背景为白色时，切换图片时，会有重叠效果
            /// 原因：
            /// 解决：
            let item: FriendsList = self.lists[section]
            // togging isExpanded property and imageSring
            if item.isExpanded {
                item.imageString = "more.png"
            } else {
                item.imageString = "more_unfold.png"
            }
            item.isExpanded = !item.isExpanded
            // update table view section
            tableView.reloadSections(IndexSet.init(integer: section), with: .none)
            //tableView.reloadData()
            print("isExpanded: \(item.isExpanded)")
        }
        return headerView
    }
    
    
    // MARK: - table view delegate
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 点击cell后，取消cell的选中状态
        tableView.deselectRow(at: indexPath, animated: false)
        //
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
