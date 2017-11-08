//
//  ListCell.swift
//  CellDemo
//
//  Created by libowen on 2017/7/20.
//  Copyright © 2017年 libowen. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {
    
    /// 自定义控件
    let cellName: UILabel = {
        let label = UILabel()
        //label.backgroundColor = UIColor.lightGray
        label.numberOfLines = 0
        return label
    }()
    // 定义closure
    var cellTapClosure: (() -> Void)!
    
    /// 自定义UI
    func setUp() {
        self.contentView.addSubview(cellName)
        // 约束
        cellName.translatesAutoresizingMaskIntoConstraints = false
        cellName.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
        cellName.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10).isActive = true
        cellName.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
    }
    
    /// 复写初始化方法
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //
        setUp()
        self.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //
        setUp()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        print("ListCell: setSelected: \(selected)")
        // 调用closure
        cellTapClosure()

        // Configure the view for the selected state
    }
    
    /// 定义model属性
    var listCellModel: ListCellModel? {
        didSet {
            self.cellName.text = listCellModel?.title
        }
    }
    
    ///

}
