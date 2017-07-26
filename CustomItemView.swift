//
//  CustomItemView.swift
//  CellDemo
//
//  Created by owen on 17/7/25.
//  Copyright © 2017年 libowen. All rights reserved.
//

import UIKit

class CustomItemView: UIView {
    
    ///
    @IBOutlet var titleText: UILabel!
    @IBOutlet var valueText: UILabel!
    
    ///
    func setUp() {
        titleText.backgroundColor = UIColor.white
        valueText.backgroundColor = UIColor.white
    }
    
    /// 
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("CustomItemView: init(frame:)")
        //setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("CustomItemView: init(coder)")
        //setUp()
    }
    
    override func awakeFromNib() {
        print("CustomItemView: awakeFromNib")
        setUp()
    }
    
    
    
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
