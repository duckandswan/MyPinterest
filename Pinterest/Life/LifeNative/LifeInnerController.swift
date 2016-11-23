//
//  LifeInnerController.swift
//  finding
//
//  Created by bob song on 16/3/11.
//  Copyright © 2016年 zhangli. All rights reserved.
//

import UIKit

class LifeInnerController: LifeCommonController, UICollectionViewDataSource, UICollectionViewDelegate, WaterFlowViewLayoutDelegate, RewardViewDelegate{
    
    var delegate:LifeCommonController!
    
    var currentIndex = 0
    
    //    var lifeCollectionView:UICollectionView!
    
    var mainCollectionView:UICollectionView!
    
    func addLifeDatas(_ model:LifeModel){
        let lifeData = LifeData()
        lifeData.storyId = model.storyCollectionId
        if model.isDaren{
            lifeData.isDaren = true
            lifeData.masterId = model.masterId
        }
        lifeDatas.append(lifeData)
    }
    
    
    deinit{
        removeObserver()
        print("life inner has been removed!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        initMainCollectionView()
        
        for m in delegate.mainLifeData.lifeModels {
//            let lifeData = LifeData()
//            lifeData.storyId = m.storyCollectionId
//            lifeDatas.append(lifeData)
            addLifeDatas(m)
        }
        
        addObserver()
        
        // Do any additional setup after loading the view.
    }
    
    func initTip(_ key:String,imageName:String){
        if let tipIV = TipView(frame: UIScreen.mainScreen().bounds, key: key) {
            let imageViewWidth = SCREEN_W - 60
            let iv = UIImageView(frame: CGRect(x: 200, y: SCREEN_H / 2 + 40 - imageViewWidth/1.5, width: imageViewWidth, height: imageViewWidth/1.5))
            iv.image = UIImage(named: imageName)
            iv.center.x = SCREEN_W / 2 + 30
            tipIV.addSubview(iv)
            tipIV.b.frame = CGRect(x: 200, y: iv.frame.maxY, width: 150, height: 75)
            tipIV.b.center.x = SCREEN_W / 2
            //            let window = UIApplication.sharedApplication().keyWindow
            self.view.addSubview(tipIV)
        }
    }
    
    func initBountyTip(){
        initTip(TipView.MyBountyTipKey, imageName: "G5")
    }
    
    func initBuyTip(){
        initTip(TipView.MyBuyTipKey, imageName: "G4")
    }
    
    func initMainCollectionView(){
//        let statusBarckView = UIView(frame: CGRect(x: 0, y: -1 * UIApplication.sharedApplication().statusBarFrame.size.height, width: UIScreen.mainScreen().bounds.size.width, height: UIApplication.sharedApplication().statusBarFrame.size.height))
//        statusBarckView.backgroundColor = Constants.naviBgColor
        
//        view.addSubview(statusBarckView)
        
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
        
        hideNavigationBar()
        hideTabBar()
        
        BaiduMobStat.defaultStat().pageviewEndWithName("看生活内页")
        MobClick.endLogPageView("看生活内页")
        
        
        resumePlayer()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        BaiduMobStat.defaultStat().pageviewEndWithName("看生活内页")
        MobClick.endLogPageView("看生活内页")
        
        pausePlayer()
        
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
            collectionView?.gifFooter?.noticeNoMoreData()
            lifeData.isEnd = true
        }else{
            lifeData.pageNo += 1
        }
        
        if lifeData.isDaren{
            for item in arr{
                let model = DarenMasterModel()
                model.setValueForDic(item as! NSDictionary)
                lifeData.darenModels.append(model)
            }
            
            collectionView?.insertItemsToSection(1)
            return
        }
        
        for item in arr{
            let model = LifeModel()
            model.setValueForDic(item as! NSDictionary)
            lifeInner?.addLifeDatas(model)
            
            lifeData.lifeModels.append(model)
        }
        
        collectionView?.insertItemsToSection(1)
    
        if lifeInner?.isViewLoaded == true {
            lifeInner?.mainCollectionView.insertItemsToSection(0)
        }
        

        
    }
    
