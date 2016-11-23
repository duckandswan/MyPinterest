//
//  LifeInnerCell.swift
//  finding
//
//  Created by bob song on 16/3/30.
//  Copyright © 2016年 zhangli. All rights reserved.
//

import UIKit

//内页主Cell
class LifeInnerCell:UICollectionViewCell{
    var relatedCollectionView:UICollectionView!
//    var innerWantView:InnerWantView!
    let waterfallLayout = WaterFlowViewLayout()
    var backBtn = UIButton()
    
    var likeButton = UIButton()
    var collectButton = UIButton()
    var shareBtn = UIButton()
    var commentBtn = UIButton()
    
    var bountyBtn = UIButton()
    
    var arrangeBtn = UIButton()
    
    let darenHeadTitle = UILabel()
    
    var tuanGouWantView:TuanGouView!
    
    weak var vc:LifeInnerController?
    var model:LifeModel!
    var index:Int!
    override init(frame: CGRect) {
        super.init(frame: frame)
        let topView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 64))
        topView.layer.zPosition = 1500
        
        topView.backgroundColor = UIColor.white
        contentView.addSubview(topView)
        
        backBtn.frame.size = CGSize(width: 44, height: 44)
        backBtn.frame.origin.x = 0
        backBtn.setImage(UIImage(named: "btn_back"), for: UIControlState())
        topView.addSubview(backBtn)
        backBtn.frame.origin.y = 20
        
        shareBtn.frame =  CGRect(x: frame.size.width - 44, y: 20, width: 44, height: 44)
        shareBtn.setImage(UIImage(named: "share"), for: UIControlState())
        topView.addSubview(shareBtn)
        
        commentBtn.frame =  CGRect(x: shareBtn.frame.origin.x - 44, y: 20, width: 44, height: 44)
        commentBtn.setImage(UIImage(named: "btn_comments"), for: UIControlState())
        topView.addSubview(commentBtn)
        
        collectButton.frame =  CGRect(x: commentBtn.frame.origin.x - 54, y: 20, width: 44, height: 44)
        collectButton.setImage(UIImage(named: "btn_collect"), for: UIControlState())
        collectButton.setImage(UIImage(named: "btn_collect_select"), for: UIControlState.selected)
        topView.addSubview(collectButton)
        
        likeButton.frame =  CGRect(x: collectButton.frame.origin.x - 54, y: 20, width: 44, height: 44)
        likeButton.setImage(UIImage(named: "btn_like"), for: UIControlState())
        likeButton.setImage(UIImage(named: "btn_like_select"), for: UIControlState.selected)
        topView.addSubview(likeButton)
        
        let lineView: UIView = UIView(frame: CGRect(x: 0, y: topView.frame.maxY - 1, width: SCREEN_W, height: 1))
        lineView.backgroundColor = LifeConstant.mainBackgroundColor
        topView.addSubview(lineView)
        
        
        relatedCollectionView = UICollectionView(frame: CGRect(x: 0, y: 64, width: frame.width, height: frame.height - 64), collectionViewLayout: waterfallLayout)
        relatedCollectionView.backgroundColor = LifeConstant.mainBackgroundColor
        relatedCollectionView.alwaysBounceVertical = true
        relatedCollectionView.showsVerticalScrollIndicator  = false
        
        
        relatedCollectionView.register(LifeCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        relatedCollectionView.register(InnerTopCell.self, forCellWithReuseIdentifier: "HeadCell")
        relatedCollectionView.register(DarenTopCell.self, forCellWithReuseIdentifier: "DarenTopCell")
        relatedCollectionView.register(DarenDaPeiCell.self, forCellWithReuseIdentifier: "DarenDaPeiCell")
        
        bountyBtn.frame = CGRect(x: frame.size.width - 70, y: SCREEN_H / 2, width: 60, height: 40)
        bountyBtn.setImage(UIImage(named:"btn_wannted"), for: UIControlState())
        bountyBtn.isHidden = true
        contentView.addSubview(bountyBtn)
        
        
//        innerWantView = NSBundle.mainBundle().loadNibNamed("lifeViews", owner: nil, options: nil)[3] as! InnerWantView
//        innerWantView.frame = CGRectMake(0, relatedCollectionView.frame.maxY, frame.size.width, 50)
//        innerWantView.priceLabel.text = "参考价格\n" + String(5000000.0)
//        contentView.addSubview(innerWantView)
        
        arrangeBtn.frame = CGRect(x: 0, y: frame.size.height - 50, width: frame.size.width, height: 50)
        arrangeBtn.backgroundColor = LifeConstant.redFontColor
        arrangeBtn.setTitle("定制专属搭配", for: UIControlState())
        arrangeBtn.setTitleColor(UIColor.white, for: UIControlState())
        arrangeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        arrangeBtn.isHidden = true
        contentView.addSubview(arrangeBtn)
        
        darenHeadTitle.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        darenHeadTitle.text = "达人"
        darenHeadTitle.textColor = UIColor.black
        darenHeadTitle.font = UIFont.boldSystemFont(ofSize: 18)
        darenHeadTitle.textAlignment = .center
        darenHeadTitle.center.y = topView.frame.size.height * CGFloat(0.5) + 10
        darenHeadTitle.center.x = topView.center.x
        topView.addSubview(darenHeadTitle)
        
        tuanGouWantView = Bundle.main.loadNibNamed("lifeViews", owner: nil, options: nil)![5] as! TuanGouView
        tuanGouWantView.frame = CGRect(x: 0, y: frame.size.height - 50, width: frame.size.width, height: 50)
        contentView.addSubview(tuanGouWantView)
    }
    
    func setButtonsEnable(_ isTrue:Bool){
//        innerWantView.likeButton.enabled = isTrue
//        innerWantView.collectButton.enabled = isTrue
//        innerWantView.priceLabel.hidden = !isTrue
//        innerWantView.commentButton.enabled = isTrue
//        innerWantView.likeButton.enabled = isTrue
//        innerWantView.wantButton.enabled = isTrue
        
        likeButton.isEnabled = isTrue
        collectButton.isEnabled = isTrue
        commentBtn.isEnabled = isTrue
        bountyBtn.isHidden = !isTrue
        shareBtn.isEnabled = isTrue
        tuanGouWantView.iWant.isEnabled = isTrue
        
    }
    
    func setViewsHidden(_ isHiden:Bool){
        shareBtn.isHidden = isHiden
        commentBtn.isHidden = isHiden
        collectButton.isHidden = isHiden
        likeButton.isHidden = isHiden
    }
    
    func setViews(){
        if model.isDaren {
            relatedCollectionView.frame.size.height = frame.height - 64 - 50
            setViewsHidden(true)
            arrangeBtn.isHidden = false
            darenHeadTitle.isHidden = false
            tuanGouWantView.isHidden = true
            return
        }else if model.isTuanGou == true{
            relatedCollectionView.frame.size.height = frame.height - 64 - 50
            setViewsHidden(false)
            arrangeBtn.isHidden = true
            darenHeadTitle.isHidden = true
            tuanGouWantView.isHidden = false
        }else{
            relatedCollectionView.frame.size.height = frame.height - 64
            setViewsHidden(false)
            arrangeBtn.isHidden = true
            darenHeadTitle.isHidden = true
            tuanGouWantView.isHidden = true
        }
    }
    
