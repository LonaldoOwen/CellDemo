//
//  CustomHeaderOfFind.swift
//  CellDemo
//
//  Created by owen on 17/11/14.
//  Copyright © 2017年 libowen. All rights reserved.
//
/// 功能：自定义section header 使用xib
/// 1、基础UITableViewHeaderFooterView
/// 2、添加xib并设置UI
/// 3、创建代理协议，

import UIKit

// 定义协议，处理open和close
@objc protocol SectionHeaderViewDelegate: NSObjectProtocol {
    // 定义optional method
    @objc optional func sectionHeaderView(_ sectionHeaderView: CustomHeaderOfFind, sectionOpened: Int)
    @objc optional func sectionHeaderView(_ sectionHeaderView: CustomHeaderOfFind, sectionClosed: Int)
}

class CustomHeaderOfFind: UITableViewHeaderFooterView {
    
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var disclosureButton: UIButton!

    
    var section: Int?
    var delegate: SectionHeaderViewDelegate?
    
    
    @IBAction func toggleOpen(_ sender: Any) {
        print("tap...")
        
        if (self.delegate?.responds(to: #selector(SectionHeaderViewDelegate.sectionHeaderView(_:sectionOpened:))))! {
            self.delegate?.sectionHeaderView!(self, sectionOpened: self.section!)
        } else {
            print("not respond delegate")
        }
    }
    
    
    override func awakeFromNib() {
    super.awakeFromNib()
    
    // setup UI
    
    // add tap gesture for section header
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleOpen))
        self.addGestureRecognizer(tapGesture)
        
        let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0
        self.addGestureRecognizer(longPressGesture)
    }
    
    
    //
    func handleLongPress(recognizier: UIGestureRecognizer) {
        let sectionHeader: CustomHeaderOfFind = recognizier.view as! CustomHeaderOfFind
        sectionHeader.contentView.backgroundColor = UIColor.orange
        print("long press: \(String(describing: sectionHeader))")
        
        if recognizier.state == .began {
            print("begin")
            /// 问题：
            /// 这样直接设置没有动画效果，可以添加fade动画
            // 设置hilighted颜色
            self.subviews[1].backgroundColor = UIColor.lightGray
        } else if recognizier.state == .ended {
            print("ended")
            // 取消hilighted颜色
            self.subviews[1].backgroundColor = UIColor.white
            if (self.delegate?.responds(to: #selector(SectionHeaderViewDelegate.sectionHeaderView(_:sectionOpened:))))! {
                self.delegate?.sectionHeaderView!(self, sectionOpened: self.section!)
            } else {
                print("not respond delegate")
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
