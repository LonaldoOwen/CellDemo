//
//  FindFriendHelpListVC.swift
//  CellDemo
//
//  Created by owen on 17/11/14.
//  Copyright © 2017年 libowen. All rights reserved.
//
///
///
///
///

import UIKit

class FindFriendHelpListVC: UITableViewController, SectionHeaderViewDelegate {
    
    // section header view identifier
    let kFriendsCellIdentifier = "FriendsCell"
    let kSectionHeaderIdentifier = "FFHLSectionHeader"
    
    // 定义数组存储model数据
    var lists: [FriendsList]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //
        self.title = "FindFriendHelpVC"
        tableView.sectionHeaderHeight = 60
        
        // 注册cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kFriendsCellIdentifier)
        // 注册section header nib
        let sectionHeaderNib = UINib(nibName: "SectionHeaderView", bundle: nil)
        tableView.register(sectionHeaderNib, forHeaderFooterViewReuseIdentifier: kSectionHeaderIdentifier)
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: kFriendsCellIdentifier, for: indexPath)
        
        // Configure the cell...
        let frend = self.lists[indexPath.section].friends?[indexPath.row]
        cell.textLabel?.text = frend?.name
        if indexPath.section == 0 {
            cell.imageView?.image = nil
        } else {
            cell.imageView?.image = UIImage(named: "国内游@2x")
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader: CustomHeaderOfFind = tableView.dequeueReusableHeaderFooterView(withIdentifier: kSectionHeaderIdentifier) as! CustomHeaderOfFind
        sectionHeader.delegate = self
        
        /// 问题：
        /// [CellDemo.CustomHeaderOfFind handleLongPressWithRecognizier:]: unrecognized selector sent to instance 0x7fca59d4fd60'???
        /// 原因：target设置错了
        /// 解决：将sectionHeader改为self
//        let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
//        longPressGesture.minimumPressDuration = 0
//        sectionHeader.addGestureRecognizer(longPressGesture)
        
        let item = self.lists[section]
        sectionHeader.disclosureButton.setImage(UIImage.init(named: item.imageString), for: .normal)
        sectionHeader.titleLabel.text = item.relations
        sectionHeader.section = section
        return sectionHeader
    }
 
    
    // MARK: Table view delegate
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        print("willDisplayHeaderView")
        //let sectionHeader: CustomHeaderOfFind = view as! CustomHeaderOfFind
        // 验证修改默认section header颜色
        /// 修改contentView的backgroudColor时使用clear color不管用
        /// tintColor应该是在contentView的下一层
        //sectionHeader.tintColor = UIColor.clear
        //sectionHeader.contentView.backgroundColor = UIColor.orange
    }
    
    
    // MARK: SectionHeaderViewDelegate
    func sectionHeaderView(_ sectionHeaderView: CustomHeaderOfFind, sectionOpened: Int) {
        print("opened section: \(sectionOpened)")
        
        let item = self.lists[sectionOpened]
        item.isExpanded = !item.isExpanded
        sectionHeaderView.subviews[1].backgroundColor = UIColor.gray
        self.tableView.reloadSections(IndexSet.init(integer: sectionOpened), with: .none)
    }
    
    func sectionHeaderView(_ sectionHeaderView: CustomHeaderOfFind, sectionClosed: Int) {
        print("closed section: \(sectionClosed)")
    }
    
    
    // MARK: Helper
    func handleLongPress(recognizier: UIGestureRecognizer) {
        let sectionHeader: CustomHeaderOfFind = recognizier.view as! CustomHeaderOfFind
        sectionHeader.contentView.backgroundColor = UIColor.orange
        print("long press: \(String(describing: sectionHeader))")
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
