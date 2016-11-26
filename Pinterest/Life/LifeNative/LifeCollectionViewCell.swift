//
//  LifeCollectionViewCell.swift
//  finding
//
//  Created by bob song on 16/3/18.
//  Copyright © 2016年 zhangli. All rights reserved.
//

import UIKit
class CommonCollectionViewCell: UICollectionViewCell{
    var iView = UIView()
}

// 第一页Cell
class LifeCollectionViewCell:CommonCollectionViewCell{
    
    var imageViews:[UIImageView] = []
    let tLabel = UILabel()
    let contentLabel = UILabel()
    let bottomView:LifeBotttomView!
    let likeView:UIView!
    
    override init(frame: CGRect) {
//        iView = UIView(frame:CGRectMake(0, 0, frame.size.width, 50))
        likeView = UIView(frame:CGRect(x:0, y:0, width:frame.size.width, height:20))
        bottomView = Bundle.main.loadNibNamed("lifeViews", owner: nil, options: nil)!.first as! LifeBotttomView
        bottomView.frame.size.width = frame.size.width
        super.init(frame: frame)
        iView.frame = CGRect(x:0, y:0, width:frame.size.width, height:50)
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.contentView.backgroundColor = UIColor.white
        for _ in 0..<9{
            let imageView = UIImageView()
            imageViews.append(imageView)
            iView.addSubview(imageView)
        }
        self.contentView.addSubview(iView)
        
        self.contentView.addSubview(tLabel)
        self.contentView.addSubview(contentLabel)
        self.contentView.addSubview(likeView)
        
        
        self.contentView.addSubview(bottomView)
        
        initViewsInLikeView(likeImageView, image: "img_like", label: likeLabel)
        initViewsInLikeView(replyImageView, image: "img_comment", label: replyLabel)
        
        
        likeView.backgroundColor = UIColor.white
        
        bottomView.headImageView.layer.cornerRadius = bottomView.headImageView.frame.size.width / 2
        bottomView.headImageView.layer.masksToBounds = true
        
        let line = UIView(frame: CGRect(x:0, y:0, width:frame.size.width, height:1))
        line.backgroundColor = LifeConstant.mainBackgroundColor
        bottomView.addSubview(line)
        
    }
    
    let likeImageView = UIImageView()
    let likeLabel = UILabel()
    let replyImageView = UIImageView()
    let replyLabel = UILabel()
    
    func initViewsInLikeView(_ imageView:UIImageView,image:String,label:UILabel){
        
        
        imageView.image = UIImage(named: image)
        imageView.frame.size = CGSize(width: 10, height: 10)
        imageView.frame.origin.y = 5
        likeView.addSubview(imageView)
        
        label.frame.size = CGSize(width: 20, height: 10)
        label.frame.origin.y = 5
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.gray
        likeView.addSubview(label)
    }
    
    var maxY:CGFloat = 0
    var sizes:[NSDictionary]!
    var urls:[String]!
    
    func setImageViewFrameAndUrl(_ imageView:UIImageView,frame:CGRect,url:String){
        imageView.frame = frame
        imageView.setImageForURLString(str: url)
        imageView.isHidden = false
    }
    
    func setLabelFrameAndText(_ label:UILabel,frame:CGRect,text:String,font:UIFont,textColor:UIColor){
        label.numberOfLines = 0
        label.font = font
        label.text = text
        label.textColor = textColor
        label.frame = frame
    }
    
    func setPositionForImageViewAndLabel(_ imageView:UIImageView,label:UILabel,size:Int,maxX:inout CGFloat){
        if size != 0{
            imageView.isHidden = false
            label.isHidden = false
            
            imageView.frame.origin.x = maxX
            maxX += imageView.frame.size.width + 5
            
            label.frame.origin.x = maxX
            maxX += label.frame.size.width + 5
            
            label.text = String(describing: size)
        }else{
            imageView.isHidden = true
            label.isHidden = true
        }
        
    }
    
    func configLikeView(_ likeSize:Int,replySize:Int){
        var maxX:CGFloat = 5
        setPositionForImageViewAndLabel(likeImageView, label: likeLabel, size: likeSize, maxX: &maxX)
        setPositionForImageViewAndLabel(replyImageView, label: replyLabel, size: replySize, maxX: &maxX)
    }
    
    func setContentLabel(_ label:UILabel,text:String,maxY:inout CGFloat){
        
        let height =  LifeUtils.calculateHeightForContentStr(text)
        label.frame = CGRect(x: LifeConstant.margin, y: maxY + LifeConstant.margin, width: LifeConstant.innerWidth,  height: height)
        label.numberOfLines = 0
        label.attributedText = NSAttributedString(string: text, attributes: LifeConstant.contentAttributesDic)
        label.textColor = UIColor.gray
        label.textAlignment = .justified
        maxY += height + LifeConstant.margin
    }
    
    func setTitleLabel(_ label:UILabel,text:String,maxY:inout CGFloat){
        let height =  LifeUtils.calculateHeightForTitleStr(text)
        label.frame = CGRect(x: LifeConstant.margin, y: maxY + LifeConstant.margin, width: LifeConstant.innerWidth,  height: height)
        label.numberOfLines = 0
        label.attributedText = NSAttributedString(string: text, attributes: LifeConstant.titleAttributesDic)
        label.textColor = UIColor.black
        label.textAlignment = .justified
        maxY += height + LifeConstant.margin
    }
    
    
    func setData(_ model:LifeModel){
        
        
        urls = model.collectionImgArr
        
        sizes = model.sizes
        
        maxY = 0
        
        for i in 0..<urls.count {
            let imageheight = (sizes[i]["height"] as! CGFloat)/(sizes[i]["width"] as! CGFloat) * frame.size.width
            setImageViewFrameAndUrl(imageViews[i], frame: CGRect(x: 0, y: maxY, width: frame.size.width, height: imageheight), url: urls[i])
            maxY += imageheight
        }
        
        for i in urls.count..<9{
            imageViews[i].image = nil
            imageViews[i].isHidden = true
        }
        
        iView.frame.size.height = maxY
        
        tLabel.frame.size.height = 0
        if model.collectionName != "" {
            setTitleLabel(tLabel, text: model.collectionName, maxY: &maxY)
        }
        
        setContentLabel(contentLabel, text: model.content, maxY: &maxY)
        maxY += LifeConstant.margin / 2
        
        
        if model.likeSize != 0 || model.replySize != 0 {
            
            likeView.frame.origin.y = maxY
            likeView.isHidden = false
            maxY += likeView.frame.size.height
            
            configLikeView(model.likeSize, replySize: model.replySize)
            
        }else{
            likeView.isHidden = true
        }
        
        
        bottomView.frame.origin.y = maxY
        bottomView.headImageView.setImageForURLString(str: model.avatar)
        bottomView.nickLabel.text = model.userNick
        
        if model.remarks != "" {
            bottomView.sourceLabel.text = model.remarks
        }else if model.source != "" {
            bottomView.sourceLabel.text = "来源 : " + model.source
        }else{
            bottomView.sourceLabel.text = ""
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