//    func setDataForLifeInnerCell(vc:UIViewController,index:Int,model:LifeModel){
//        
//    }
    //MARK:内页
    func setControlsInSecondStep(){

//        setButtonsEnable(true)
        
//        innerWantView.likeButton.tag = index
//        innerWantView.likeButton.addTarget(vc, action: #selector(LifeInnerController.like(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//        if model.islike == 0{
//            innerWantView.likeButton.selected = false
//        }else{
//            innerWantView.likeButton.selected = true
//        }
//        
//        innerWantView.collectButton.tag = index
//        innerWantView.collectButton.addTarget(vc, action: #selector(LifeInnerController.collect(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//        if model.iscollect == 0{
//            innerWantView.collectButton.selected = false
//        }else{
//            innerWantView.collectButton.selected = true
//        }
//        
//        if model.reference_price != 0.0{
//            innerWantView.priceLabel.hidden = false
//            innerWantView.priceLabel.text = "参考价格\n" + String(model.reference_price)
//        }else{
//            innerWantView.priceLabel.hidden = true
//        }
//        
//        innerWantView.commentButton.tag = index
//        innerWantView.commentButton.addTarget(vc, action: #selector(LifeInnerController.comment(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//        
//        switch model.wantType {
//        case 0:
//            innerWantView.wantButton.setTitle("我想要", forState: UIControlState.Normal)
//        case 1:
//            innerWantView.wantButton.setTitle("购买", forState: UIControlState.Normal)
//        case 2:
//            innerWantView.wantButton.setTitle("阅读", forState: UIControlState.Normal)
//        case 3:
//            innerWantView.wantButton.setTitle( String(model.wantNum) + "人想要", forState: UIControlState.Normal)
//        default:
//            break
//        }
//        
//        innerWantView.wantButton.tag = index
//        innerWantView.wantButton.addTarget(vc, action:  #selector(LifeInnerController.takeAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        if model.isSet == false{
            setButtonsEnable(false)
            return
        }
        
        setButtonsEnable(true)
        
        
        if model.islike == 0{
            likeButton.isSelected = false
        }else{
            likeButton.isSelected = true
        }
        

        if model.iscollect == 0{
            collectButton.isSelected = false
        }else{
            collectButton.isSelected = true
        }
        
        bountyBtn.removeTarget(nil, action: nil, for: .allEvents)
        switch model.wantType {
        //购买
        case 1:
            bountyBtn.setImage(UIImage(named:"btn_bay"), for: UIControlState())
            bountyBtn.tag = index
            bountyBtn.addTarget(vc, action: #selector(LifeInnerController.buy(_:)), for: UIControlEvents.touchUpInside)
//            vc?.initBuyTip()
//        case 4:
//            bountyBtn.setImage(UIImage(named:"btn_wannted"), forState: UIControlState.Normal)
//            bountyBtn.tag = index
//            bountyBtn.addTarget(vc, action: #selector(LifeInnerController.bounty(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//            vc?.initBountyTip()
        default:
            bountyBtn.isHidden = true
            break
        }
        
        if model.isTuanGou == true {
            tuanGouWantView.priceLabel.text = "¥\(model.goodsPrice)"
            if model.groupbuyStatus == 1 {
                tuanGouWantView.renShuLabel.text = "还差\(model.remainNum)人想要参团"
            }else if  model.groupbuyStatus == 2 {
                tuanGouWantView.renShuLabel.text = "已有\(model.paidNum)人参团"
            }else{
                tuanGouWantView.renShuLabel.text = ""
            }
            
        }
    }
    //MARK:初始设置
    func setControlsInFirstStep(){
        relatedCollectionView.dataSource = vc
        relatedCollectionView.delegate = vc
        relatedCollectionView.tag = index
        waterfallLayout.delegate = vc
        waterfallLayout.index = index
        contentView.addSubview(relatedCollectionView)
        contentView.bringSubview(toFront: bountyBtn)
        
        backBtn.addTarget(vc, action: #selector(LifeInnerController.back), for: UIControlEvents.touchUpInside)
        shareBtn.tag = index
        shareBtn.addTarget(vc, action: #selector(LifeInnerController.share(_:)), for: UIControlEvents.touchUpInside)
        
        commentBtn.tag = index
        commentBtn.addTarget(vc, action: #selector(LifeInnerController.comment(_:)), for: UIControlEvents.touchUpInside)
        
        likeButton.tag = index
        likeButton.addTarget(vc, action: #selector(LifeInnerController.like(_:)), for: UIControlEvents.touchUpInside)
        
        collectButton.tag = index
        collectButton.addTarget(vc, action: #selector(LifeInnerController.collect(_:)), for: UIControlEvents.touchUpInside)
        
        arrangeBtn.tag = index
        arrangeBtn.addTarget(vc, action: #selector(LifeInnerController.arrange(_:)), for: UIControlEvents.touchUpInside)
        
        relatedCollectionView.reloadData()
        relatedCollectionView.contentOffset.y = 0
        
        if model.isTuanGou == true {
            tuanGouWantView.iWant.tag = index
            tuanGouWantView.iWant.addTarget(vc, action: #selector(LifeInnerController.want(_:)), for: UIControlEvents.touchUpInside)
        }
        
        setViews()
    }
    
    //引导页
    func initTip(_ key:String,imageName:String){
        if let tipIV = TipView(frame: UIScreen.mainScreen().bounds, key: key) {
            tipIV.backgroundColor = UIColor(red: 75/255.0, green: 75/255.0, blue: 75/255.0, alpha: 0.5)
            let imageViewWidth = SCREEN_W
            let iv = UIImageView(frame: CGRect(x: 200, y: SCREEN_H/2 + 70 - imageViewWidth/1.5, width: imageViewWidth, height: imageViewWidth/1.5))
            iv.image = UIImage(named: imageName)
            iv.center.x = SCREEN_W / 2
            tipIV.addSubview(iv)
            tipIV.b.frame = CGRect(x: 200, y: iv.frame.maxY, width: 150, height: 75)
            tipIV.b.center.x = SCREEN_W / 2
            tipIV.layer.zPosition = 10000
            //            let window = UIApplication.sharedApplication().keyWindow
            self.contentView.addSubview(tipIV)
        }
    }
    
//    func initBountyTip(){
//        initTip(TipView.MyBountyTipKey, imageName: "G5")
//    }
    
//    func initBuyTip(){
//        initTip(TipView.MyBuyTipKey, imageName: "G4")
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

