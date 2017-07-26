//
//  TempViewController.swift
//  CellDemo
//
//  Created by owen on 17/7/25.
//  Copyright © 2017年 libowen. All rights reserved.
//

import UIKit

class TempViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        ///
        // 加载nib
        let nibContents = Bundle.main.loadNibNamed("CustomItemView", owner: nil, options: nil)
        let itemView: CustomItemView = nibContents?.first as! CustomItemView
        itemView.frame = CGRect(x: 10, y: 100, width: 300, height: 100)
        view.addSubview(itemView)
        itemView.backgroundColor = UIColor.lightGray
        itemView.titleText.text = "title"
        itemView.valueText.text = "value"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
