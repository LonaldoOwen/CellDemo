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
    
    // section header view identifier
    let kSectionHeaderIdentifier = "SectionHeader"
    
    // 定义数组存储model数据
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
        
        // 注册UITableViewHeaderFooterView
        // 使用Xib的时候使用
        //tableView.register(UINib.init(nibName: "CustomHeaderFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: kSectionHeaderIdentifier)
        // 
        tableView.register(CustomHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: kSectionHeaderIdentifier)
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
        if indexPath.section == 0 {
            cell.imageView?.image = nil
        } else {
            cell.imageView?.image = UIImage(named: "国内游@2x")
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        /// 自定义section header view, using UIView
        //return sectionHeaderUsingUIView(inSection: section)
        
        /// 自定义section header view， using UITableViewHeaderFooterView
        let sectionHeader: CustomHeaderFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: kSectionHeaderIdentifier)! as! CustomHeaderFooterView
        sectionHeader.contentView.backgroundColor = UIColor.white
        // 设置数据
        let item = self.lists[section]
        sectionHeader.title.text = item.relations
        sectionHeader.indicatorImage.image = UIImage(named: item.imageString)
        
        // 旋转图像
        /// 改变indicator image的实现方法二：旋转iamgeView
        /// 在此处未达到效果？？？
        UIView.animate(withDuration: 0.4, animations: {
            // 旋转图像（默认需要都设置为isExpanded==false）
            // 如果isExpanded==true，则顺时针旋转90度
            // 如果isExpanded==false，则取消旋转，恢复原样
            sectionHeader.indicatorImage.transform = item.isExpanded ? CGAffineTransform.init(rotationAngle: CGFloat(M_PI_2)): CGAffineTransform.identity
        })
        
        // show or hidden seperator view（步骤一）
        ///  seperator处理分两步：1、根据isExpanded是否显示，2、如果收起时，点击隐藏
        sectionHeader.seperator.isHidden = item.isExpanded
        
        // 实现handle tap closure
        sectionHeader.headerTapedHandler = {
            print("Section header: \(section) taped!")
            // 当section header收起时，点击后隐藏seperator（步骤二）
            if !item.isExpanded {
                sectionHeader.seperator.isHidden = true
            }
            // togging isExpanded property
            item.isExpanded = !item.isExpanded
            
            // show or hidden the cover view
            sectionHeader.coverView.isHidden = sectionHeader.coverView.isHidden ? false : true
            
            // update table view section
            self.tableView.reloadSections(IndexSet.init(integer: section), with: .none)
        }
 
        return sectionHeader
        
    }
    
    
    // MARK: - table view delegate
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
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
    
    
    // MARK: - Helper 
    
    /// 
    // 自定义section header view, using UIView
    func sectionHeaderUsingUIView(inSection section: Int) -> UIView {
        
        /// 使用的是UIView，在view上自定义content
        /// 注意section header的复用问题
        /// 应该使用dequeueReusableHeaderFooterView(withIdentifier:)
        let headerView = SectionHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 80))
        //headerView.backgroundColor = UIColor.orange
        headerView.backgroundColor = UIColor.white
        
        // 设置数据
        let item = self.lists[section]
        headerView.title.text = item.relations
        headerView.imageView.image = UIImage.init(named: item.imageString)
        headerView.tag = 100 + section
        
        // 隐藏或显示seperator view
        if item.isExpanded {
            headerView.seperator.backgroundColor = nil
        } else {
            headerView.seperator.backgroundColor = UIColor.gray
        }
        
        // 处理tap action closure
        headerView.headerTapedHandler = {
            print("taped section: \(section)")
            let item: FriendsList = self.lists[section]
            /// 改变图片的实现方法一：切换图片
            /// 注意：
            /// 1、这里FriendsList要使用Class类型（reference type），这样更改item的store property时，lists就更新了
            /// 如果使用struct，不会自动更新（value type）
            /// 问题：背景为白色时，切换图片时，会有重叠效果
            /// 原因：
            /// 解决：
            // togging imageSring property
            if item.isExpanded {
                item.imageString = "more.png"
            } else {
                item.imageString = "more_unfold.png"
            }
            /// 改变图片的实现方法二：旋转iamgeView
            /// 在此处未达到效果？？？（位置不对，需要移出closure）
//            UIView.animate(withDuration: 0.4, animations: {
//                // 旋转图像
//                headerView.imageView.transform = !item.isExpanded ? CGAffineTransform.init(rotationAngle: CGFloat(M_PI_2)): CGAffineTransform.identity
//            })
            
            // togging isExpanded property
            item.isExpanded = !item.isExpanded
            // update table view section
            self.tableView.reloadSections(IndexSet.init(integer: section), with: .none)
            //tableView.reloadData()
            print("isExpanded: \(item.isExpanded)")
        }
        return headerView
    }

}
