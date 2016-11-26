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
    
//    var sceneId:String?
    
    var logString = "看生活"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initHeadBarAndLifeCollectionView()
        initUrlAndParameter()
        
        getDataFromServer()
    }
    

    
    //MARK: -即将显示
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

    }
    
    //MARK: - 已经消失
    override func viewDidDisappear(_ animated: Bool) {

    }
    
    func initHeadBarAndLifeCollectionView(){
        initHeadBar(name: tagName)
        lifeCollectionView.frame = CGRect(x:0, y:64, width:view.frame.width, height:SCREEN_H - 64)
    }
    
    var tagName = "工艺"
    var tagId:Int = 0
    
    func initUrlAndParameter(){
        lifeUrlString = "http://api.finding.com/api/life/index"
        
        params["tagId"] = tagId as AnyObject?

    }
    
}

