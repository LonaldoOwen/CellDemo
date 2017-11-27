//
//  FindFriendHelpListVC.swift
//  CellDemo
//
//  Created by owen on 17/11/14.
//  Copyright © 2017年 libowen. All rights reserved.
//
/// 功能：模仿查找朋友－我－帮助页面
/// 1、TVC未使用storyboard，通过代码实例化显示
/// 2、section 和cell的数据都使用model
/// 3、应用代理模式
/// 4、
/// 问题：
/// 1、table滚动后，indicator图像变为收起状态
/// 原因：table滚动会复用cell和section，disclosureButton的默认图片是关闭的
/// 解决：disclosureButton可以控制选择中的图片，展开后disclosureButton的isSelected变为false，这时需要设置.normal状态下的图像为open
///
/// 2、section展开，table滚动后，再点击section收起时，crash
/// 原因：调用代理方法时，根据disclosureButton.isSelected判断，复用后会不准
/// 解决：修改判断条件为：!sectionHeader.isOpened；增加一个isOpened属性存储展开收起状态
///
/// 3、table滚动时，展开底部section出现cell重合和重复？？？（iOS11、iphone8模拟器出现的，iOS10真机未出现，iOS11真机出现）
/// 原因：iOS11的UITableView 默认开启了Self-Sizing功能，estimatedSectionHeaderHeight属性的值默认为UITableViewAutomaticDimension
/// 解决：
/// 方法一：非Self-Sizing方式，iOS11之前，estimatedSectionHeaderHeight设置为0，sectionHeaderHeight=60；
/// 方法二：Self-Sizing方式
/// 4、按住section header移动手指，选中效果未消失、tableView未滚动？？？
/// 原因：
/// 解决：




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
        // 非Self-Sizing
//        tableView.estimatedSectionHeaderHeight = 0
//        tableView.sectionHeaderHeight = 60
        // Self-Sizing
        tableView.estimatedSectionHeaderHeight = 60
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        
        // 设置tableFooterView（不想看到table中的空cell）
//        let tableFooter = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 80))
//        tableFooter.backgroundColor = UIColor.lightGray
//        tableView.tableFooterView = tableFooter
        //tableView.tableFooterView = UIView()
        
        // 注册cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kFriendsCellIdentifier)
        // 注册section header nib
        let sectionHeaderNib = UINib(nibName: "SectionHeaderView", bundle: nil)
        tableView.register(sectionHeaderNib, forHeaderFooterViewReuseIdentifier: kSectionHeaderIdentifier)
        
        // 解析数据，转化成model
        let dataArray: [[String: Any]] = Helper.readPlist(forResource: "Help", ofType: "plist") as! [[String : Any]]
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
//        if self.lists[section].isExpanded {
//            return (self.lists[section].friends?.count)!
//        }
//        return 0
        let item = self.lists[section]
        let numberOfFriends = item.friends?.count
        return item.isExpanded ? numberOfFriends! : 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kFriendsCellIdentifier, for: indexPath)
        
        // Configure the cell...
        let frend = self.lists[indexPath.section].friends?[indexPath.row]
        cell.textLabel?.text = frend?.name
//        if indexPath.section == 0 {
//            cell.imageView?.image = nil
//        } else {
//            cell.imageView?.image = UIImage(named: "国内游@2x")
//        }
        // add backgroundView
//        let backgroundView = UIView()
//        backgroundView.backgroundColor = UIColor.orange
//        cell.backgroundView = backgroundView
        // add accessoryType
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        print("#viewForHeaderInSection, section: \(section)")
        
        let sectionHeader: CustomHeaderOfFind = tableView.dequeueReusableHeaderFooterView(withIdentifier: kSectionHeaderIdentifier) as! CustomHeaderOfFind
        
        /// 问题：添加long press gesture时，target设置错误
        /// [CellDemo.CustomHeaderOfFind handleLongPressWithRecognizier:]: unrecognized selector sent to instance 0x7fca59d4fd60'???
        /// 原因：target设置错了
        /// 解决：将sectionHeader改为self
