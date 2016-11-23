//
//  RewardCell.swift
//  finding
//
//  Created by zhoumin on 16/5/4.
//  Copyright © 2016年 zhangli. All rights reserved.
//

import UIKit

class RewardCell: UITableViewCell {

    var headImage:RewardHeadImageView!
    var userNickName:UILabel!
    var timeLabel:UILabel!
    var contentLabel:UILabel!
    var scoreLabel:UILabel!
    var line:UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: UITableViewCellStyle.default, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white

        
        headImage = RewardHeadImageView.init(frame: CGRect(x: 10, y: 10, width: 38, height: 38))
        headImage.layer.cornerRadius = headImage.frame.size.width * 0.5
        headImage.layer.masksToBounds = true
        self.addSubview(headImage)
        
        userNickName = UILabel.init(frame: CGRect(x: (headImage.frame).maxX + 10, y: 12, width: Width - (headImage.frame).maxX - 10, height: 21))
        userNickName.font = UIFont.systemFont(ofSize: 12)
        userNickName.textColor = UIColor.init(rgb: 0x8e8e8e)
        self.addSubview(userNickName)
        
        scoreLabel = UILabel.init(frame: CGRect(x: Width - 110, y: userNickName.frame.origin.y, width: 100, height: 21))
        scoreLabel.font = UIFont.systemFont(ofSize: 12)
        scoreLabel.textColor = UIColor.init(rgb: 0xe85332)
        self.addSubview(scoreLabel)
        scoreLabel.isHidden = true

        
        timeLabel = UILabel.init(frame: CGRect(x: userNickName.frame.origin.x, y: (userNickName.frame).maxY + 3, width: Width - (headImage.frame).maxX - 10, height: 21))
        timeLabel.font = UIFont.systemFont(ofSize: 10)
        timeLabel.textColor = UIColor.init(rgb: 0x8e8e8e)
        self.addSubview(timeLabel)

        contentLabel = UILabel.init(frame: CGRect(x: userNickName.frame.origin.x, y: (timeLabel.frame).maxY + 8, width: Width - (headImage.frame).maxX - 10, height: 21))
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.textColor = UIColor.init(rgb: 0x333333)
        self.addSubview(contentLabel)
        
        line = UIView.init(frame: CGRect(x: 0, y: self.height - 0.5, width: Width, height: 0.5))
        line.backgroundColor = UIColor.init(rgb: 0xdedde3)
        self.addSubview(line)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ rewardModel:RewardModel) {

        headImage.setHeadImage(rewardModel.avatar, type: rewardModel.type.integerValue)
        
        scoreLabel.text = rewardModel.pointStr
        let scoreLabelSize = scoreLabel.text?.textSizeWithFont(scoreLabel.font, constrainedToSize: CGSize(width: Width - (headImage.frame).maxX - 20, height: scoreLabel.height))
        scoreLabel.frame = CGRect(x: Width - (scoreLabelSize?.width)! - 10, y: userNickName.frame.origin.y, width: (scoreLabelSize?.width)!, height: 21)
        
        userNickName.text = rewardModel.user_nick
        userNickName.frame = CGRect(x: (headImage.frame).maxX + 10, y: 12, width: Width - (headImage.frame).maxX - (scoreLabelSize?.width)! - 10, height: 21)
        if rewardModel.isBest == 1 {
            
            scoreLabel.isHidden = false
        }else{
            scoreLabel.isHidden = true
        }
        
        
        timeLabel.text = rewardModel.createTime
        
        contentLabel.text = rewardModel.content
        let size = contentLabel.text?.textSizeWithFont(contentLabel.font, constrainedToSize: CGSize(width: contentLabel.width, height: 1000))
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.numberOfLines = 0
        contentLabel.frame = CGRect(x: userNickName.frame.origin.x, y: (timeLabel.frame).maxY + 8, width: Width - (headImage.frame).maxX - 10, height: (size?.height)!)
        
        line.frame = CGRect(x: 0, y: (contentLabel.frame).maxY + 15, width: Width, height: 0.5)

    }
}
