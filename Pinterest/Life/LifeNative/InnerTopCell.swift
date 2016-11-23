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
    let addressView:InnerAddressView!
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
        
        headView = NSBundle.mainBundle().loadNibNamed("lifeViews", owner: nil, options: nil)![1] as! InnerHeadView
        headView.frame.size.width = cWidth
        headView.frame.origin.x = margin/2
        headView.frame.size.height = LifeConstant.BIG_HEAD_HEIGHT
        
//        sourceLabel.frame = CGRectMake(margin/2, 0, cWidth, 25)
//        sourceLabel.textColor = UIColor.grayColor()
//        sourceLabel.font = UIFont.systemFontOfSize(13)
        
        addressView = NSBundle.mainBundle().loadNibNamed("lifeViews", owner: nil, options: nil)![2] as! InnerAddressView
        addressView.frame.size.width = cWidth
        addressView.frame.size.height = LifeConstant.BIG_ADDRESS_HEIGHT
        addressView.frame.origin.x = margin/2
        
//        iView = UIView(frame:CGRectMake(margin/2, 0, cWidth, 50))
        
        contentListView = UIView(frame:CGRectMake(0, 0, SCREEN_W, 0))
        
        
        infoView = UIView(frame:CGRectMake(margin/2, 0, cWidth, LifeConstant.BIG_LIKE_HEIGHT))
        
//        guessView = NSBundle.mainBundle().loadNibNamed("lifeViews", owner: nil, options: nil)[3] as! GuessView
//        guessView.frame.size.width = cWidth
//        guessView.frame.origin.x = margin/2
//        guessView.frame.size.height = LifeConstant.BIG_GUESS_HEIGHT
//        guessView.tLable.text = nil
//        guessView.aLabel1.text = nil
//        guessView.aLabel2.text = nil

        //我想要
//        wantView.frame.size.width = cWidth
//        wantView.frame.origin.x = margin/2
//        wantView.frame.size.height = LifeConstant.BIG_WANT_HEIGHT
        
//        iwantBtn.frame.size = CGSize(width: cWidth/3, height: 40)
//        iwantBtn.center = CGPoint(x: wantView.frame.size.width / 2, y: wantView.frame.size.height / 2)
//        iwantBtn.layer.cornerRadius = 5
//        iwantBtn.backgroundColor = LifeConstant.redFontColor
//        iwantBtn.setTitle("我想要", forState: .Normal)
//        iwantBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
//        wantView.addSubview(iwantBtn)
//        wantView.hidden = true
        
        relatedView =  UIView(frame: CGRectMake(0, 0, LifeConstant.bigWidth, 40))
        
        super.init(frame: frame)
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.contentView.backgroundColor = UIColor.whiteColor()
        iView.frame = CGRectMake(margin/2, 0, cWidth, 50)
        for _ in 0..<9{
            let imageView = UIImageView()
            imageViews.append(imageView)
            iView.addSubview(imageView)
        }
        self.contentView.addSubview(headView)
        self.contentView.addSubview(titleLabel)
