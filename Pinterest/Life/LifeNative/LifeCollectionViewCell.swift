//
//  LifeCollectionViewCell.swift
//  finding
//
//  Created by bob song on 16/3/18.
//  Copyright © 2016年 zhangli. All rights reserved.
//

import UIKit
// 第一页Cell
class LifeCollectionViewCell:CommonCollectionViewCell{
    
    var imageViews:[UIImageView] = []
    let tLabel = UILabel()
    let contentLabel = UILabel()
    let bottomView:LifeBotttomView!
    let likeView:UIView!
    
//    let iView:UIView!
    let tuanGou = UIImageView()

    
    let playIV = UIImageView()
    
    override init(frame: CGRect) {
//        iView = UIView(frame:CGRectMake(0, 0, frame.size.width, 50))
        likeView = UIView(frame:CGRectMake(0, 0, frame.size.width, 20))
        bottomView = NSBundle.mainBundle().loadNibNamed("lifeViews", owner: nil, options: nil)!.first as! LifeBotttomView
        bottomView.frame.size.width = frame.size.width
        super.init(frame: frame)
        iView.frame = CGRectMake(0, 0, frame.size.width, 50)
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.contentView.backgroundColor = UIColor.whiteColor()
        for _ in 0..<9{
            let imageView = UIImageView()
            imageViews.append(imageView)
            //            self.contentView.addSubview(imageView)
            iView.addSubview(imageView)
        }
        self.contentView.addSubview(iView)
        
        let image = UIImage(named:"tuan")!
        tuanGou.image = image
        let imageW:CGFloat = 35
        let imageH = imageW * image.size.height / image.size.width
        tuanGou.frame = CGRectMake(iView.frame.size.width - imageW, 0, imageW, imageH)

        iView.addSubview(tuanGou)
        tuanGou.hidden = true
        
        self.contentView.addSubview(tLabel)
        self.contentView.addSubview(contentLabel)
        self.contentView.addSubview(likeView)
        
        
        self.contentView.addSubview(bottomView)
        
        initViewsInLikeView(likeImageView, image: "img_like2-1", label: likeLabel)
        initViewsInLikeView(replyImageView, image: "img_comment2-1", label: replyLabel)
        
        
        likeView.backgroundColor = UIColor.whiteColor()
        
        bottomView.headImageView.layer.cornerRadius = bottomView.headImageView.frame.size.width / 2
        bottomView.headImageView.layer.masksToBounds = true
        
        let line = UIView(frame: CGRectMake(0, 0, frame.size.width, 1))
        line.backgroundColor = LifeConstant.mainBackgroundColor
        bottomView.addSubview(line)
        
        playIV.image = UIImage(named:"video_play_btn_bg@2x")
        iView.addSubview(self.playIV)
        playIV.hidden = true
        
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
        LifeUtils.setImageViewForUrl(imageView, url: url)
        imageView.isHidden = false
    }
    
    func setLabelFrameAndText(_ label:UILabel,frame:CGRect,text:String,font:UIFont,textColor:UIColor){
        label.numberOfLines = 0
        label.font = font
        label.text = text
        label.textColor = textColor
        label.frame = frame
    }
    
    func setPositionForImageViewAndLabel(_ imageView:UIImageView,label:UILabel,size:NSNumber,maxX:inout CGFloat){
        if size != 0{
            imageView.isHidden = false
            label.isHidden = false
            
            imageView.frame.origin.x = maxX
            maxX += imageView.frame.size.width + 5
            
            label.frame.origin.x = maxX
            maxX += label.frame.size.width + 5
            
            label.text = String(size)
        }else{
            imageView.isHidden = true
            label.isHidden = true
        }
        
    }
    
    func configLikeView(_ likeSize:NSNumber,replySize:NSNumber){
        
        var maxX:CGFloat = 5
        setPositionForImageViewAndLabel(likeImageView, label: likeLabel, size: likeSize, maxX: &maxX)
        setPositionForImageViewAndLabel(replyImageView, label: replyLabel, size: replySize, maxX: &maxX)
        
        
    }
    
