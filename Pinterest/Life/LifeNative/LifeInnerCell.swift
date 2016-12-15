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
    var relatedCollectionView:MyRefreshCollectionView!
//    var innerWantView:InnerWantView!
    let waterfallLayout = WaterFlowViewLayout()
    var backBtn = UIButton()
    
    var likeButton = UIButton()
    var collectButton = UIButton()
    var shareBtn = UIButton()
    var commentBtn = UIButton()
    
    var bountyBtn = UIButton()
//    
//    var arrangeBtn = UIButton()
//    
//    let darenHeadTitle = UILabel()
    
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
        backBtn.addTarget(vc, action: Selector(("back")), for: .touchUpInside)
        
        let lineView: UIView = UIView(frame: CGRect(x: 0, y: topView.frame.maxY - 1, width: SCREEN_W, height: 1))
        lineView.backgroundColor = LifeConstant.mainBackgroundColor
        topView.addSubview(lineView)
        
        
        relatedCollectionView = MyRefreshCollectionView(frame: CGRect(x: 0, y: 64, width: frame.width, height: frame.height - 64), collectionViewLayout: waterfallLayout)
        relatedCollectionView.backgroundColor = LifeConstant.mainBackgroundColor
        relatedCollectionView.alwaysBounceVertical = true
        relatedCollectionView.showsVerticalScrollIndicator  = false
        
        
        relatedCollectionView.register(LifeCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        relatedCollectionView.register(InnerTopCell.self, forCellWithReuseIdentifier: "HeadCell")
        
        bountyBtn.frame = CGRect(x: frame.size.width - 70, y: SCREEN_H / 2, width: 60, height: 40)
        bountyBtn.setImage(UIImage(named:"btn_wannted"), for: UIControlState())
        bountyBtn.isHidden = true
        contentView.addSubview(bountyBtn)
        
        
//        innerWantView = NSBundle.mainBundle().loadNibNamed("lifeViews", owner: nil, options: nil)[3] as! InnerWantView
//        innerWantView.frame = CGRectMake(0, relatedCollectionView.frame.maxY, frame.size.width, 50)
//        innerWantView.priceLabel.text = "参考价格\n" + String(5000000.0)
//        contentView.addSubview(innerWantView)
        
//        arrangeBtn.frame = CGRect(x: 0, y: frame.size.height - 50, width: frame.size.width, height: 50)
//        arrangeBtn.backgroundColor = LifeConstant.redFontColor
//        arrangeBtn.setTitle("定制专属搭配", for: UIControlState())
//        arrangeBtn.setTitleColor(UIColor.white, for: UIControlState())
//        arrangeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
//        arrangeBtn.isHidden = true
//        contentView.addSubview(arrangeBtn)
//        
//        darenHeadTitle.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
//        darenHeadTitle.text = "达人"
//        darenHeadTitle.textColor = UIColor.black
//        darenHeadTitle.font = UIFont.boldSystemFont(ofSize: 18)
//        darenHeadTitle.textAlignment = .center
//        darenHeadTitle.center.y = topView.frame.size.height * CGFloat(0.5) + 10
//        darenHeadTitle.center.x = topView.center.x
//        topView.addSubview(darenHeadTitle)
    }
    
    func setButtonsEnable(_ isTrue:Bool){
        likeButton.isEnabled = isTrue
        collectButton.isEnabled = isTrue
        commentBtn.isEnabled = isTrue
        bountyBtn.isHidden = !isTrue
        shareBtn.isEnabled = isTrue
    }
    
//    func setViews(){
//        relatedCollectionView.frame.size.height = frame.height - 64
//        setViewsHidden(false)
//    }

    //MARK:内页
    func setControlsInSecondStep(){

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
        bountyBtn.isHidden = true
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
        
        relatedCollectionView.reloadData()
        relatedCollectionView.contentOffset.y = 0
        
//        setViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