//        self.contentView.addSubview(sourceLabel)
        self.contentView.addSubview(addressView)
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
        headView.headImageView.userInteractionEnabled = true
        
        readView.frame = CGRectMake(margin/2, 0, cWidth, 20)
        readButton.frame = CGRectMake(readView.frame.size.width - 50, 0, 50, LifeConstant.BIG_READ_HEIGHT)
        readButton.setTitle("阅读全文", forState: UIControlState.Normal)
        readButton.titleLabel?.textAlignment = .Right
        readButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        readButton.titleLabel?.font = UIFont.systemFontOfSize(12)
        readButton.hidden = true
        readView.addSubview(readButton)
        
        infoView.backgroundColor = UIColor.whiteColor()
        initButton(likeButton,image:"img_like3")
        initButton(replyButton,image:"img_comment3")
        
        relatedView.backgroundColor = LifeConstant.mainBackgroundColor
        
        bottomLabel.frame = CGRectMake(0, 10, LifeConstant.bigWidth, 30)
        bottomLabel.backgroundColor = LifeConstant.mainBackgroundColor
        bottomLabel.textColor = UIColor.darkGrayColor()
        bottomLabel.text = "相关内容"
        bottomLabel.textAlignment = .Center
        bottomLabel.font = UIFont.systemFontOfSize(17)
        
        relatedView.addSubview(bottomLabel)
        
        playBtn.setImage(UIImage(named:"video_play_btn_bg@2x"), forState: UIControlState.Normal)
        iView.addSubview(self.playBtn)
        playBtn.hidden = true
        
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
        LifeUtils.setImageViewForUrl(imageView, url: url)
        imageView.isHidden = false
        contentImageViewsAndUrls.append((imageView,url))
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
    
    func setimageView(_ iv:UIImageView,image:String, height:CGFloat, maxY:inout CGFloat){
        iv.frame = CGRect(x: margin/2, y: maxY + LifeConstant.articleMargin, width: LifeConstant.bigInnerWidth, height: height)
        LifeUtils.setImageViewForUrl(iv, url: image)
        maxY += height + LifeConstant.articleMargin
        contentImageViewsAndUrls.append((iv,image))
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
    
    
    
    func setIView(){
        iView.frame.origin.y = maxY
        
        var iY:CGFloat = 0
        if sizes.count <= 4 {
            for i in 0..<urls.count {
                let imageheight = (sizes[i]["height"] as! CGFloat)/(sizes[i]["width"] as! CGFloat) * cWidth
                setImageViewFrameAndUrl(imageViews[i], frame: CGRect(x: 0, y: iY, width: cWidth, height: imageheight), url: urls[i])
                iY += imageheight
                
            }
        }else if sizes.count % 2 == 0{
            for i in 0..<urls.count {
                
                setImageViewFrameAndUrl(imageViews[i], frame: CGRect(x: CGFloat(i%2) * cWidth/2, y: iY, width: cWidth/2, height: cWidth/2), url: urls[i])
                if i%2 == 1{
                    iY += cWidth/2
                }
            }
        }else{
            let imageheight = (sizes[0]["height"] as! CGFloat)/(sizes[0]["width"] as! CGFloat) * cWidth
            setImageViewFrameAndUrl(imageViews[0], frame: CGRect(x: 0, y: iY, width: cWidth, height: imageheight), url: urls[0])
            iY += imageheight
            
            for i in 1..<urls.count {
                
                setImageViewFrameAndUrl(imageViews[i], frame: CGRect(x: CGFloat((i-1)%2) * cWidth/2, y: iY , width: cWidth/2, height: cWidth/2), url: urls[i])
                if i%2 == 0{
                    iY += cWidth/2
                }
            }
        }
        
        for i in urls.count..<9{
            imageViews[i].image = nil
            imageViews[i].isHidden = true
        }
        
        iView.frame.size.height = iY
        
        maxY += iY
    }
    
    //MARK:设置数据
    func setData(){
        contentImageViewsAndUrls = []
        maxY = 0
        
        headView.frame.origin.y = maxY
//        headView.headImageView.sd_setImageWithURL(NSURL(string: model.avatar.changeImageUrlToUsIp()))
        headView.headImageView.setHeadImage(model.avatar, type: model.user_type)
        headView.nickLabel.text = model.userNick
        headView.timeLabel.text = model.releaseTime
        
        print("headView.headImageView.frame: \(headView.headImageView.frame)")
        print("headView.nickLabel.frame.size.width: \(headView.nickLabel.frame.size.width)")
        
        if String(model.userId) == Constants.CURRENT_USER_ID{
            headView.followBtn.isHidden = true
        }else{
            headView.followBtn.isHidden = false
        }
        
        if model.user_type  == 0{
            headView.darenLabel.isHidden = true
        }else{
            headView.darenLabel.isHidden = false
            headView.darenLabel.text = model.remarks
            if model.user_type  == 1{
                headView.darenLabel.textColor = UIColor(red: 252/255.0, green: 189/255.0, blue: 0, alpha: 1)
            }else if model.user_type  == 2{
                headView.darenLabel.textColor = UIColor.red
            }
        }
        
        maxY += headView.frame.size.height
        
        
        titleLabel.frame.size.height = 0
        if model.collectionName != "" {
            setTitleLabel(titleLabel, text: model.collectionName, maxY: &maxY)
        }
        
//        if model.source != "" {
//            sourceLabel.hidden = false
//            sourceLabel.frame.origin.y = maxY
//            sourceLabel.text = "来源："+model.source
//            maxY += sourceLabel.frame.size.height
//        }else{
//            sourceLabel.hidden = true
//        }
        
        //地址
        if model.location != "" {
            addressView.isHidden = false
            addressView.frame.origin.y = maxY
            addressView.addressLabel.text = model.location
            maxY += addressView.frame.size.height
            maxY += LifeConstant.margin/2
        }else{
            addressView.isHidden = true
        }
        
        maxY += LifeConstant.articleMargin
        
        urls = model.collectionImgArr
        sizes = model.sizes
        setIView()
        
//        maxY += LifeConstant.margin/2
//        setContentLabel(contentLabel, height: model.bigContentH, text: model.content, font: LifeConstant.bigContentFont, textColor: UIColor.blackColor())
        
        if model.contentList.count == 0 {
            contentLabel.isHidden = false
            setContentLabel(contentLabel, text: model.content, maxY: &maxY)
        }else{
            contentLabel.isHidden = true
        }
        
        contentListView.frame.origin.y = maxY
        contentListView.frame.size.height = model.contentListH
        setContentList()
        maxY += model.contentListH
        
        //阅读
        readView.frame.origin.y = maxY
        maxY += readView.frame.size.height

        
//        maxY += LifeConstant.margin/2
        
        //tags
        tagView.removeFromSuperview()
        tagView = UIView(frame:CGRect(x: margin/2, y: maxY, width: cWidth, height: LifeConstant.BIG_TAG_HEIGHT))
        tagView.backgroundColor = UIColor.white
        contentView.addSubview(tagView)
    
        maxY += tagView.frame.size.height
        
        infoView.frame.origin.y = maxY
        infoView.isHidden = false
        maxY += infoView.frame.size.height
        
         configInfoView()
        
//        guessView.frame.origin.y = maxY
//        maxY += guessView.frame.size.height
        
        //我想要
//        if model.wantType == 5{
//            wantView.hidden = false
//            wantView.frame.origin.y = maxY
//            maxY += wantView.frame.size.height
//        }else{
//            wantView.hidden = true
//        }
        
        if model.isTuanGou == true {
            bottomLabel.text = "滑动查看商品详情"
            bottomLabel.font = UIFont.systemFont(ofSize: 14)
            bottomLabel.textColor = UIColor.lightGray
        }else{
            bottomLabel.text = "相关内容"
            bottomLabel.font = UIFont.systemFont(ofSize: 17)
            bottomLabel.textColor = UIColor.darkGray
        }
        
        relatedView.frame.origin.y = maxY
        
        //播放视频
        setVideoControl()
        
        //点击图片手势
        setImageViewsGesture()
        
        if model.isSet == false{
            setButtonsEnable(false)
        }else{
            setControlsInSecondStep()
        }
        
        addHeadViewsGesture()
        
    }
    
    //MARK: 长文章
    func setContentList(){
        var y:CGFloat = 0
        for v in self.contentListView.subviews{
            v.removeFromSuperview()
        }
        
        for dic in model.contentList{
            let type = dic.intForKey("type")
            let content = dic.stringForKey("content")
            switch type {
            case 0:
                let iv = UIImageView()
                let size = dic.stringForKey("size")
                let ratio = LifeUtils.calculateHWRatioFromString(size)
                let h = LifeConstant.bigInnerWidth * ratio
                setimageView(iv, image: content, height: h, maxY: &y)
                self.contentListView.addSubview(iv)
//                setImageViewsGesture(iv, image: content)
                imageViews.append(iv)
            case 1:
                let cLabel = UILabel()
                setContentLabel(cLabel, text: content, maxY: &y)
                self.contentListView.addSubview(cLabel)
//            case 5:
//                let tLabel = UILabel()
//                setTitleLabel(tLabel, text: content, maxY: &y)
//                self.contentListView.addSubview(tLabel)
            default:
                break
            }
        }
       
    }
    
    //MARK:按钮是否可点击
    func setButtonsEnable(_ isTrue:Bool){
        headView.followBtn.isEnabled = isTrue
        likeButton.isEnabled = isTrue
        replyButton.isEnabled = isTrue
        readButton.isEnabled = isTrue
        
//        guessView.wholeButton.enabled =  isTrue
//        if isTrue == false{
//            guessView.tLable.text = nil
//            guessView.aLabel1.text = nil
//            guessView.aLabel2.text = nil
//        }
    }
    
    //MARK:内页
    func setControlsInSecondStep(){
        setButtonsEnable(true)
        
        if model.readFlag == 1{
            readButton.isHidden = false
            readButton.tag = index
            readButton.addTarget(vc, action: #selector(LifeInnerController.read(_:)), for: UIControlEvents.touchUpInside)
        }else{
            readButton.isHidden = true
        }
        
        configTagView(model.tagList)
        
        likeButton.tag = index
        likeButton.addTarget(vc, action: #selector(LifeInnerController.toLikeList(_:)), for: UIControlEvents.touchUpInside)
        
        replyButton.tag = index
        replyButton.addTarget(vc, action: #selector(LifeInnerController.comment(_:)), for: UIControlEvents.touchUpInside)
        
        for b in tagButtons{
            b.addTarget(vc, action: #selector(LifeInnerController.leap(_:)), for: UIControlEvents.touchUpInside)
        }
        
        if model.isfans == 0{
            headView.followBtn.isSelected = false
        }else{
            headView.followBtn.isSelected = true
        }
        headView.followBtn.tag = index
        headView.followBtn.addTarget(vc, action: #selector(LifeInnerController.follow(_:)), for: UIControlEvents.touchUpInside)
        
//        iwantBtn.tag = index
//        iwantBtn.addTarget(vc, action: #selector(LifeInnerController.want(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
//        setGuessViewContent()
//        guessView.wholeButton.tag = index
//        guessView.wholeButton.addTarget(vc, action: #selector(LifeInnerController.guess(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
//    func setGuessViewContent(){
//        guessView.tLable.text = model.mayaskList.first?["askQuestion"] as? String
//        if let answerArr = model.mayaskList.first?["likes"] as? [NSDictionary]{
//            guessView.aLabel1.text = answerArr.count >= 1 ? answerArr[0]["content"] as? String:nil
//            guessView.aLabel2.text = answerArr.count >= 2 ? answerArr[1]["content"] as? String:nil
//        }
//    }
    
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
    
    func setVideoControl(){
        if model.videoUrl != "" {
            self.playBtn.isHidden = false
            self.playBtn.frame = iView.bounds
            self.playBtn.tag = index
            self.playBtn.addTarget(vc, action: #selector(LifeInnerController.play(_:)), for: UIControlEvents.touchUpInside)
        }else{
            self.playBtn.isHidden = true
        }
    }
    
    func addHeadViewsGesture(){
        let tapGestureRecognizer = UserIdTapGestureRecognizer(target: vc,action: #selector(LifeInnerController.headTap(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.userId = model.userId
        headView.headImageView.addGestureRecognizer(tapGestureRecognizer)
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












