//
//  CustomHeaderOfFind.swift
//  CellDemo
//
//  Created by owen on 17/11/14.
//  Copyright © 2017年 libowen. All rights reserved.
//
/// 功能：自定义section header 使用xib
/// 1、继承UITableViewHeaderFooterView
/// 2、添加xib并设置UI
/// 3、创建代理协议，用于处理open、close逻辑
/// 4、实现点击section header的hilighted效果：
///    添加long press gesture；修改自定义view的backgroundColor并添加动画；
///

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
        
        // add long press gesture for section header
        // 此时tap gesture不起作用
        let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0
        self.addGestureRecognizer(longPressGesture)
    }
    
    
    // handle long press
    func handleLongPress(recognizier: UIGestureRecognizer) {
        
        if let sectionHeader: CustomHeaderOfFind = recognizier.view as? CustomHeaderOfFind {
            print("long press: \(String(describing: sectionHeader))")
            
            if recognizier.state == .began {
                print("begin")
                
                /// 实现section header的hilighted效果
                // 设置hilighted颜色
                /// 直接修改背景色效果不好，可以添加动画美化效果
                UIView.animate(withDuration: 0.1, delay: 0.2, options: UIViewAnimationOptions.curveEaseIn, animations: {
                    self.subviews[1].backgroundColor = UIColor.lightGray
                }, completion: nil)
                
            } else if recognizier.state == .ended {
                print("ended")
                // 取消hilighted颜色
                UIView.animate(withDuration: 0.1, delay: 0.2, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.subviews[1].backgroundColor = UIColor.white
                }, completion: nil)
                
                // 调用代理方法
                if (self.delegate?.responds(to: #selector(SectionHeaderViewDelegate.sectionHeaderView(_:sectionOpened:))))! {
                    self.delegate?.sectionHeaderView!(self, sectionOpened: self.section!)
                } else {
                    print("not respond delegate")
                }
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
