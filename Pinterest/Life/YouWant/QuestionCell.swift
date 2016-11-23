//
//  QuestionCell.swift
//  finding
//
//  Created by zhoumin on 16/5/7.
//  Copyright © 2016年 zhangli. All rights reserved.
//

import UIKit

class QuestionCell: UITableViewCell {

    var contentLabel:UILabel!
    
    var line:UIView!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: UITableViewCellStyle.default, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        
        
        contentLabel = UILabel.init(frame: CGRect(x: 12, y: 10, width: Width - 24, height: 50))
        contentLabel.font = UIFont.systemFont(ofSize: 17)
        contentLabel.textColor = UIColor.init(rgb: 0xeb5332)
        contentLabel.textAlignment = .center

        self.addSubview(contentLabel)

        line = UIView.init(frame: CGRect(x: 0, y: self.height - 0.5, width: Width, height: 0.5))
        line.backgroundColor = UIColor.init(rgb: 0xdedde3)
        self.addSubview(line)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    
    func setData(_ questionModel:QuestionModel) {
        
        contentLabel.text = questionModel.askQuestion
        let size = contentLabel.text?.textSizeWithFont(contentLabel.font, constrainedToSize: CGSize(width: Width-24, height: 1000))
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.numberOfLines = 0
        contentLabel.frame = CGRect(x: 12, y: 10, width: Width-24, height: (size?.height)!)
        
        line.frame = CGRect(x: 0, y: (contentLabel.frame).maxY + 10, width: Width, height: 0.5)
        
    }


}