    //MARK:获取数据
    func getDataFromServer(_ collectionView:UICollectionView?,index:Int){
        
        let lifeData = lifeDatas[index]
        
        if lifeData.canRequest == false{
            return
        }else{
            lifeData.canRequest = false
        }
        
        if lifeData.isEnd == true {
            collectionView?.gifFooter?.noticeNoMoreData()
            return
        }
        
        var params:[String:AnyObject] = ["pageNo":lifeData.pageNo,"pageSize":lifeData.pageSize,"storyCollectionId":lifeData.storyId]
        var url = RequestURL.REQUEST_LIFE_RELATED
        if let maxId  = lifeData.lifeModels.last?.storyCollectionId {
            params["maxId"] = maxId
        }
        
        if lifeData.isDaren {
            url = RequestURL.REQUEST_MASTER_INFO
            params = ["pageNo":lifeData.pageNo,"pageSize":lifeData.pageSize,"masterId":lifeData.masterId,"userId":Constants.CURRENT_USER_ID]
            
            if lifeData.pageNo > 1{
                if let minId = lifeData.darenModels.last?.id {
                    params["minId"] = minId
                }
            }
        }

        NetKit.sharedInstance.doPostRequest(url, params:params, successClosure:
            { (bodyData) in
                
                if lifeData.isDaren {
                    if let arr = (bodyData as? NSDictionary)?.dicArrForKey("caseList") {
                        self.parseDataFromArr(arr,collectionView:collectionView,index:index)
                    }
                }else{
                    if let arr = bodyData as? [NSDictionary] {
                        self.parseDataFromArr(arr,collectionView:collectionView,index:index)
                    }
                }
                
                self.endRefresh(collectionView,index: index)
                
            }, failClosure: {
                self.endRefresh(collectionView,index: index)
            },noDataClosure:{
                
        })
        
    }
    
    func endRefresh(_ collectionView:UICollectionView?,index:Int){
        if collectionView?.tag == index{
            collectionView?.footer?.endRefreshing()
        }
        let lifeData = lifeDatas[index]
        lifeData.canRequest = true
    }
    
    override func footerRefreshData(){
        getDataFromServer(lifeCollectionView,index: currentIndex)
    }
    
