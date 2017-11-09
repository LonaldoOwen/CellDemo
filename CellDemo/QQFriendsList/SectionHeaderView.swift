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
        label.backgroundColor = UIColor.lightGray
        label.numberOfLines = 1
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    // define a closure handle tap
    var headerTapedHandler: (() -> Void)!
    
    func setUpUI() {
        // add a title
        self.addSubview(title)
        self.addSubview(imageView)
        
        // add constraints
        title.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        /// 约束有点问题，没居中？？
        /// 如何使用VFl设置label在view上居中？？？
        let views = ["superview": self, "title": title, "image": imageView]
        let VFL_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[image]-10-[title]-(>=10)-|", options: [], metrics: nil, views: views)
        self.addConstraints(VFL_H)
        title.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
//        let VFL_V = NSLayoutConstraint.constraints(withVisualFormat: "V:[superview][title(==21)]", options: .alignAllCenterY, metrics: nil, views: views)
//        self.addConstraints(VFL_V)
        
        /// 可行
//        title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50).isActive = true
//        title.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: 10).isActive = true
//        title.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        // add gesture recognizer
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapAction))
        self.addGestureRecognizer(tapRecognizer)
    }
    
    func handleTapAction() {
        // 调用closure
        headerTapedHandler()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