    func setContentLabel(_ label:UILabel,text:String,maxY:inout CGFloat){
        
        let height =  LifeUtils.calculateHeightForContentStr(text)
        label.frame = CGRect(x: LifeConstant.margin / 2, y: maxY + LifeConstant.margin/2, width: LifeConstant.innerWidth,  height: height)
        label.numberOfLines = 0
        label.attributedText = NSAttributedString(string: text, attributes: LifeConstant.contentAttributesDic)
        label.textColor = UIColor.gray
        label.textAlignment = .justified
        maxY += height + LifeConstant.margin / 2
    }
    
    func setTitleLabel(_ label:UILabel,text:String,maxY:inout CGFloat){
        let height =  LifeUtils.calculateHeightForTitleStr(text)
        label.frame = CGRect(x: LifeConstant.margin / 2, y: maxY + LifeConstant.margin/2, width: LifeConstant.innerWidth,  height: height)
        label.numberOfLines = 0
        label.attributedText = NSAttributedString(string: text, attributes: LifeConstant.titleAttributesDic)
        label.textColor = UIColor.black
        label.textAlignment = .justified
        maxY += height + LifeConstant.margin / 2
    }
    
    
    func setData(_ model:LifeModel){
        
        
        urls = model.collectionImgArr
        
        sizes = model.sizes
        
        //        sizes = LifeUtils.arrForJsonString(model.sizes as NSString)
        
        
        maxY = 0
        
        if sizes.count <= 4 {
            for i in 0..<urls.count {
                let imageheight = (sizes[i]["height"] as! CGFloat)/(sizes[i]["width"] as! CGFloat) * frame.size.width
                setImageViewFrameAndUrl(imageViews[i], frame: CGRect(x: 0, y: maxY, width: frame.size.width, height: imageheight), url: urls[i])
                maxY += imageheight
                
            }
        }else if sizes.count % 2 == 0{
            for i in 0..<urls.count {
                
                setImageViewFrameAndUrl(imageViews[i], frame: CGRect(x: CGFloat(i%2) * frame.size.width/2, y: maxY, width: frame.size.width/2, height: frame.size.width/2), url: urls[i])
                if i%2 == 1{
                    maxY += frame.size.width/2
                }
            }
        }else{
            let imageheight = (sizes[0]["height"] as! CGFloat)/(sizes[0]["width"] as! CGFloat) * frame.size.width
            setImageViewFrameAndUrl(imageViews[0], frame: CGRect(x: 0, y: maxY, width: frame.size.width, height: imageheight), url: urls[0])
            maxY += imageheight
            
            for i in 1..<urls.count {
                
                setImageViewFrameAndUrl(imageViews[i], frame: CGRect(x: CGFloat((i-1)%2) * frame.size.width/2, y: maxY, width: frame.size.width/2, height: frame.size.width/2), url: urls[i])
                if i%2 == 0{
                    maxY += frame.size.width/2
                }
            }
        }
        
        for i in urls.count..<9{
            imageViews[i].image = nil
            imageViews[i].isHidden = true
        }
        
        iView.frame.size.height = maxY
        
        if model.isTuanGou == true {
            tuanGou.isHidden = false
//            tuanGou.frame.origin.y = iView.frame.size.height - tuanGou.frame.size.height
        }else{
            tuanGou.isHidden = true
        }
        
        
        tLabel.frame.size.height = 0
        if model.collectionName != "" {
//            setLabel(tLabel, height: model.titleH, text: model.collectionName, font: LifeConstant.titleFont, textColor: UIColor.blackColor())
            setTitleLabel(tLabel, text: model.collectionName, maxY: &maxY)
        }
        
        
//        setLabel(contentLabel, height: model.contentH, text: model.content, font: LifeConstant.contentFont, textColor: UIColor.grayColor())
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
        bottomView.headImageView.setHeadImage(model.avatar, type: model.user_type)
        bottomView.nickLabel.text = model.userNick
        
        if model.remarks != "" {
            bottomView.sourceLabel.text = model.remarks
        }else if model.source != "" {
            bottomView.sourceLabel.text = "来源 : " + model.source
        }else{
            bottomView.sourceLabel.text = ""
        }
        
        
        if model.videoUrl != "" {
            self.playIV.isHidden = false
            let length:CGFloat = 31.5
            self.playIV.frame = CGRect(x: (iView.frame.size.width - length )/2, y: (iView.frame.size.height - length )/2, width: length, height: length)
        }else{
            self.playIV.isHidden = true
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

