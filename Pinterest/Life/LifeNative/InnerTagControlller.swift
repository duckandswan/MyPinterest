//
//  InnerTagControlller.swift
//  finding
//
//  Created by bob song on 16/3/25.
//  Copyright © 2016年 zhangli. All rights reserved.
//

import UIKit

class InnerTagController: LifeWaterFlowViewController {
    
//    var lifeCollectionView:UICollectionView!
    
    var sceneId:String?
    
    var logString = "看生活"
    
//    var hotModel:LifeHotModel = LifeHotModel()
    
//    let waterfallLayout = WaterFlowViewLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = tagName

        initUrlAndParameter()
    }
    

    
    //MARK: -即将显示
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

    }
    
    //MARK: - 已经消失
    override func viewDidDisappear(_ animated: Bool) {

    }
    
    var tagName = "工艺"
    var tagId:Int?
    
    func initUrlAndParameter(){
        lifeUrlString = RequestURL.REQUEST_LIFE
        
        if let id = tagId{
            params["tagId"] = id
        }
        
        if let id = sceneId {
            params["sceneId"] = id
        }
        
        lifeCollectionView.gifHeader.beginRefreshing()
    }
    
}

