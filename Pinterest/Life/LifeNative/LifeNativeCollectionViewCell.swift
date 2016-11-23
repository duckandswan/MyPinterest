//
//  LifeNativeCollectionViewCell.swift
//  finding
//
//  Created by bob song on 16/9/20.
//  Copyright © 2016年 zhangli. All rights reserved.
//

import UIKit

class LifeNativeCollectionViewCell: UICollectionViewCell {
    var relatedCollectionView:UICollectionView!
    let waterfallLayout = WaterFlowViewLayout()
    var index:Int = -1
    weak var vc:LifeNativeViewController?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        relatedCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), collectionViewLayout: waterfallLayout)
        relatedCollectionView.backgroundColor = LifeConstant.mainBackgroundColor
        relatedCollectionView.alwaysBounceVertical = true
        relatedCollectionView.showsVerticalScrollIndicator  = true
    
        relatedCollectionView.register(LifeCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    func setRelatedCollectionView(){
        relatedCollectionView.dataSource = vc
        relatedCollectionView.delegate = vc
        relatedCollectionView.tag = index
        waterfallLayout.delegate = vc
        waterfallLayout.index = index
        contentView.addSubview(relatedCollectionView)
        
        relatedCollectionView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
