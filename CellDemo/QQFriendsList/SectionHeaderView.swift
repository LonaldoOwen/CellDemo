//
//  SectionHeaderView.swift
//  CellDemo
//
//  Created by owen on 17/11/7.
//  Copyright © 2017年 libowen. All rights reserved.
//

import UIKit

class SectionHeaderView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    let title: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    func setUpUI() {
        // add a title
        self.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        // 约束有点问题，没居中？？
        let views = ["title": title]
        let constraints_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[title]-|", options: .alignAllCenterX, metrics: nil, views: views)
        self.addConstraints(constraints_H)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
