//
//  DarenTopCell.swift
//  finding
//
//  Created by bob song on 16/9/26.
//  Copyright © 2016年 zhangli. All rights reserved.
//

import UIKit

class DarenTopCell: CommonCollectionViewCell{
    
    weak var vc:LifeInnerController?
    var model:LifeModel!
    
    var index = -1
    var contentImageViewsAndUrls:[(UIImageView,String)] = []
    let titleLabel = UILabel()
    var imageV:UIImageView!
    let contentLabel = UILabel()
    
    let relatedView:UIView!
    
    //内容的宽度
    var cWidth:CGFloat!
    //边缘的宽度
    var margin:CGFloat!
    
    override init(frame: CGRect) {
        margin = LifeConstant.bigMargin
        cWidth = LifeConstant.bigInnerWidth
        
        relatedView =  UIView(frame: CGRectMake(0, 0, LifeConstant.bigWidth, 40))
        
        super.init(frame: frame)
        self.layer.cornerRadius = 1.5
        self.layer.masksToBounds = true
        self.contentView.backgroundColor = UIColor.whiteColor()
        
        iView.frame = CGRectMake(margin/2, LifeConstant.bigMargin / 2, cWidth, cWidth)
        imageV = UIImageView(frame: CGRect(x: 0, y: 0, width: cWidth, height: cWidth))
        iView.addSubview(imageV)
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(iView)
        self.contentView.addSubview(contentLabel)
        self.contentView.addSubview(relatedView)
        
        relatedView.backgroundColor = LifeConstant.mainBackgroundColor
        
        let bottomLabel = UILabel(frame: CGRectMake(20, 10, 200, 30))
        bottomLabel.backgroundColor = LifeConstant.mainBackgroundColor
        bottomLabel.textColor = UIColor.darkGrayColor()
        bottomLabel.text = "搭配案例"
        bottomLabel.textAlignment = .Left
        bottomLabel.font = UIFont.systemFontOfSize(15)
        bottomLabel.sizeToFit()
        relatedView.addSubview(bottomLabel)
        
        let circleLayer = CAShapeLayer()
        let radius: CGFloat = 1.5
        circleLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 2.0 * radius, height: 2.0 * radius)  , cornerRadius: radius).CGPath
        circleLayer.fillColor = UIColor.lightGrayColor().CGColor
        circleLayer.position = CGPoint(x: bottomLabel.frame.maxX + 10 + radius, y: bottomLabel.center.y - radius)
        relatedView.layer.addSublayer(circleLayer)
        
        let lineLayer = CAShapeLayer()
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: circleLayer.frame.maxX + 5, y: bottomLabel.center.y))
        path.addLineToPoint(CGPoint(x: circleLayer.frame.maxX + 5 + SCREEN_W / 3, y: bottomLabel.center.y))
        lineLayer.path = path.CGPath
        lineLayer.strokeColor = UIColor.lightGrayColor().CGColor
        relatedView.layer.addSublayer(lineLayer)
    }
    
    var maxY:CGFloat = 0
    
    func setImageViewFrameAndUrl(_ imageView:UIImageView,frame:CGRect,url:String){
        imageView.frame = frame
        LifeUtils.setImageViewForUrl(imageView, url: url)
        imageView.isHidden = false
        contentImageViewsAndUrls.append((imageView,url))
    }
    
    func setLabel(_ label:UILabel,height:CGFloat,text:String,font:UIFont,textColor:UIColor){
        
        //        print("setLabel height: \(height)")
        
        label.frame = CGRect(x: margin/2, y: maxY, width: cWidth,  height: height)
        label.numberOfLines = 0
        
        label.font = font
        label.text = text
        label.textColor = textColor
        label.textAlignment = .justified
        
        maxY += height
        
    }
    
    func setContentLabel(_ label:UILabel,height:CGFloat,text:String,font:UIFont,textColor:UIColor){
        
        //        print("setLabel height: \(height)")
        
        label.frame = CGRect(x: margin/2, y: maxY + LifeConstant.margin/2, width: cWidth,  height: height)
        label.numberOfLines = 0
        
        label.font = font
        label.attributedText = NSAttributedString(string: text, attributes: LifeConstant.bigContentAttributesDic)
        label.textColor = textColor
        label.textAlignment = .justified
        
        maxY += height + LifeConstant.margin/2
        
    }
    
    func setContentLabel(_ label:UILabel,text:String,maxY:inout CGFloat){
        
        let height =  LifeUtils.calculateHeightForBigContentStr(text)
        
        label.frame = CGRect(x: margin/2, y: maxY + LifeConstant.articleMargin, width: LifeConstant.bigInnerWidth,  height: height)
        label.numberOfLines = 0
        label.attributedText = NSAttributedString(string: text, attributes: LifeConstant.bigContentAttributesDic)
        label.textColor = UIColor.black
        label.textAlignment = .justified
        maxY += height + LifeConstant.articleMargin
    }
    
    func setTitleLabel(_ label:UILabel,text:String,maxY:inout CGFloat){
        let height =  LifeUtils.calculateHeightForBigTitleStr(text)
        label.frame = CGRect(x: margin/2, y: maxY + LifeConstant.articleMargin, width: LifeConstant.bigInnerWidth,  height: height)
        label.numberOfLines = 0
        label.attributedText = NSAttributedString(string: text, attributes: LifeConstant.bigTitleAttributesDic)
        label.textColor = UIColor.black
        label.textAlignment = .justified
        maxY += height + LifeConstant.articleMargin
    }
    
    func setPositionForButton(_ button:UIButton,size:NSNumber,maxX:inout CGFloat){
        if size != 0{
            button.isHidden = false
            button.frame.origin.x = maxX
            button.setTitle(String(size), for: UIControlState())
            maxX += button.frame.size.width + 15
        }else{
            button.isHidden = true
        }
    }
    
    //MARK:设置数据
    func setData(){
        contentImageViewsAndUrls = []
        maxY = 0
        
        iView.frame.size.height = model.bigImagesH
        imageV.frame.size.height = model.bigImagesH
        LifeUtils.setImageViewForUrl(imageV, url: model.masterPhotos)
        
        maxY += imageV.frame.size.height + LifeConstant.bigMargin / 2
        
        if model.masterName != "" {
            setTitleLabel(titleLabel, text: model.masterName, maxY: &maxY)
        }
        
        setContentLabel(contentLabel, height: model.bigContentH, text: model.masterRemark, font: LifeConstant.bigContentFont, textColor: UIColor.black)
        
        relatedView.frame.origin.y = maxY
        
        //点击图片手势
//        setImageViewsGesture()
        
    }
    
    func setImageViewsGesture(){
        
        for i in 0..<contentImageViewsAndUrls.count{
            let imageView = contentImageViewsAndUrls[i].0
            
            if let grs = imageView.gestureRecognizers{
                for recognizer in grs {
                    imageView.removeGestureRecognizer(recognizer)
                }
            }
            
            
            imageView.isUserInteractionEnabled = true
            let tapGestureRecognizer = ImageClickTapGestureRecognizer(target: vc,
                                                                      action: #selector(LifeInnerController.clickPhoto(_:)))
            tapGestureRecognizer.numberOfTapsRequired = 1
            tapGestureRecognizer.images = contentImageViewsAndUrls.map({ (iv,url) -> String in
                url
            })
            tapGestureRecognizer.page = i
            tapGestureRecognizer.iv = imageView
            tapGestureRecognizer.imageViews = contentImageViewsAndUrls.map({ (iv,url) -> WeakBox<UIImageView> in
                WeakBox(iv)
            })
            imageView.addGestureRecognizer(tapGestureRecognizer)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DaPeiView:UIView{
    var whiteV = UIView()
    var extendableV = UIView()
    var l = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        whiteV.frame = CGRect(x: 5, y: 0, width: frame.size.width - 10, height: frame.size.height)
        self.addSubview(whiteV)
        extendableV.frame = CGRect(x: 0, y: 0, width: 100, height: frame.size.height)
        whiteV.addSubview(extendableV)
        whiteV.clipsToBounds = true
        backgroundColor = UIColor.white
        l.frame = whiteV.bounds
        l.textColor = UIColor.darkGray
        l.font = UIFont.systemFont(ofSize: 12)
        l.textAlignment = .center
        whiteV.addSubview(l)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setStrs(_ strs:[String]){
//        if strs.count == 0 {
//            return
//        }
//        
//        maxX = 0
//        for v in extendableV.subviews{
//            v.removeFromSuperview()
//        }
//        if strs.count > 1 {
//            for i in 0...strs.count - 2{
//                addLabelForString(strs[i])
//                addLine()
//            }
//        }
//        addLabelForString(strs[strs.count - 1])
//        extendableV.frame.size.width = maxX
//        if extendableV.frame.size.width > frame.width {
//            extendableV.frame.origin.x = 0
//        }else{
//            extendableV.center.x = whiteV.frame.size.width / 2
//        }
        
        if strs.count == 0 {
            return
        }
        
        l.text = ""
        
        if strs.count > 1 {
            for i in 0...strs.count - 2{
                l.text = (l.text! + strs[i] + "⏐")
            }
        }
        
        l.text = (l.text! + strs[strs.count - 1] )

    }
    var maxX:CGFloat = 0
    func addLabelForString(_ str:String){
        let lSize = (str as NSString).size(attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 12)])
        let l = UILabel(frame: CGRect(x: maxX, y: 5, width: lSize.width, height: 20))
        l.text = str
        l.textColor = UIColor.darkGray
        l.font = UIFont.systemFont(ofSize: 12)
        extendableV.addSubview(l)
        maxX += lSize.width
    }
    
    func addLine(){
        let l = UIView(frame: CGRect(x: maxX + 5, y: 5, width: 1, height: 20))
        l.backgroundColor = UIColor.lightGray
        extendableV.addSubview(l)
        maxX += 11
    }
}

class DaPeiCollectView:UIView{
    @IBOutlet weak var b:UIButton!
    @IBOutlet weak var l:UILabel!
    @IBOutlet weak var centerConstraint: NSLayoutConstraint!
}

class DarenDaPeiCell: UICollectionViewCell{
    let iv:UIImageView = UIImageView()
    let daPeiV:DaPeiView
    let daPeiCollectV:DaPeiCollectView
    
    weak var vc:LifeInnerController?
    
    override init(frame: CGRect) {
        iv.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.width * 3 / 2)
        daPeiV = DaPeiView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 30))
        daPeiCollectV = Bundle.mainBundle().loadNibNamed("lifeViews", owner: nil, options: nil)![4] as! DaPeiCollectView
        daPeiCollectV.frame.size = CGSize(width: frame.size.width, height: 30)
        super.init(frame: frame)
        contentView.addSubview(iv)
        daPeiV.frame.origin.y = iv.frame.maxY
        contentView.addSubview(daPeiV)
        daPeiCollectV.frame.origin.y = daPeiV.frame.maxY
        contentView.addSubview(daPeiCollectV)
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }
    