    func arrForJsonString(_ str:NSString)->[NSDictionary]{
        let data = str.data(using: String.Encoding.utf8)
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
                if lifeData.isDaren {
                    return lifeData.darenModels.count
                }else{
                    return lifeData.lifeModels.count
                }
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
            
            if model.isTuanGou == true && model.isDaren == false{
                cell.relatedCollectionView.removeFooter()
            }else{
                cell.relatedCollectionView.addFooterRefresh({
                    [weak self,weak cv = cell.relatedCollectionView] in
                    self?.getDataFromServer(cv, index: cell.relatedCollectionView.tag)
                    })
                
                if lifeData.isEnd == true{
                    cell.relatedCollectionView.gifFooter.noticeNoMoreData()
                }
                
                if lifeData.lifeModels.count == 0 && lifeData.isEnd == false{
                    getDataFromServer(cell.relatedCollectionView, index: cell.relatedCollectionView.tag)
                }
            }
            
            //获取内页数据
            if model.isDaren == false{
                if model.isSet == false{
                    cell.setButtonsEnable(false)
                    print("model.storyCollectionId: \(model.storyCollectionId)")
                    
                    
                    let params:[String : AnyObject] = ["userId":Constants.CURRENT_USER_ID,"storyCollectionId":model.storyCollectionId]
                    
                    NetKit.sharedInstance.doPostRequest(RequestURL.REQUEST_LIFE_STORY_DETAIL, params:params, successClosure:
                        { (bodyData) in
                            
                            if let bodyDic = bodyData as? NSDictionary {
                                model.setValueForDicInSecondStep(bodyDic)
                                if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? LifeInnerCell{
                                    cell.setControlsInSecondStep()
                                    if let topCell = cell.relatedCollectionView.cellForItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? InnerTopCell{
                                        topCell.setControlsInSecondStep()
                                    }
                                    
                                    if model.contentList.count > 0{
                                        cell.relatedCollectionView.reloadAllSections()
                                    }
                                }
                            }else{
                                print("内页数据结构错误")
 
                            }
                            
                        }, failClosure: {
                            print("内页获取失败")
                        },noDataClosure:{
                            
                    })
                    
                }else{
                    cell.setControlsInSecondStep()
                }
            }
            
            if indexPath.row == delegate.mainLifeData.lifeModels.count - 7{
                delegate.footerRefreshData()
            }
            
            return cell
        }else{
            if indexPath.section == 1 {
                
                let index = collectionView.tag
                let lifedata = lifeDatas[index]
                
                
                if lifedata.isDaren {
                    let model = lifedata.darenModels[indexPath.row]
                    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DarenDaPeiCell", forIndexPath: indexPath) as! DarenDaPeiCell
                    cell.setData(model)
                    if indexPath.row == lifeDatas[index].lifeModels.count - 7{
                        getDataFromServer(collectionView, index: index)
                    }
                    return cell
                }else{
                    let lifeModel = lifedata.lifeModels[indexPath.row]
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LifeCollectionViewCell
                    cell.setData(lifeModel)
                    if indexPath.row == lifeDatas[index].lifeModels.count - 7{
                        getDataFromServer(collectionView, index: index)
                    }
                    return cell
                }
            }else{
                let index = collectionView.tag
                let model = delegate.mainLifeData.lifeModels[index]
                
                if model.isDaren {
                    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DarenTopCell", forIndexPath: indexPath) as! DarenTopCell
                    cell.index = index
                    cell.model = model
                    cell.vc = self
                    cell.setData()
                    return cell
                }else{
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeadCell", for: indexPath) as! InnerTopCell
                    cell.index = index
                    cell.model = model
                    cell.vc = self
                    cell.setData()
                    return cell
                }
            }
        }
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == self.mainCollectionView{
            if indexPath.row == currentPlayIndex{
                releasePlayer()
            }
        }
    }
    
    var currentWaterfallLayout:WaterFlowViewLayout!
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let index = collectionView.tag
            let lifeData = lifeDatas[index]
            if lifeData.isDaren {
                print("达人跳转")
                let index = collectionView.tag
                let model = lifeDatas[index].darenModels[indexPath.row]
                var url = Constants.MATCH_DETAIL_H5_URL
                url += "?caseId=\(model.id)"
                let args = ["title":"搭配详情", "url":url, "action":"share", "rightType" : "image", "right":"share"]
                MyScriptHandler.navigate(self, args: args)
            }else{
                mainLifeData = lifeDatas[collectionView.tag]
                lifeCollectionView = collectionView
                currentIndex = collectionView.tag
                
                let innerCell = mainCollectionView.cellForItem(at: IndexPath(row: collectionView.tag, section: 0)) as! LifeInnerCell
                currentWaterfallLayout = innerCell.waterfallLayout
                
                let cell = collectionView.cellForItem(at: indexPath) as! LifeCollectionViewCell
                
                presentLifeInner(cell, index: indexPath.row)
            }
        }
    }
    
    func waterFlowViewLayout(_ waterFlowViewLayout: WaterFlowViewLayout, heightForWidth: CGFloat, indextPath: IndexPath) -> CGFloat {
        let index = waterFlowViewLayout.index
        if indextPath.section == 1{
            let lifeData = lifeDatas[index]
            if lifeData.isDaren {
                return lifeData.darenModels[indextPath.row].height
            }else{
                return lifeData.lifeModels[indextPath.row].height
            }
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
    
    func follow(_ b:UIButton){
        
        if !DocumentUtil.haveLogin(){
            DocumentUtil.logIn(self,animated: false)
            return
        }
        b.isEnabled = false
        
        let index = b.tag
        let model = delegate.mainLifeData.lifeModels[index]
        
        
        let params:[String : AnyObject] = ["userId":Constants.CURRENT_USER_ID, "watchUserId":model.userId]
        NetKit.sharedInstance.doPostRequest((b.selected==false ? RequestURL.REQUEST_USER_WATCH_URL : RequestURL.REQUEST_CANCLE_GZ_URL), params:params, successClosure:
            { (bodyData) in
                
                if bodyData is NSDictionary {
                    model.isfans = 1
                    b.selected = true
                }else{
                    model.isfans = 0
                    b.selected = false
                }
                b.enabled = true
                
            }, failClosure: {
                print("关注失败！")
                b.enabled = true
            },noDataClosure:{
                
        })
        
        
    }
    
    func guess(_ b:UIButton){
        let index = b.tag
        let model = delegate.mainLifeData.lifeModels[index]
        
        print("guess: \(model.storyCollectionId)")
        
        
        let uwantVC = UWantViewController()
        uwantVC.storyCollectionId = String(model.storyCollectionId)
        self.navigationController?.pushViewController(uwantVC, animated: true)
    }
    
    func headTap(_ ges:UserIdTapGestureRecognizer){
        MyScriptHandler.toUserPage(self, userId: String(ges.userId))
    }
    
    func share(_ b:UIButton){
        let index = b.tag
        let model = delegate.mainLifeData.lifeModels[index]
        let url = Constants.LIFE_SHARE_H5_URL + String(model.storyCollectionId)
        let imageUrl = model.collectionImgArr[0]
        b.isEnabled = false
        MyScriptHandler.share(self, title: model.collectionName, content: model.content, url: url,imageUrl: imageUrl, closure: {
            b.enabled = true
        })
    }
    
    func read(_ b:UIButton){
        let index = b.tag
        let model = delegate.mainLifeData.lifeModels[index]
        if model.user_type == 0{
            let args = ["title":"文章", "url":model.article_url, "action":"", "rightType" : "", "right":""]
//            MyScriptHandler.shareInstance.navigateToInternal(self, args: args,method: "navigateToInternal")
            MyScriptHandler.navigate(self, args: args)
        }else{
            MyScriptHandler.toUserPage(self, userId: String(model.userId))
        }
        
    }
    //MARK:喜欢
    func like(_ b:UIButton){
        if !DocumentUtil.haveLogin(){
            DocumentUtil.logIn(self,animated: false)
            return
        }
        
        let index = b.tag
        let model = delegate.mainLifeData.lifeModels[index]
        b.isEnabled = false
        
        let params:[String : AnyObject] = ["userId":Constants.CURRENT_USER_ID, "collectionId":model.storyCollectionId]
        
        NetKit.sharedInstance.doPostRequest(RequestURL.REQUEST_LIKE_STORY, params:params, successClosure:
            { (bodyData) in
                
                if let dic = bodyData as? NSDictionary{
                    let result = dic.intForKey("result")
                    let likecount = dic.intForKey("likecount")
                    model.likeSize = likecount
                    if result == 0{
                        model.islike = 0
                        b.selected = false
                    }else if result == 1{
                        model.islike = 1
                        b.selected = true
                    }
                }
                
                let cell = self.mainCollectionView.visibleCells()[0] as! LifeInnerCell
                
                if let topCell = cell.relatedCollectionView.cellForItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? InnerTopCell{
                    //                    topCell.likeButton.setTitle(String(model.likeSize), forState: UIControlState.Normal)
                    //                topCell.configInfoView(model.likeSize,replySize: model.replySize)
                    topCell.configInfoView()
                }
                
                b.enabled = true
                
            }, failClosure: {
                print("点赞失败！")
                b.enabled = true
            },noDataClosure:{
                
        })
    }
    
    func collect(_ b:UIButton){
        if !DocumentUtil.haveLogin(){
            DocumentUtil.logIn(self,animated: false)
            return
        }
        
        let index = b.tag
        let model = delegate.mainLifeData.lifeModels[index]
        b.isEnabled = false
        
        
        let params:[String : AnyObject] = ["userId":Constants.CURRENT_USER_ID, "sourceId":model.storyCollectionId]
        
        NetKit.sharedInstance.doPostRequest(RequestURL.REQUEST_USER_COLLECTION_STORY, params:params, successClosure:
            { (bodyData) in
                
                if let str = bodyData as? String{
                    if str == "收藏成功" {
                        model.iscollect = 1
                        b.selected = true
                        MBProgressHUD.showSuccess("收藏成功", toView: self.view)
                    }else if str == "取消收藏成功" {
                        model.iscollect = 0
                        b.selected = false
                        MBProgressHUD.showSuccess("取消收藏", toView: self.view)
                    }
                    
                }
                b.enabled = true
                
            }, failClosure: {
                print("收藏失败！")
                b.enabled = true
            },noDataClosure:{
                
        })
    }
    //MARK:-RewardView 悬赏
    func bounty(_ b:UIButton){
        
        let index = b.tag
        let model = delegate.mainLifeData.lifeModels[index]
        
        print("bounty: \(model.storyCollectionId)")
        
        let rewardView = RewardView.init(frame: CGRect(x: 0, y: 0, width: Width, height: Height),storyId: String(model.storyCollectionId))
        rewardView.delegate = self
        rewardView.showInView(self)
        
        pausePlayer()
    }
    
    //MARK:RewardViewDelegate
    func rewardViewClosed(){
        resumePlayer()
    }
    
    //MARK:buy
    func buy(_ b:UIButton){
        let index = b.tag
        let model = delegate.mainLifeData.lifeModels[index]
        
        print("buy: \(model)")
        var url = ""
        if model.sponsored_url_type == 0{
            url = Constants.H5_IP + (model.sponsored_url as NSString).substringFromIndex(1)
        }else{
            url = model.sponsored_url
        }
        let args = ["title":model.goods_title, "url":url, "action":"", "rightType" : "", "right":""]
         MyScriptHandler.navigate(self, args: args)
    }
    
    //MARK:搭配
    func arrange(_ b:UIButton){
        let index = b.tag
        let model = delegate.mainLifeData.lifeModels[index]
        
        print("buy: \(model)")
        let args = ["title":"定制专属搭配", "url":model.masterUrl, "action":"", "rightType" : "", "right":""]
        MyScriptHandler.navigate(self, args: args)
    }
    //MARK:评论
    func comment(_ b:UIButton){
        let index = b.tag
        let model = delegate.mainLifeData.lifeModels[index]
        HttpSingleton.shareInstance().queryLifeCommentListData("", storyCollectionId: String(model.storyCollectionId), vc: self)
    }
    
    //MARK: 刷新
    func refreshTopCell(){
//        if let cell = self.mainCollectionView.visibleCells().first as? LifeInnerCell{
//            let model = delegate.mainLifeData.lifeModels[cell.index]
//            
//            let successClosure:((body:AnyObject) -> Void) = {  (body) in
//                if let dic = body as? NSDictionary{
//                    model.setAskForDic(dic)
//                    if let topCell = cell.relatedCollectionView.cellForItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? InnerTopCell{
//                        topCell.setGuessViewContent()
//                    }
//                }
//            }
//            let failureClosure = {
//                print("猜你想重刷失败！")
//            }
//            SomeUtils.request(Constants.REQUEST_LIFE_STORY_DETAIL, pamams:["userId":Constants.CURRENT_USER_ID, "collectionId":model.storyCollectionId], successClosure:successClosure, failureClosure:failureClosure)
//        }
    }
    
    
    //MARK：播放
    var currentPlayIndex:Int = -1
    
    let reachability = Reachability.reachabilityForInternetConnection()
    func play(_ b:UIButton){
        print("play video")
        
        //3.判断网络状态
        let status = reachability.currentReachabilityStatus()
        switch status {
        case .ReachableViaWiFi:
            //                self.errorMsg("wifi连接下,可以播放")
            break
        case .ReachableViaWWAN:
            self.errorMsg("非wifi连接下播放")
        //                return
        case .NotReachable:
            self.errorMsg("网络有问题")
            return
        }
        
        let index = b.tag
        let model = delegate.mainLifeData.lifeModels[index]
        
        if model.videoType == 1{
            print("VR播放")
            let storyboard:UIStoryboard = UIStoryboard.init(name: "Player", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("PlayerViewController") as! PlayerViewController
            
            
            
            self.presentViewController(vc, animated: false) {
                vc.initParams(URL.init(string: model.videoUrl))
            }
            
            return
        }
        
        let cell = self.mainCollectionView.visibleCells[0] as! LifeInnerCell
        
        LifeConstant.player?.removeFromSuperview()
        
        currentPlayIndex = index
        
        if let topCell = cell.relatedCollectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? InnerTopCell{
            print("video url: \(model.videoUrl)")
            LifeConstant.player = HTPlayer(frame: topCell.iView.bounds, videoURLStr:model.videoUrl)
            //            LifeConstant.player = HTPlayer(frame: topCell.iView.bounds, videoURLStr: "http://flv2.bn.netease.com/videolib3/1605/05/dGhJO3809/SD/dGhJO3809-mobile.mp4")
            
            topCell.iView.addSubview(LifeConstant.player!)
            topCell.iView.bringSubviewToFront(LifeConstant.player!)
        }
        
    }
    
    func addObserver(){
        NotificationCenter.defaultCenter().addObserver(self, selector: #selector(LifeInnerController.fullScreenBtnClick(_:)), name: kHTPlayerFullScreenBtnNotificationKey, object: nil)
        NotificationCenter.defaultCenter().addObserver(self, selector: #selector(LifeInnerController.checkNetworkStatus(_:)), name: kReachabilityChangedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LifeInnerController.guessSend(_:)), name: "GuessSendSuccess", object: nil)
        reachability.startNotifier()
    }
    
    func removeObserver(){
        NotificationCenter.defaultCenter().removeObserver(self, name: kHTPlayerFullScreenBtnNotificationKey, object: nil)
        NotificationCenter.defaultCenter().removeObserver(self, name: kReachabilityChangedNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: "GuessSendSuccess", object: nil)
    }
    
    func guessSend(_ notice:Notification){
        refreshTopCell()
    }
    
    func checkNetworkStatus(_ notice:Notification){
        let status = reachability.currentReachabilityStatus()
        switch status {
        case .ReachableViaWiFi:
            //            self.errorMsg("wifi连接下,可以播放")
            break
        case .ReachableViaWWAN:
//            self.errorMsg("非wifi连接下播放")
            MBProgressHUD.showError("非wifi连接下播放", toView: self.view)
            //            releasePlayer()
        //            return
        case .NotReachable:
            MBProgressHUD.showError("网络有问题", toView: self.view)
//            self.errorMsg("网络有问题")
        }
    }
    
    var isStatusBarHidden = false
    func fullScreenBtnClick(_ notice:Notification){
        let b = notice.object as! UIButton
        print("full screen")
        if b.isSelected == true{
            LifeConstant.player?.toFullScreenWithInterfaceOrientation(UIInterfaceOrientation.LandscapeRight)
            isStatusBarHidden = true
            setNeedsStatusBarAppearanceUpdate()
        }else{
            //            LifeConstant.player.toSmallScreen()
            toCell()
            isStatusBarHidden = false
            setNeedsStatusBarAppearanceUpdate()
        }
        
        
    }
    
    func toSmall(){
        if LifeConstant.player?.isPlaying() == true{
            LifeConstant.player?.toSmallScreen()
        }
        
    }
    
    func toCell(){
        if let cell = self.mainCollectionView?.visibleCells.first as? LifeInnerCell{
            if let topCell = cell.relatedCollectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? InnerTopCell{
                //            topCell.iView.addSubview(LifeConstant.player)
                //            topCell.iView.bringSubviewToFront(LifeConstant.player)
                LifeConstant.player?.reductionWithInterfaceOrientation(topCell.iView)
            }
        }
    }
    
    func autoPlay(_ index:Int){
        let model = delegate.mainLifeData.lifeModels[index]
        if model.videoUrl == "" {
            return
        }
        
        //3.判断网络状态
        let status = reachability.currentReachabilityStatus()
        switch status {
        case .ReachableViaWiFi:
            //            self.errorMsg("wifi连接下自动播放")
            break
        case .ReachableViaWWAN:
//            self.errorMsg("非wifi连接下点击播放")
            MBProgressHUD.showMessage("非wifi连接下点击播放", toView: self.view)
            return
        case .NotReachable:
            MBProgressHUD.showError("网络有问题", toView: self.view)
//            self.errorMsg("网络有问题")
            return
        }
        
        let b = UIButton()
        b.tag = index
        play(b)
    }
    
    func releasePlayer(){
        LifeConstant.player?.releaseWMPlayer()
    }
    
    var needResume = false
    func pausePlayer(){
        if LifeConstant.player?.isPlaying() == true {
            LifeConstant.player?.pause()
            needResume = true
        }
    }
    
    func resumePlayer(){
        if needResume == true{
            LifeConstant.player?.resume()
            needResume = false
        }
    }
    
    
    override var prefersStatusBarHidden : Bool {
        return isStatusBarHidden
    }
    
    //MARK: 我想要，阅读，购买。
    func want(_ b:UIButton){
        let index = b.tag
        let model = delegate.mainLifeData.lifeModels[index]

        if !DocumentUtil.haveLogin(){
            DocumentUtil.logIn(self,animated: false)
            return
        }
        
        
//        return -2;//用户不存在
//        return -3;//团购商品不存在
//        return -4;//不是团购商品
//        return -5;//团购商品待上线
//        return -6;//团购商品已下架
        
        //用户已经想要
        if model.userWanted != 0{
            var url = ""
            url =  model.sponsored_url
            let args = ["title":model.goods_title, "url":url, "action":"", "rightType" : "", "right":""]
            MyScriptHandler.navigate(self, args: args)
            return
        }
        
        b.isEnabled = false
        
        let params:[String : AnyObject] = ["userId":Constants.CURRENT_USER_ID, "goodsId":model.goodsId]
        NetKit.sharedInstance.doPostRequest(RequestURL.REQUEST_I_WANT, params:params, successClosure:
            { (bodyData) in
                
                let n = (bodyData as? Int) ?? 0
                
                switch n {
                case 1,-1:
                    var url = ""
                    url =  model.sponsored_url
                    let args = ["title":model.goods_title, "url":url, "action":"", "rightType" : "", "right":""]
                    MyScriptHandler.navigate(self, args: args)
                case -6:
                    MBProgressHUD.showError("团购商品已下架", toView: rootController.view)
                default:
                    MBProgressHUD.showError("有错误", toView: rootController.view)
                }
                b.enabled = true
                
            }, failClosure: {
                MBProgressHUD.showError("有错误", toView: rootController.view)
                b.enabled = true
            },noDataClosure:{
                
        })
        
        
    }

    
    //MARK: 我想要，阅读，购买。
//    func takeAction(b:UIButton){
//        let index = b.tag
//        let model = delegate.mainLifeData.lifeModels[index]
//        
//        switch model.wantType {
//        case 0:
//            if !DocumentUtil.haveLogin(){
//                DocumentUtil.logIn(self,animated: false)
//                return
//            }
//            
//            let index = b.tag
//            let model = delegate.mainLifeData.lifeModels[index]
//            b.enabled = false
//            
//            print("model.storyCollectionId: \(model.storyCollectionId)")
//            print("Constants.CURRENT_USER_ID: \(Constants.CURRENT_USER_ID)")
//            
//            LifeConstant.manager.request(.POST,Constants.REQUEST_COLLECTION_WANT, parameters: ["userId":Constants.CURRENT_USER_ID, "storyCollectionId":model.storyCollectionId]).responseJSON {
//                (r) -> Void in
//            let result = r.result
//                if result.isSuccess && ((result.value as! NSDictionary).valueForKey("code") as! String) == Constants.ROMOTE_REQUEST_SUCCESS{
//                    print("want result.value \(result.value as! NSDictionary)")
//                    model.wantNum += 1
//                    b.setTitle( String(model.wantNum) + "人想要", forState: UIControlState.Normal)
//                    model.wantType = 3
//                    b.enabled = false
//                }else{
//                    print("点赞失败！")
//                    b.enabled = true
//                }
//            }
//        case 1:
//            //            let url = Constants.H5_IP + (model.sponsored_url as NSString).substringFromIndex(1)
//            let url = model.sponsored_url
//            let args = ["title":model.goods_title, "url":url, "action":"", "rightType" : "", "right":""]
//            MyScriptHandler.shareInstance.navigateToInternal(self, args: args,method: "navigateToInternal")
//        case 2:
//            let args = ["title":"文章", "url":model.article_url, "action":"", "rightType" : "", "right":""]
//            MyScriptHandler.shareInstance.navigateToInternal(self, args: args,method: "navigateToInternal")
//        default:
//            break
//            
//        }
//        
//        
//    }
    
    func toLikeList(_ b:UIButton){
        let index = b.tag
        let model = delegate.mainLifeData.lifeModels[index]
        let url = Constants.H5_IP + "finding/favouriteuser.html?story=\(model.storyCollectionId)&userId=\(Constants.CURRENT_USER_ID)"
        let args = ["title":"喜欢列表", "url":url, "action":"", "rightType" : "", "right":""]
//        MyScriptHandler.shareInstance.navigateToInternal(self, args: args,method: "navigateToInternal")
         MyScriptHandler.navigate(self, args: args)
    }
    
    //MARK:图片点击
    func clickPhoto(_ sender:ImageClickTapGestureRecognizer){
//        let index = sender.index
//        let model = delegate.mainLifeData.lifeModels[index]
        let viewController = PhotoBrowsingController()
        viewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        viewController.startPage = sender.page
//        viewController.images = model.collectionImgArr
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
        
        releasePlayer()
        
        let cell = mainCollectionView.visibleCells[0] as! LifeInnerCell
        let indexPath = mainCollectionView.indexPath(for: cell)!
        
        delegate.desFrame = delegate.frameForIndex(indexPath.row)
//        delegate.backIndex = indexPath.row
//        delegate.lifeCollectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: indexPath.row, inSection: 1), atScrollPosition: .Top, animated: false)
        
        let window = UIApplication.shared.keyWindow!
        
        if let topCell = cell.relatedCollectionView.cellForItemAtIndexPath(IndexPath(forRow: 0, inSection: 0)) as? CommonCollectionViewCell{
            
            let frame = topCell.contentView.convertRect(topCell.iView.frame, toView: window)
            
            if frame.maxY > 64{
                delegate.transView = topCell.iView.snapshotViewAfterScreenUpdates(true)
                delegate.transView!.frame = frame
            }else{
                delegate.transView = nil
            }
        }else{
            delegate.transView = nil
        }
        self.navigationController?.delegate = delegate
        self.delegate.lifeInner = nil
        navigationController?.popViewController(animated: true)
        
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
        
        if let cell = self.mainCollectionView.visibleCells.first as? LifeInnerCell{
            let model = delegate.mainLifeData.lifeModels[cell.index]
            if model.sponsored_url != "" {
                if (scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height) + 25){
                    setBottomUpPush()
//                    self.want(cell.tuanGouWantView.iWant)
                    var url = ""
                    url =  model.sponsored_url
                    let args = ["title":model.goods_title, "url":url, "action":"", "rightType" : "", "right":""]
                    MyScriptHandler.navigate(self, args: args)
                }
            }
        }
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
        MBProgressHUD.showError("没有数据了", toView: self.view)
    }
    
}




