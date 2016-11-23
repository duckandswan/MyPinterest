//
//  AnswerCell.swift
//  finding
//
//  Created by zhoumin on 16/5/7.
//  Copyright © 2016年 zhangli. All rights reserved.
//

import UIKit

class AnswerCell: UITableViewCell {

    var contentLabel:UILabel!
    var userNickName:UILabel!
    var timeLabel:UILabel!
    var favBtn:MyIndexPathButton!
    var likeCountLabel:UILabel!

    var line:UIView!

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: UITableViewCellStyle.default, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white

        
        contentLabel = UILabel.init(frame: CGRect(x: 12, y: 10, width: Width - 24, height: 21))
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.textColor = UIColor.init(rgb: 0x333333)
        self.addSubview(contentLabel)
        
        
        userNickName = UILabel.init(frame: CGRect(x: 12, y: contentLabel.frame.maxY + 10, width: 0, height: 21))
        userNickName.font = UIFont.systemFont(ofSize: 12)
        userNickName.textColor = UIColor.init(rgb: 0x8e8e8e)
        self.addSubview(userNickName)
        
        timeLabel = UILabel.init(frame: CGRect(x: userNickName.frame.maxX + 6, y: userNickName.frame.origin.y, width: 100, height: 21))
        timeLabel.font = UIFont.systemFont(ofSize: 10)
        timeLabel.textColor = UIColor.init(rgb: 0xb9b9b9)
        self.addSubview(timeLabel)
        
        favBtn = MyIndexPathButton.init(type: .custom)
        favBtn.setImage(UIImage.init(named: "btn_zan_gray"), for: UIControlState())
        favBtn.frame = CGRect(x: Width - 60, y: self.height - 10, width: 30, height: 30)
        self.addSubview(favBtn)
        
        
        likeCountLabel = UILabel.init(frame: CGRect(x: Width - 12, y: userNickName.frame.origin.y+1, width: 0, height: 21))
        likeCountLabel.font = UIFont.systemFont(ofSize: 12)
        likeCountLabel.textColor = UIColor.init(rgb: 0xe85332)
        likeCountLabel.isHidden = true
        self.addSubview(likeCountLabel)
        
        line = UIView.init(frame: CGRect(x: 0, y: self.height - 0.5, width: Width, height: 0.5))
        line.backgroundColor = UIColor.init(rgb: 0xdedde3)
        self.addSubview(line)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func favBtnClick(){
        
    }
    
    func setData(_ answerModel:AnswerModel,questionModel:QuestionModel) {
        
        contentLabel.text = answerModel.content
        let size = contentLabel.text?.textSizeWithFont(contentLabel.font, constrainedToSize: CGSize(width: Width-24, height: 1000))
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.numberOfLines = 0
        contentLabel.frame = CGRect(x: 12, y: 10, width: Width-24, height: (size?.height)!)
        
        
        userNickName.text = answerModel.userNick

        timeLabel.text = answerModel.createTime

        var canClick:Bool = true
        if questionModel.isClick == 0{
            canClick = true
        }else{
            canClick = false
        }
        setLikeCount(answerModel.clickCount,isClick: answerModel.isClick,userInteractionEnabled:canClick)
        
    }

    
    func setLikeCount(_ likeCount:NSNumber,isClick:NSNumber,userInteractionEnabled:Bool) {
        
        likeCountLabel.text = String(likeCount)
        let size = likeCountLabel.text?.textSizeWithFont(likeCountLabel.font, constrainedToSize: CGSize(width: 100, height: 21))
        

        let nickSize = userNickName.text?.textSizeWithFont(userNickName.font, constrainedToSize: CGSize(width: Width - 12*2 - 30 - (size?.width)! - 112, height: 21))
        userNickName.frame = CGRect(x: 12, y: (contentLabel.frame).maxY + 10, width: (nickSize?.width)!, height: 21)
        
        timeLabel.frame = CGRect(x: userNickName.frame.maxX + 6, y: userNickName.frame.origin.y + 1, width: 100, height: 21)
        favBtn.frame = CGRect(x: Width - 12 - 30 - (size?.width)!, y: timeLabel.frame.origin.y - 5, width: 30, height: 30)
        likeCountLabel.frame = CGRect(x: Width - 12 - (size?.width)!, y: userNickName.frame.origin.y, width: (size?.width)!, height: 21)

        line.frame = CGRect(x: 0, y: (userNickName.frame).maxY + 10, width: Width, height: 0.5)

        favBtn.isUserInteractionEnabled = userInteractionEnabled

        //自己是否对某个回答点赞
        if isClick == 0 {
            favBtn.setImage(UIImage.init(named: "btn_zan_gray"), for: UIControlState())
            likeCountLabel.isHidden = true
            

        }else{
            
            favBtn.setImage(UIImage.init(named: "btn_zan_red"), for: UIControlState())
            likeCountLabel.isHidden = false
        }
    }
}
