//
//  LifeWaterFlowViewController.swift
//  finding
//
//  Created by bob song on 16/5/11.
//  Copyright © 2016年 zhangli. All rights reserved.
//

import UIKit

class LifeWaterFlowViewController: LifeCommonController, UICollectionViewDataSource, UICollectionViewDelegate, WaterFlowViewLayoutDelegate{
    
    //    var lifeCollectionView:UICollectionView!
    
    let waterfallLayout = WaterFlowViewLayout()
    var isRefreshing = true
    var params:[String:Any] = [:]
    var lifeUrlString:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        params = ["userId":"0","pageNo":mainLifeData.pageNo,"pageSize":mainLifeData.pageSize]
        //
        initCollectionView()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        
        //                headerRefreshData()
        //        lifeCollectionView.gifHeader.beginRefreshing()
    }
    
    func initCollectionView(){
        
        lifeCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: SCREEN_W, height: SCREEN_H), collectionViewLayout: waterfallLayout)
        
        waterfallLayout.delegate = self
        lifeCollectionView.backgroundColor = LifeConstant.mainBackgroundColor
        lifeCollectionView.alwaysBounceVertical = true
        lifeCollectionView.showsVerticalScrollIndicator  = false
        lifeCollectionView.dataSource = self
        lifeCollectionView.delegate = self
        
        lifeCollectionView.register(LifeCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        view.addSubview(lifeCollectionView)
    }
    
    var canRequest = true
    func headerRefreshData(){
        isRefreshing = true
        mainLifeData.pageNo = 1
        mainLifeData.isEnd = false
        getDataFromServer()
    }
    
    
    override func footerRefreshData(){
        isRefreshing = false
        getDataFromServer()
    }
    
    func endRefresh(){
        //        self.lifeCollectionView.header.endRefreshing()
//        self.lifeCollectionView.gifHeader?.endRefreshing()
//        self.lifeCollectionView.gifFooter?.endRefreshing()
//        canRequest = true
        mainLifeData.canRequest = true
    }
    
    //    override func footerBeginRefreshing() {
    //        lifeCollectionView.gifFooter?.beginRefreshing()
    //    }
    

    
    func getDataFromServer(){
        if mainLifeData.isEnd == true {
            return
        }
        
        if mainLifeData.canRequest == false{
            return
        }

        mainLifeData.canRequest = false
        
        if isRefreshing == false{
            if let maxId  = mainLifeData.lifeModels.last?.storyCollectionId {
                params["maxId"] = maxId
            }
        }
        
        params["pageNo"] = mainLifeData.pageNo
        
        let successClosure: ((_ body:AnyObject) -> Void) = {
            (bodyData) in
            self.endRefresh()
            if let arr = self.arrFromBody(bodyData){
                print("arr.count: \(arr.count)")
                
                if self.isRefreshing == true && arr.count == 0{
                    self.lifeCollectionView.addNoDataDefaultImageView(isadd: true)
                }
                self.parseDataFromArr(arr as NSArray)
                
            }
        }
        let failureClosure: (() -> Void) = {
            self.endRefresh()
        }
        let nullClosure: (() -> Void) = {
            if self.isRefreshing == true{
                self.lifeCollectionView.addNoDataDefaultImageView(isadd: true)
            }
            self.endRefresh()
        }
        
        LifeUtils.request(url: lifeUrlString, pamams: params, successClosure: successClosure, failureClosure: failureClosure, nullClosure: nullClosure)
        
//        NetKit.sharedInstance.doPostRequest(lifeUrlString, params:params, successClosure:
//            { (bodyData) in
//                
//                self.endRefresh()
//                if let arr = self.arrFromBody(bodyData){
//                    print("arr.count: \(arr.count)")
//                    
//                    if self.isRefreshing == true && arr.count == 0{
//                        self.lifeCollectionView.addNoDataDefaultImageView(true)
//                    }
//                    self.parseDataFromArr(arr)
//                    
//                }
//            }, failClosure: {
//                self.endRefresh()
//            },noDataClosure:{
//                if self.isRefreshing == true{
//                    self.lifeCollectionView.addNoDataDefaultImageView(true)
//                }
//                self.endRefresh()
//        })
    }
    
    
    
    func arrFromBody(_ body:AnyObject)->[NSDictionary]?{
        return body.value(forKey: "storyHotList") as? [NSDictionary]
    }
    
    func arrForJsonString(_ str:NSString)->[NSDictionary]{
        let data = str.data(using: String.Encoding.utf8.rawValue)
        let obj = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
        return (obj as! [NSDictionary])
    }
    
    func parseDataFromArr(_ arr:NSArray){
        
        if arr.count < mainLifeData.pageSize {
            mainLifeData.isEnd = true
        }else{
            mainLifeData.pageNo += 1
        }
        
        if isRefreshing == true{
            mainLifeData.lifeModels = []
        }
        
        
//        var indexPathArr:[NSIndexPath] = []
//        var innerIndexPathArr:[NSIndexPath] = []
        
        for item in arr{
            let model = LifeModel()
            //            print("item :\(item)")
            model.setValueForDic(item as! NSDictionary)
//            model.setH()
//            let count = mainLifeData.lifeModels.count
//            indexPathArr.append(NSIndexPath(forRow: count, inSection: 1))
//            innerIndexPathArr.append(NSIndexPath(forRow: count, inSection: 0))
            mainLifeData.lifeModels.append(model)
            
            let lifeData = LifeData()
            lifeData.storyId = model.storyCollectionId
            lifeInner?.lifeDatas.append(lifeData)
            lifeDatas.append(lifeData)
            
        }
        
        if isRefreshing == true{
            isRefreshing = false
            lifeCollectionView.reloadData()
            if lifeInner?.isViewLoaded == true {
                lifeInner?.mainCollectionView.reloadData()
            }
        }else{
            lifeCollectionView.insertItemsTo(section: 1)
            
            if lifeInner?.isViewLoaded == true {
                lifeInner?.mainCollectionView.insertItemsTo(section: 0)
            }
        }
        
        print("lifeModels.count: \(mainLifeData.lifeModels.count)")
        
    }

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1{
            return mainLifeData.lifeModels.count
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LifeCollectionViewCell
            cell.setData(mainLifeData.lifeModels[indexPath.row])
            if indexPath.row == mainLifeData.lifeModels.count - 7{
//                lifeCollectionView.gifFooter?.beginRefreshing()
                getDataFromServer()
            }
            return cell
            
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LifeCollectionViewCell
            return cell
        }
        
    }
    
    func waterFlowViewLayout(_ waterFlowViewLayout: WaterFlowViewLayout, heightForWidth: CGFloat, indextPath: IndexPath) -> CGFloat {
        if indextPath.section == 1{
            //            print("lifeModels[indextPath.row].height\(indextPath.row): \(lifeModels[indextPath.row].height)")
            return mainLifeData.lifeModels[indextPath.row].height
        }else{
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
        }else{
            
            let cell = collectionView.cellForItem(at: indexPath) as! LifeCollectionViewCell
            let index = indexPath.row
            
            presentLifeInner(cell, index: index)
            
        }
        
    }
    
    func back(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
