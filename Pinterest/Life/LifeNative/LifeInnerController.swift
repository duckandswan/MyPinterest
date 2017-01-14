//
//  LifeInnerController.swift
//  finding
//
//  Created by bob song on 16/3/11.
//  Copyright © 2016年 zhangli. All rights reserved.
//

import UIKit

class LifeInnerController: LifeCommonController, UICollectionViewDataSource, UICollectionViewDelegate, WaterFlowViewLayoutDelegate{
    
    var delegate:LifeCommonController!
    
    var currentIndex = 0
    
    //    var lifeCollectionView:UICollectionView!
    
    var mainCollectionView:UICollectionView!
    
    func addLifeDatas(_ model:LifeModel){
        let lifeData = LifeData()
        lifeData.storyId = model.storyCollectionId
        lifeDatas.append(lifeData)
    }
    
    
    deinit{
        print("life inner has been removed!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        initMainCollectionView()
        
        for m in delegate.mainLifeData.lifeModels {
            addLifeDatas(m)
        }
    }
    
    func initMainCollectionView(){
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        
        mainCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), collectionViewLayout: flowLayout)
        
        mainCollectionView.isPagingEnabled = true
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
        mainCollectionView.register(LifeInnerCell.self, forCellWithReuseIdentifier: "LifeInnerCell")
        
        mainCollectionView.alwaysBounceHorizontal = true
        
        view.addSubview(mainCollectionView)
        
