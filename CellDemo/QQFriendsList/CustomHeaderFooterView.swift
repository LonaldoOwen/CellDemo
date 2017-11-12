//
//  CustomHeaderFooterView.swift
//  CellDemo
//
//  Created by owen on 17/11/9.
//  Copyright © 2017年 libowen. All rights reserved.
//
/// UITableViewHeaderFooterView
/// 包含contentView、textLabel、detaiTextLabel(only grouped supported)属性；
/// 如果这些属性满足需要，可以不用创建子类和自定义元素；
/// 如果需要自定义元素，创建子类，并可以通过给contentView添加subviews来实现
///
/**
 *功能：自定义UITableViewHeaderFooterView
 *1、
 *2、
 */

import UIKit

class CustomHeaderFooterView: UITableViewHeaderFooterView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    /// customs properties
    
    // define a title 
    var title: UILabel = {
        var title = UILabel()
        title.backgroundColor = UIColor.white
        return title
    }()
    
    // define a indicator imageView
    var indicatorImage: UIImageView = {
        var imageView = UIImageView()
        return imageView
    }()
    
    // define a closure to handle header taped
    var headerTapedHandler: (() -> Void)!
    
    /// setup UI
    func setupUI() {
        
        // 
        self.contentView.addSubview(indicatorImage)
        self.contentView.addSubview(title)
        
        // add constraints
        /// 问题：点击cection header时，报约束冲突？？？
        /// 原因：
        /// 解决：
        indicatorImage.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        //self.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let views = ["super": self.contentView, "indicator": indicatorImage, "title": title]
        let VFL_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[indicator]-10-[title]-(>=10)-|", options: .alignAllCenterY, metrics: nil, views: views)
        self.contentView.addConstraints(VFL_H)
        title.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        /// VFL_H中的options: .alignAllCenterY意思等价于下面约束
        //indicatorImage.centerYAnchor.constraint(equalTo: title.centerYAnchor).isActive = true
        
        //
//        indicatorImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16).isActive = true
//        title.leadingAnchor.constraint(equalTo: indicatorImage.trailingAnchor, constant: 10).isActive = true
//        title.trailingAnchor.constraint(lessThanOrEqualTo: self.contentView.trailingAnchor, constant: 10).isActive = true
//        indicatorImage.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
//        title.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        
        
        // add a tap gesture recognizer
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(responseToTapGestureRecognizier))
        self.addGestureRecognizer(tapRecognizer)
    }
    
    /// custom initializer
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        //
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    override func layoutSubviews() {
        super.layoutSubviews()
        //
        setupUI()
    }
    */
    
    func responseToTapGestureRecognizier(recognizier: UIGestureRecognizer) {
        // 调用closure
        headerTapedHandler()
    }
    

}
