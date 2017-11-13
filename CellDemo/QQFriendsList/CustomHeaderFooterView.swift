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
/// add coverView用作点击时选择效果
/// add seperator view
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
    
    // define a mask view
    var coverView: UIView = {
        var cover = UIView()
        cover.backgroundColor = UIColor.lightGray
        cover.alpha = 0.5
        return cover
    }()
    
    // define a seperator view
    let seperator: UIView = {
        let seperator = UIView()
        seperator.backgroundColor = UIColor.gray
        return seperator
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
        
        // setup cover view
        /// 使用frame时，不显示？？？
        ///
        //coverView.frame = self.frame
        //coverView.frame = CGRect(x: 0.0, y: 0.0, width: self.bounds.size.width, height: self.bounds.size.height)
//        self.contentView.addSubview(coverView)
//        coverView.translatesAutoresizingMaskIntoConstraints = false
//        coverView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        coverView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        coverView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
//        coverView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
//        coverView.isHidden = true
        
        // add seperator view
        self.addSubview(seperator)
        seperator.translatesAutoresizingMaskIntoConstraints = false
        seperator.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        seperator.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        seperator.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
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
        print("coverView.frame: \(coverView.frame)")
    }
    

}