//        let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
//        longPressGesture.minimumPressDuration = 0
//        sectionHeader.addGestureRecognizer(longPressGesture)
        
        let item = self.lists[section]
   
        sectionHeader.titleLabel.text = item.relations
        sectionHeader.section = section
        sectionHeader.isSelected = item.isExpanded
        sectionHeader.isOpened = item.isExpanded
        
        // section复用时，如果已经展开，设置indicator的normal状态图片为open
        /// Swift3.0.2: if sectionHeader.isOpened {}报错：“Type 'Bool' is broken”
        /// 解决：强制unrap,if sectionHeader.isOpened! {}
        if sectionHeader.isOpened! {
            sectionHeader.disclosureButton.setImage(UIImage.init(named: "carat-open.png"), for: .normal)
        } else {
            sectionHeader.disclosureButton.isSelected = false   /// #解决section indicator展开、收起状态错误
            sectionHeader.disclosureButton.setImage(UIImage.init(named: "carat.png"), for: .normal)
        }
        sectionHeader.delegate = self
        
        return sectionHeader
    }
 
    
    
    // MARK: Table view delegate
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        print("#willDisplayHeaderView")
        //let sectionHeader: CustomHeaderOfFind = view as! CustomHeaderOfFind
        // 验证修改默认section header颜色
        /// 修改contentView的backgroudColor时使用clear color不管用
        /// tintColor应该是在contentView的下一层
        //sectionHeader.tintColor = UIColor.clear
        //sectionHeader.contentView.backgroundColor = UIColor.orange
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("")
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //
        print(scrollView.contentOffset)
    }
    
    
    // MARK: SectionHeaderViewDelegate
    // 展开section方法
    func sectionHeaderView(_ sectionHeaderView: CustomHeaderOfFind, sectionOpened: Int) {
        print("#Opened section: \(sectionOpened)")
        
        let item = self.lists[sectionOpened]
        // 展开
        item.isExpanded = true
        sectionHeaderView.isSelected = true
        sectionHeaderView.isOpened = true
        
        // 更新section
        // 方法一：reload sections
        //self.tableView.reloadSections(IndexSet.init(integer: sectionOpened), with: .none)
       
        // 方法二：insert rows（展开时使用此方法，不会reload section，只插入rows）
        // Create an array containing the index paths of the rows to insert:
        var indexPathsToInsert: [IndexPath] = []    // empty array
        guard let countOfRowsToInsert = item.friends?.count else { return }
        for i in 0..<countOfRowsToInsert {
            let indexPath = IndexPath(row: i, section: sectionOpened)
            indexPathsToInsert.append(indexPath)
        }
        // style the animation so that there's a smooth flow in either direction
        let insertAnimation: UITableViewRowAnimation = UITableViewRowAnimation.automatic
        // apply the updates
//        self.tableView.beginUpdates()
        self.tableView.insertRows(at: indexPathsToInsert, with: insertAnimation)
//        self.tableView.endUpdates()
        
    }
    
    // 收起section方法
    func sectionHeaderView(_ sectionHeaderView: CustomHeaderOfFind, sectionClosed: Int) {
        print("#Closed section: \(sectionClosed)")
        
        let item = self.lists[sectionClosed]
        
        // 展开
        item.isExpanded = false
        sectionHeaderView.isSelected = false
        sectionHeaderView.isOpened = false
//        if !sectionHeaderView.isOpened {
//            sectionHeaderView.disclosureButton.setImage(UIImage.init(named: "carat.png"), for: .normal)
//        }
        
        // 更新section
        // 方法一：reload section（收起时使用此方法，reload sections，恢复默认状态）
        self.tableView.reloadSections(IndexSet.init(integer: sectionClosed), with: .automatic)
        
        // 方法二：delete rows
        /*
        // Create an array containing the index paths of the rows to insert:
        var indexPathsToDelete: [IndexPath] = []
        guard let countOfRowsToInsert = item.friends?.count else { return }
        for i in 0..<countOfRowsToInsert {
            let indexPath = IndexPath(row: i, section: sectionClosed)
            indexPathsToDelete.append(indexPath)
        }
        
        // style the animation so that there's a smooth flow in either direction
        let insertAnimation: UITableViewRowAnimation = UITableViewRowAnimation.bottom
        
        // apply the updates
        //self.tableView.beginUpdates()
        self.tableView.deleteRows(at: indexPathsToDelete, with: insertAnimation)
        //self.tableView.endUpdates()
        */
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
