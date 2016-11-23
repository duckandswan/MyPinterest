//
//  AskBtnCell.swift
//  finding
//
//  Created by zhoumin on 16/5/7.
//  Copyright © 2016年 zhangli. All rights reserved.
//

import UIKit

class AnswerBtnCell: UITableViewCell {

    var answerBtn:MyIndexPathButton!
    
    var line:UIView!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: UITableViewCellStyle.default, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        
        
        answerBtn = MyIndexPathButton.init(type: .system)
        answerBtn.titleLabel!.font = UIFont.systemFont(ofSize: 15)
        answerBtn.setTitleColor(UIColor.init(rgb: 0x47adf4), forState: .Normal)
        answerBtn.setTitle("+ 我来回答", for: UIControlState())
        answerBtn.frame = CGRect(x: 0, y: 0, width: Width, height: 44)
        self.addSubview(answerBtn)
        
        line = UIView.init(frame: CGRect(x: 0, y: 43.5, width: Width, height: 0.5))
        line.backgroundColor = UIColor.init(rgb: 0xdedde3)
        self.addSubview(line)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
