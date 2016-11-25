//
//  InnerTopCell.swift
//  finding
//
//  Created by bob song on 16/3/18.
//  Copyright © 2016年 zhangli. All rights reserved.
//

import UIKit

//内页头部Cell
class InnerTopCell:CommonCollectionViewCell{
    
    weak var vc:LifeInnerController?
    var model:LifeModel!
    
    var index = -1
    var contentImageViewsAndUrls:[(UIImageView,String)] = []
    var imageViews:[UIImageView] = []
    let titleLabel = UILabel()
//    let sourceLabel = UILabel()
//    let addressView:InnerAddressView!
//    let iView:UIView!
    let contentLabel = UILabel()
    var contentListView:UIView!
    let headView:InnerHeadView!
    let readView = UIView()
    var tagView = UIView()
    let infoView:UIView!
    
//    let guessView:GuessView!
//    let wantView = UIView()
//    let iwantBtn:UIButton = UIButton()
    
    let relatedView:UIView!
    
    let readButton = UIButton()
    
    let playBtn = UIButton()
    
    //内容的宽度
    var cWidth:CGFloat!
    //边缘的宽度
    var margin:CGFloat!
    
    var likeButton = LifeButton()
    let replyButton = LifeButton()
    
    let bottomLabel = UILabel()
    
