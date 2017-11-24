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
///    indicator image：展开section时设置button的seleted状态的image为展开图片
///    添加long press gesture；修改自定义view的backgroundColor并添加动画；
///    根据disclosureButton.isSelected状态调用代理方法
///
///

import UIKit

// 定义协议，处理open和close
@objc protocol SectionHeaderViewDelegate: NSObjectProtocol {
    // 定义optional method
    @objc optional func sectionHeaderView(_ sectionHeaderView: CustomHeaderOfFind, sectionOpened: Int)
    @objc optional func sectionHeaderView(_ sectionHeaderView: CustomHeaderOfFind, sectionClosed: Int)
}

class CustomHeaderOfFind: UITableViewHeaderFooterView {
    
    
    @IBOutlet weak var xibBackgroundView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var disclosureButton: UIButton!

    
    var section: Int?
    var isSelected: Bool!
    var isOpened: Bool!
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
        print("#awakeFromNib")
        print("disclosureButton.isSelected: \(disclosureButton.isSelected)")
        
        // setup UI
        xibBackgroundView.backgroundColor = UIColor.clear
        // 设置disclosureButton选中情况下的image为展开图像
        disclosureButton.setImage(UIImage(named: "carat-open.png"), for: .selected)
    
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
        // 切换disclosureButton的选中状态
        //disclosureButton.isSelected = !disclosureButton.isSelected
        print("#handleLongPress, disclosureButton.isSelected: \(disclosureButton.isSelected)")
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        
        if let sectionHeader: CustomHeaderOfFind = recognizier.view as? CustomHeaderOfFind {
            print("long press, sectionHeader.isSelected: \(sectionHeader.isSelected)")
            print("long press, sectionHeader.isOpened: \(sectionHeader.isOpened)")
            
            if recognizier.state == .began {
                print(".begin")
                
                /// 实现section header的hilighted效果
                // 设置hilighted颜色
                /// 直接修改背景色效果不好，可以添加动画美化效果
                self.backgroundView = backgroundView
                UIView.animate(withDuration: 0.1, delay: 0.2, options: UIViewAnimationOptions.curveEaseIn, animations: {
                    // 修改自定义xib的背景view的背景色
                    //self.subviews[1].backgroundColor = UIColor.lightGray
                    let customBackgroundView = self.subviews[1]
                    customBackgroundView.backgroundColor = UIColor.lightGray
                    customBackgroundView.alpha = 0.6
                
//                    self.backgroundView?.alpha = 0.6
//                    self.backgroundView?.backgroundColor = UIColor.lightGray
                    
                }, completion: nil)
                
            } else if recognizier.state == .ended {
                print(".ended")
                // 切换disclosureButton的选中状态
                disclosureButton.isSelected = !disclosureButton.isSelected
                print(".ended,disclosureButton.isSelected:\(disclosureButton.isSelected)")
                // 取消hilighted颜色
                UIView.animate(withDuration: 0.1, delay: 0.2, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    //
                    //self.subviews[1].backgroundColor = UIColor.white
                    let customBackgroundView = self.subviews[1]
                    customBackgroundView.backgroundColor = UIColor.white
                    customBackgroundView.alpha = 1.0
                    
//                    self.backgroundView?.alpha = 0.0
//                    self.backgroundView?.backgroundColor = UIColor.white
                    
                }, completion: { (complete) in
                    if complete {
                        //self.backgroundView = nil
                    }
                })
                
                //
                if !sectionHeader.isOpened {
                    // 调用代理方法：展开section
                    print("Call sectionOpened")
                    if (self.delegate?.responds(to: #selector(SectionHeaderViewDelegate.sectionHeaderView(_:sectionOpened:))))! {
                        self.delegate?.sectionHeaderView!(self, sectionOpened: self.section!)
                    } else {
                        print("not respond delegate")
                    }
                } else {
                    // 调用代理方法：收起section
                    print("call sectionClosed")
                    if (self.delegate?.responds(to: #selector(SectionHeaderViewDelegate.sectionHeaderView(_:sectionClosed:))))!{
                        self.delegate?.sectionHeaderView!(self, sectionClosed: self.section!)
                    } else {
                        print("not respond delegate")
                    }
                }
                
            } else if recognizier.state == .changed {
                print(".changed")
                // 取消gesture
                recognizier.isEnabled = false
                self.resignFirstResponder()
            } else if recognizier.state == .cancelled {
                print(".cancelled")
                recognizier.isEnabled = true
                
                // 展示fade动画
                // 取消hilighted颜色
                UIView.animate(withDuration: 0.1, delay: 0.2, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    //
                    //self.subviews[1].backgroundColor = UIColor.white
                    let customBackgroundView = self.subviews[1]
                    customBackgroundView.backgroundColor = UIColor.white
                    customBackgroundView.alpha = 1.0
                    
                    //                    self.backgroundView?.alpha = 0.0
                    //                    self.backgroundView?.backgroundColor = UIColor.white
                    
                }, completion: { (complete) in
                    if complete {
                        //self.backgroundView = nil
                    }
                })
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