//    var constraint1 = NSLayoutConstraint()
//    var constraint2 = NSLayoutConstraint()
    
    func setData(_ model:DarenMasterModel){
        LifeUtils.setImageViewForUrl(iv, url: model.caseImage)
        
        let strs = model.caseTags.componentsSeparatedByCharactersInSet(CharacterSet(charactersInString: ",，"))
        
        daPeiV.setStrs(strs)
        
        daPeiCollectV.l.text = String(model.likeSize)
        
        if model.likeSize == 0{
            daPeiCollectV.l.hidden = true
            daPeiCollectV.centerConstraint.constant = 0
        }else{
            daPeiCollectV.l.hidden = false
            daPeiCollectV.centerConstraint.constant = -20
        }
        daPeiCollectV.b.selected = (model.isLike == 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LifeActivityCell: UICollectionViewCell{
    let iv:UIImageView = UIImageView()
    let whiteView = UIView()
    override init(frame: CGRect) {
        whiteView.frame = CGRect(x: 10, y: 10 , width: frame.size.width - 20, height: frame.size.height - LifeConstant.margin)
        whiteView.backgroundColor = UIColor.white
        iv.frame = CGRect(x: 0, y: 0 , width: frame.size.width - 20, height: frame.size.height - LifeConstant.margin)
        super.init(frame: frame)
        whiteView.addSubview(iv)
        whiteView.layer.cornerRadius = 5
        whiteView.layer.masksToBounds = true
        contentView.addSubview(whiteView)
        backgroundColor = LifeConstant.mainBackgroundColor
    }
    
    func setData(_ model:ActivityModel){
        LifeUtils.setImageViewForUrl(iv, url: model.activityImage)
        whiteView.frame.size.height = model.height - LifeConstant.margin
        iv.frame.size.height = model.height - LifeConstant.margin
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TuanGouView:UIView {
    @IBOutlet weak var iWant: UIButton!
    @IBOutlet weak var renShuLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
}