    override init(frame: CGRect) {
        margin = LifeConstant.bigMargin
        cWidth = LifeConstant.bigInnerWidth
        
        headView = Bundle.main.loadNibNamed("lifeViews", owner: nil, options: nil)![1] as! InnerHeadView
        headView.frame.size.width = cWidth
        headView.frame.origin.x = margin
        headView.frame.size.height = LifeConstant.BIG_HEAD_HEIGHT

        
        contentListView = UIView(frame:CGRect(x:0,y: 0,width: SCREEN_W,height: 0))
        
        
        infoView = UIView(frame:CGRect(x:margin,y: 0,width: cWidth,height: LifeConstant.BIG_LIKE_HEIGHT))
        
        relatedView =  UIView(frame: CGRect(x:0,y: 0,width: LifeConstant.bigWidth,height: 40))
        
        super.init(frame: frame)
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.contentView.backgroundColor = UIColor.white
        iView.frame = CGRect(x:margin,y: 0,width: cWidth,height: 50)
        for _ in 0..<9{
            let imageView = UIImageView()
            imageViews.append(imageView)
            iView.addSubview(imageView)
        }
        self.contentView.addSubview(headView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(iView)
        self.contentView.addSubview(contentLabel)
        self.contentView.addSubview(contentListView) //
        self.contentView.addSubview(readView)
        self.contentView.addSubview(tagView)
        self.contentView.addSubview(infoView)
//        self.contentView.addSubview(guessView)
//        self.contentView.addSubview(wantView)
        self.contentView.addSubview(relatedView)
        
        headView.headImageView.layer.cornerRadius = headView.headImageView.frame.size.width / 2
        headView.headImageView.layer.masksToBounds = true
        headView.headImageView.isUserInteractionEnabled = true
        
        readView.frame = CGRect(x:margin,y: 0,width: cWidth,height: 20)
        readButton.frame = CGRect(x:readView.frame.size.width - 50,y: 0,width: 50,height: LifeConstant.BIG_READ_HEIGHT)
        readButton.setTitle("阅读全文", for: UIControlState.normal)
        readButton.titleLabel?.textAlignment = .right
        readButton.setTitleColor(UIColor.red, for: UIControlState.normal)
        readButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        readButton.isHidden = true
        readView.addSubview(readButton)
        
        infoView.backgroundColor = UIColor.white
        initButton(likeButton,image:"img_like3")
        initButton(replyButton,image:"img_comment3")
        
        relatedView.backgroundColor = LifeConstant.mainBackgroundColor
        
        bottomLabel.frame = CGRect(x:0,y: 10,width: LifeConstant.bigWidth,height: 30)
        bottomLabel.backgroundColor = LifeConstant.mainBackgroundColor
        bottomLabel.textColor = UIColor.darkGray
        bottomLabel.text = "相关内容"
        bottomLabel.textAlignment = .center
        bottomLabel.font = UIFont.systemFont(ofSize: 17)
        
        relatedView.addSubview(bottomLabel)
        
    }
    
    func initButton(_ b:UIButton,image:String){
        b.frame = CGRect(x: 0, y: 7.5, width: 50, height: 15)
        b.setImage(UIImage(named: image), for: UIControlState())
        b.setTitleColor(UIColor.gray, for: UIControlState())
        b.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        infoView.addSubview(b)
    }
    
    var maxY:CGFloat = 0
    var sizes:[NSDictionary]!
    var urls:[String]!
    
    func setImageViewFrameAndUrl(_ imageView:UIImageView,frame:CGRect,url:String){
        imageView.frame = frame
        imageView.setImageForURLString(str: url)
        imageView.isHidden = false
        contentImageViewsAndUrls.append((imageView,url))
    }
    
    func setContentLabel(_ label:UILabel,text:String,maxY:inout CGFloat){
        
        let height =  LifeUtils.calculateHeightForBigContentStr(text)
        
        label.frame = CGRect(x: margin, y: maxY + LifeConstant.articleMargin, width: LifeConstant.bigInnerWidth,  height: height)
        label.numberOfLines = 0
        label.attributedText = NSAttributedString(string: text, attributes: LifeConstant.bigContentAttributesDic)
        label.textColor = UIColor.black
        label.textAlignment = .justified
        maxY += height + LifeConstant.articleMargin
    }
    
//    func setimageView(_ iv:UIImageView,image:String, height:CGFloat, maxY:inout CGFloat){
//        iv.frame = CGRect(x: margin, y: maxY + LifeConstant.articleMargin, width: LifeConstant.bigInnerWidth, height: height)
//        iv.setImageForURLString(str: image)
//        maxY += height + LifeConstant.articleMargin
//        contentImageViewsAndUrls.append((iv,image))
//    }
    
    func setTitleLabel(_ label:UILabel,text:String,maxY:inout CGFloat){
        let height =  LifeUtils.calculateHeightForBigTitleStr(text)
        label.frame = CGRect(x: margin, y: maxY + LifeConstant.articleMargin, width: LifeConstant.bigInnerWidth,  height: height)
        label.numberOfLines = 0
        label.attributedText = NSAttributedString(string: text, attributes: LifeConstant.bigTitleAttributesDic)
        label.textColor = UIColor.black
        label.textAlignment = .justified
        maxY += height + LifeConstant.articleMargin
    }
    
    func configTagView(_ tagList:[NSDictionary]){
        if tagList.count == 0{
            return
        }
        for v in tagView.subviews{
            v.removeFromSuperview()
        }
        var maxX:CGFloat = 0
        let iv = UIImageView(frame: CGRect(x: maxX, y: 5, width: 20, height: 20))
        iv.image = UIImage(named: "img_tag")
        tagView.addSubview(iv)
        maxX += iv.frame.size.width + 5
        
        tagButtons = []
        for tag in tagList{
            let name = tag["tagName"] as! String
            let id = tag["tagId"] as! Int
            addTagButton(&maxX, name: name,id:id )
        }
        
    }
    
    
    var tagButtons:[UIButton] = []
    
    func addTagButton(_ maxX:inout CGFloat,name:String,id:Int){
        let bSize = (name as NSString).size(attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 12)])
        let b = UIButton(frame: CGRect(x: maxX, y: 5, width: bSize.width, height: 20))
        b.setTitle(name, for: UIControlState())
        b.setTitleColor(UIColor.red, for: UIControlState())
        b.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        b.tag = id
        tagView.addSubview(b)
        maxX += b.frame.size.width + 10
        tagButtons.append(b)
    }

    func configInfoView(){
        
        var maxX:CGFloat = 5
        
        setPositionForButton(likeButton, size: model.likeSize, maxX: &maxX)
        setPositionForButton(replyButton, size: model.replySize, maxX: &maxX)
    }
    
    func setPositionForButton(_ button:UIButton,size:Int,maxX:inout CGFloat){
        if size != 0{
            button.isHidden = false
            button.frame.origin.x = maxX
            button.setTitle(String(size), for: UIControlState())
            maxX += button.frame.size.width + 15
        }else{
            button.isHidden = true
        }
    }
    
    
    
    func setIView(){
        iView.frame.origin.y = maxY
        
        var iY:CGFloat = 0
        for i in 0..<urls.count {
            let imageheight = (sizes[i]["height"] as! CGFloat)/(sizes[i]["width"] as! CGFloat) * cWidth
            setImageViewFrameAndUrl(imageViews[i], frame: CGRect(x: 0, y: iY, width: cWidth, height: imageheight), url: urls[i])
            iY += imageheight
            
        }
        
        for i in urls.count..<9{
            imageViews[i].image = nil
            imageViews[i].isHidden = true
        }
        
        iView.frame.size.height = iY
        
        maxY += iY
    }
    
    func setDate(index:Int,model:LifeModel,vc:LifeInnerController){
        self.index = index
        self.model = model
        self.vc = vc
        setData()
    }
    
    //MARK:设置数据
    func setData(){
        contentImageViewsAndUrls = []
        maxY = 0
        
        headView.frame.origin.y = maxY
        headView.headImageView.setImageForURLString(str: model.avatar)
        headView.nickLabel.text = model.userNick
        headView.timeLabel.text = model.releaseTime
        
        print("headView.headImageView.frame: \(headView.headImageView.frame)")
        print("headView.nickLabel.frame.size.width: \(headView.nickLabel.frame.size.width)")
        
        headView.followBtn.isHidden = true
        
        maxY += headView.frame.size.height
        
        
        titleLabel.frame.size.height = 0
        if model.collectionName != "" {
            setTitleLabel(titleLabel, text: model.collectionName, maxY: &maxY)
        }
        
        maxY += LifeConstant.articleMargin
        
        urls = model.collectionImgArr
        sizes = model.sizes
        setIView()
        
        contentListView.frame.origin.y = maxY
        contentListView.frame.size.height = model.contentListH
        maxY += model.contentListH
        
        //阅读
        readView.frame.origin.y = maxY
        maxY += readView.frame.size.height
        
        //tags
        tagView.removeFromSuperview()
        tagView = UIView(frame:CGRect(x: margin, y: maxY, width: cWidth, height: LifeConstant.BIG_TAG_HEIGHT))
        tagView.backgroundColor = UIColor.white
        contentView.addSubview(tagView)
    
        maxY += tagView.frame.size.height
        
        infoView.frame.origin.y = maxY
        infoView.isHidden = false
        maxY += infoView.frame.size.height
        
        configInfoView()
        
        relatedView.frame.origin.y = maxY
        
        //点击图片手势
        setImageViewsGesture()
        
        if model.isSet == false{
            setButtonsEnable(false)
        }else{
            setControlsInSecondStep()
        }
        
    }
    
    //MARK:按钮是否可点击
    func setButtonsEnable(_ isTrue:Bool){
        headView.followBtn.isEnabled = isTrue
        likeButton.isEnabled = isTrue
        replyButton.isEnabled = isTrue
        readButton.isEnabled = isTrue
    }
    
    //MARK:内页
    func setControlsInSecondStep(){
        setButtonsEnable(true)
        
        if model.readFlag == 1{
            readButton.isHidden = false
            readButton.tag = index
        }else{
            readButton.isHidden = true
        }
        
        configTagView(model.tagList)
        
        likeButton.tag = index

        
        replyButton.tag = index
        
        for b in tagButtons{
            b.addTarget(vc, action: #selector(LifeInnerController.leap(_:)), for: UIControlEvents.touchUpInside)
        }
        
        if model.isfans == 0{
            headView.followBtn.isSelected = false
        }else{
            headView.followBtn.isSelected = true
        }
        headView.followBtn.tag = index

    }

    
    func setImageViewsGesture(){
        setButtonsEnable(true)
        
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
    
    func hideRelatedView(){
        relatedView.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LifeButton:UIButton{
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let l = frame.size.height
        
        self.imageView!.frame = CGRect(x: 0, y: 0, width: l, height: l)
        
        self.titleLabel!.frame = CGRect(x: l + 5, y: 0, width: frame.size.width - l - 5, height: l)
    }
}

//防止循环引用
struct WeakBox<T: AnyObject> {
    weak var value: T!
    // Initializer to remove the `value:` label in the initializer call.
    init(_ value: T) {
        self.value = value
    }
}

class ImageClickTapGestureRecognizer: UITapGestureRecognizer{
//    var index:Int!
    var images:[String] = []
    var page:Int!
    weak var iv:UIImageView!
    var imageViews:[WeakBox<UIImageView>] = []
}

class GuessView:UIView{
    @IBOutlet weak var tLable: UILabel!
    @IBOutlet weak var aLabel1: UILabel!
    @IBOutlet weak var aLabel2: UILabel!
    @IBOutlet weak var wholeButton: UIButton!
    
}












