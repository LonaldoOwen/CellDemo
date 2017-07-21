//
//  ShowXibCellViewController.swift
//  CellDemo
//
//  Created by libowen on 2017/7/20.
//  Copyright © 2017年 libowen. All rights reserved.
//

import UIKit

class ShowXibCellViewController: UIViewController, UITableViewDataSource {
    
    //
    let identifier = "XibCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.lightGray
        
        let tableView = UITableView()
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        
        let views = ["table": tableView]
        let table_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|[table]|", options: [], metrics: nil, views: views)
        let table_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|[table]|", options: [], metrics: nil, views: views)
        view.addConstraints(table_V)
        view.addConstraints(table_H)
        
        // 注册cell
        tableView.register(UINib(nibName: "CustomCellWithXib", bundle: nil), forCellReuseIdentifier: identifier)
        tableView.rowHeight = 100
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// MARK: table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 复用cell
        let cell: CustomCellWithXib = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CustomCellWithXib
        cell.title.text = "自定义cell从Xib：我是title，我是title，我是title"
        cell.avator.image = UIImage.init(named: "fcyHLwlg_bigger.jpg")
        return cell
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