        mainCollectionView.scrollToItem(at: IndexPath(row: currentIndex, section: 0), at: .left, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Parse
    func parseDataFromArr(_ arr:NSArray,collectionView:UICollectionView?,index:Int){
        
        let lifeData = lifeDatas[index]
        
        if arr.count < lifeData.pageSize {
            lifeData.isEnd = true
            (collectionView as? MyRefreshCollectionView)?.isNoData = true
        }else{
            lifeData.pageNo += 1
        }
        
        for item in arr{
            let model = LifeModel()
            model.setValueForDic(item as! NSDictionary)
            lifeInner?.addLifeDatas(model)
            
            lifeData.lifeModels.append(model)
        }
        
        collectionView?.insertItemsTo(section: 1)
    
        if lifeInner?.isViewLoaded == true {
            lifeInner?.mainCollectionView.insertItemsTo(section: 0)
        }
        
    }
    
    //MARK:获取数据
    func getDataFromServer(_ collectionView:UICollectionView?){
        guard let index = collectionView?.tag else{
            return
        }
        
        let lifeData = lifeDatas[index]
        
//        if lifeData.canRequest == false{
//            return
//        }else{
//            lifeData.canRequest = false
//        }
        
        lifeData.status = (collectionView as! MyRefreshCollectionView).status
        
//        if lifeData.isEnd == true {
//            return
//        }
        
        var params:[String:Any] = ["pageNo":lifeData.pageNo,"pageSize":lifeData.pageSize,"storyCollectionId":lifeData.storyId]
        let url = "http://api.finding.com/api/storycollection/related"
        if let maxId  = lifeData.lifeModels.last?.storyCollectionId {
            params["maxId"] = maxId
        }
        
        let successClosure: ((_ body:AnyObject) -> Void) = {
            (bodyData) in
            self.endRefresh(collectionView,index: index)
            if let arr = bodyData as? [NSDictionary] {
                self.parseDataFromArr(arr as NSArray,collectionView:collectionView,index:index)
            }
        }
        let failureClosure: (() -> Void) = {
            self.endRefresh(collectionView,index: index)
        }
        let nullClosure: (() -> Void) = {
            self.endRefresh(collectionView,index: index)
            lifeData.isEnd = true
            (collectionView as? MyRefreshCollectionView)?.isNoData = true
        }
        
        LifeUtils.request(url: url, pamams: params, successClosure: successClosure, failureClosure: failureClosure, nullClosure: nullClosure)

//        NetKit.sharedInstance.doPostRequest(url, params:params, successClosure:
//            { (bodyData) in
//                
//                if lifeData.isDaren {
//                    if let arr = (bodyData as? NSDictionary)?.dicArrForKey("caseList") {
//                        self.parseDataFromArr(arr,collectionView:collectionView,index:index)
//                    }
//                }else{
//                    if let arr = bodyData as? [NSDictionary] {
//                        self.parseDataFromArr(arr,collectionView:collectionView,index:index)
//                    }
//                }
//                
//                self.endRefresh(collectionView,index: index)
//                
//            }, failClosure: {
//                self.endRefresh(collectionView,index: index)
//            },noDataClosure:{
//                
//        })
        
    }
    
    func endRefresh(_ collectionView:UICollectionView?,index:Int){
        if collectionView?.tag == index{
            (collectionView as? MyRefreshCollectionView)?.endMyRefresh()
        }
        let lifeData = lifeDatas[index]
//        lifeData.canRequest = true
        lifeData.status = .idle
    }
    
    func load(sender:UIActivityIndicatorView) {
        let collectionView = sender.superview as! UICollectionView
        getDataFromServer(collectionView)
    }
    
    override func footerRefreshData(){
        lifeCollectionView.beginMyFooterLoad()
    }
    
    func arrForJsonString(_ str:NSString)->[NSDictionary]{
        let data = str.data(using: String.Encoding.utf8.rawValue)
        let obj = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
        return (obj as! [NSDictionary])
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if collectionView == self.mainCollectionView{
            return 1
        }else{
            return 2
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.mainCollectionView{
            return delegate.mainLifeData.lifeModels.count
        }else{
            if section == 1 {
                let index = collectionView.tag
                let lifeData = lifeDatas[index]
//                if lifeData.isDaren {
//                    return lifeData.darenModels.count
//                }else{
//                    return lifeData.lifeModels.count
//                }
                return lifeData.lifeModels.count
            }else{
                return 1
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.mainCollectionView{
            
            let index = indexPath.row
            let model = delegate.mainLifeData.lifeModels[index]
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LifeInnerCell", for: indexPath) as! LifeInnerCell
            cell.index = index
            cell.model = model
            cell.vc = self
            
            cell.setControlsInFirstStep()
            
            let lifeData = lifeDatas[index]
            
//            cell.relatedCollectionView.addFooterRefresh(block: {
//                [weak self,weak cv = cell.relatedCollectionView] in
//                self?.getDataFromServer(cv)
//            })
            
            cell.relatedCollectionView.addMyFooterLoad(obj: self, action: #selector(LifeInnerController.load(sender:)))
            
            cell.relatedCollectionView.set(sta: lifeData.status)
            
            if lifeData.isEnd == true{
                cell.relatedCollectionView.isNoData = true
            }
            
            if lifeData.lifeModels.count == 0 && lifeData.isEnd == false{
//                getDataFromServer(cell.relatedCollectionView)
                cell.relatedCollectionView.beginMyFooterLoad()
            }
            
//            if model.isTuanGou == true && model.isDaren == false{
//                cell.relatedCollectionView.removeFooter()
//            }else{
//                cell.relatedCollectionView.addFooterRefresh({
//                    [weak self,weak cv = cell.relatedCollectionView] in
//                    self?.getDataFromServer(cv, index: cell.relatedCollectionView.tag)
//                    })
//                
//                if lifeData.isEnd == true{
//                    cell.relatedCollectionView.gifFooter.noticeNoMoreData()
//                }
//                
//                if lifeData.lifeModels.count == 0 && lifeData.isEnd == false{
//                    getDataFromServer(cell.relatedCollectionView, index: cell.relatedCollectionView.tag)
//                }
//            }
            
            //获取内页数据
//            if model.isDaren == false{
//                if model.isSet == false{
//                    cell.setButtonsEnable(false)
//                    print("model.storyCollectionId: \(model.storyCollectionId)")
//                    
//                    
//                    let params:[String : AnyObject] = ["userId":Constants.CURRENT_USER_ID,"storyCollectionId":model.storyCollectionId]
//                    
//                    NetKit.sharedInstance.doPostRequest(RequestURL.REQUEST_LIFE_STORY_DETAIL, params:params, successClosure:
//                        { (bodyData) in
//                            
//                            if let bodyDic = bodyData as? NSDictionary {
//                                model.setValueForDicInSecondStep(bodyDic)
//                                if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? LifeInnerCell{
//                                    cell.setControlsInSecondStep()
//                                    if let topCell = cell.relatedCollectionView.cellForItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? InnerTopCell{
//                                        topCell.setControlsInSecondStep()
//                                    }
//                                    
//                                    if model.contentList.count > 0{
//                                        cell.relatedCollectionView.reloadAllSections()
//                                    }
//                                }
//                            }else{
//                                print("内页数据结构错误")
// 
//                            }
//                            
//                        }, failClosure: {
//                            print("内页获取失败")
//                        },noDataClosure:{
//                            
//                    })
//                    
//                }else{
//                    cell.setControlsInSecondStep()
//                }
//            }
            
            if model.isSet == false{
                cell.setButtonsEnable(false)
                print("model.storyCollectionId: \(model.storyCollectionId)")
                
                let url = "http://api.finding.com/api/storycollection/getStoryDetail"
                let params:[String : Any] = ["userId":0,"storyCollectionId":model.storyCollectionId]
                
                let successClosure: ((_ body:AnyObject) -> Void) = {
                    (bodyData) in
                    if let bodyDic = bodyData as? NSDictionary {
                        model.setValueForDicInSecondStep(bodyDic)
                        if let cell = collectionView.cellForItem(at: indexPath) as? LifeInnerCell{
                            cell.setControlsInSecondStep()
                            if let topCell = cell.relatedCollectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? InnerTopCell{
                                topCell.setControlsInSecondStep()
                            }
                        }
                    }else{
                        print("内页数据结构错误")
                        
                    }
                }
                let failureClosure: (() -> Void) = {

                }
                let nullClosure: (() -> Void) = {

                }
                
                LifeUtils.request(url: url, pamams: params, successClosure: successClosure, failureClosure: failureClosure, nullClosure: nullClosure)
//                
//                NetKit.sharedInstance.doPostRequest(RequestURL.REQUEST_LIFE_STORY_DETAIL, params:params, successClosure:
//                    { (bodyData) in
//                        
//                        if let bodyDic = bodyData as? NSDictionary {
//                            model.setValueForDicInSecondStep(bodyDic)
//                            if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? LifeInnerCell{
//                                cell.setControlsInSecondStep()
//                                if let topCell = cell.relatedCollectionView.cellForItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? InnerTopCell{
//                                    topCell.setControlsInSecondStep()
//                                }
//                                
//                                if model.contentList.count > 0{
//                                    cell.relatedCollectionView.reloadAllSections()
//                                }
//                            }
//                        }else{
//                            print("内页数据结构错误")
//                            
//                        }
//                        
//                }, failClosure: {
//                    print("内页获取失败")
//                },noDataClosure:{
//                    
//                })
                
            }else{
                cell.setControlsInSecondStep()
            }
            
            if indexPath.row == delegate.mainLifeData.lifeModels.count - LifeCollectionViewCell.requestNumber{
//                delegate.footerRefreshData()
            }
            
            return cell
        }else{
            if indexPath.section == 1 {
                
                let index = collectionView.tag
                let lifedata = lifeDatas[index]
                
                let lifeModel = lifedata.lifeModels[indexPath.row]
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LifeCollectionViewCell
                cell.setData(lifeModel)
                if indexPath.row == lifeDatas[index].lifeModels.count - LifeCollectionViewCell.requestNumber{
//                    getDataFromServer(collectionView)
                }
                return cell
//                if lifedata.isDaren {
//                    let model = lifedata.darenModels[indexPath.row]
//                    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DarenDaPeiCell", forIndexPath: indexPath) as! DarenDaPeiCell
//                    cell.setData(model)
//                    if indexPath.row == lifeDatas[index].lifeModels.count - 7{
//                        getDataFromServer(collectionView, index: index)
//                    }
//                    return cell
//                }else{
//                    let lifeModel = lifedata.lifeModels[indexPath.row]
//                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LifeCollectionViewCell
//                    cell.setData(lifeModel)
//                    if indexPath.row == lifeDatas[index].lifeModels.count - 7{
//                        getDataFromServer(collectionView, index: index)
//                    }
//                    return cell
//                }
            }else{
                let index = collectionView.tag
                let model = delegate.mainLifeData.lifeModels[index]
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeadCell", for: indexPath) as! InnerTopCell
//                cell.index = index
//                cell.model = model
//                cell.vc = self
//                cell.setData()
                cell.setDate(index: index, model: model, vc: self)
                return cell
//                if model.isDaren {
//                    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DarenTopCell", forIndexPath: indexPath) as! DarenTopCell
//                    cell.index = index
//                    cell.model = model
//                    cell.vc = self
//                    cell.setData()
//                    return cell
//                }else{
//                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeadCell", for: indexPath) as! InnerTopCell
//                    cell.index = index
//                    cell.model = model
//                    cell.vc = self
//                    cell.setData()
//                    return cell
//                }
            }
        }
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == self.mainCollectionView{
        }
    }
    
    var currentWaterfallLayout:WaterFlowViewLayout!
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
//            let index = collectionView.tag
//            let lifeData = lifeDatas[index]
            mainLifeData = lifeDatas[collectionView.tag]
            lifeCollectionView = collectionView as! MyRefreshCollectionView
            currentIndex = collectionView.tag
            
            let innerCell = mainCollectionView.cellForItem(at: IndexPath(row: collectionView.tag, section: 0)) as! LifeInnerCell
            currentWaterfallLayout = innerCell.waterfallLayout
            
            let cell = collectionView.cellForItem(at: indexPath) as! LifeCollectionViewCell
            
            presentLifeInner(cell, index: indexPath.row)
//            if lifeData.isDaren {
//                print("达人跳转")
//                let index = collectionView.tag
//                let model = lifeDatas[index].darenModels[indexPath.row]
//                var url = Constants.MATCH_DETAIL_H5_URL
//                url += "?caseId=\(model.id)"
//                let args = ["title":"搭配详情", "url":url, "action":"share", "rightType" : "image", "right":"share"]
//                MyScriptHandler.navigate(self, args: args)
//            }else{
//                mainLifeData = lifeDatas[collectionView.tag]
//                lifeCollectionView = collectionView
//                currentIndex = collectionView.tag
//                
//                let innerCell = mainCollectionView.cellForItem(at: IndexPath(row: collectionView.tag, section: 0)) as! LifeInnerCell
//                currentWaterfallLayout = innerCell.waterfallLayout
//                
//                let cell = collectionView.cellForItem(at: indexPath) as! LifeCollectionViewCell
//                
//                presentLifeInner(cell, index: indexPath.row)
//            }
        }
    }
    
    func waterFlowViewLayout(_ waterFlowViewLayout: WaterFlowViewLayout, heightForWidth: CGFloat, indextPath: IndexPath) -> CGFloat {
        let index = waterFlowViewLayout.index
        if indextPath.section == 1{
            let lifeData = lifeDatas[index]
            return lifeData.lifeModels[indextPath.row].height
//            if lifeData.isDaren {
//                return lifeData.darenModels[indextPath.row].height
//            }else{
//                return lifeData.lifeModels[indextPath.row].height
//            }
        }else{
            return delegate.mainLifeData.lifeModels[index].bigHeight
        }
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        if collectionView == self.mainCollectionView {
            return UIScreen.main.bounds.size
        }else{
            return CGSize.zero
        }
        
    }
    
    
    func leap(_ b:UIButton) {
        print("b.tag: \(b.tag)")
        let innerTagController = InnerTagController()
        innerTagController.tagName = b.titleLabel!.text!
        innerTagController.tagId = b.tag
        let navi = UINavigationController(rootViewController: innerTagController)
        self.present(navi, animated: true, completion: nil)
    }
    
    //MARK:图片点击
    func clickPhoto(_ sender:ImageClickTapGestureRecognizer){
        let viewController = PhotoBrowsingController()
        viewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        viewController.startPage = sender.page
         viewController.images = sender.images
        viewController.imageViews = sender.imageViews
        navigationController?.delegate = viewController
        
        if let image = sender.iv.image{
            let window = UIApplication.shared.keyWindow
            let frame = sender.iv.convert(sender.iv.bounds, to: window)
            let iv = UIImageView(frame: frame)
            iv.contentMode = .scaleAspectFill
            iv.image = image
            viewController.transView = iv
            viewController.desFrame = LifeUtils.aspectFitFrameForFrame(PhotoBrowsingController.photoFrame, size: image.size)
            
        }
        
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    
    func back() {
        
        let cell = mainCollectionView.visibleCells[0] as! LifeInnerCell
        let indexPath = mainCollectionView.indexPath(for: cell)!
        
        delegate.desFrame = delegate.frameForIndex(indexPath.row)
        
        let window = UIApplication.shared.keyWindow!
        
        if let topCell = cell.relatedCollectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? CommonCollectionViewCell{
            
            let frame = topCell.contentView.convert(topCell.iView.frame, to: window)
            
            if frame.maxY > 64{
                delegate.transView = topCell.iView.snapshotView(afterScreenUpdates: true)
                delegate.transView!.frame = frame
            }else{
                delegate.transView = nil
            }
        }else{
            delegate.transView = nil
        }
        self.navigationController?.delegate = delegate
        self.delegate.lifeInner = nil
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //        print("scrollView.contentOffset.y: \(scrollView.contentOffset.y)")
        //下拉退出
        if scrollView.contentOffset.y < -45{
            back()
        }
        
        if (scrollView.contentOffset.x / UIScreen.main.bounds.width) > CGFloat(delegate.mainLifeData.lifeModels.count - 1){
            //没有数据
            if delegate.mainLifeData.isEnd == true{
                giveTip()
                return
            }
            delegate.footerRefreshData()
        }
        
//        if scrollView != mainCollectionView {
//            if scrollView.contentOffset.y > scrollView.contentSize.height - SCREEN_H + 45{
//                getDataFromServer(scrollView as? UICollectionView)
//            }
//        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView === mainCollectionView{
            //            print("mainCollectionView")
            return
        }
        
        let offset = scrollView.contentOffset
        if let cell = self.mainCollectionView.visibleCells.first as? LifeInnerCell{
            let model = delegate.mainLifeData.lifeModels[cell.index]
            if (model.relatedHeight - offset.y - cell.bountyBtn.frame.size.height) <= SCREEN_H / 2{
                cell.bountyBtn.frame.origin.y = model.relatedHeight - offset.y - cell.bountyBtn.frame.size.height
            }
        }
        
    }
    
    func giveTip(){

    }
    
}




