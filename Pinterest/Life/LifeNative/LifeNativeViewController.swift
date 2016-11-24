//
//  LifeNativeViewController.swift
//  finding
//
//  Created by bob song on 16/3/7.
//  Copyright © 2016年 zhangli. All rights reserved.
//

import UIKit

class LifeNativeViewController: LifeCommonController, UICollectionViewDataSource, UICollectionViewDelegate, WaterFlowViewLayoutDelegate , UISearchBarDelegate, UICollectionViewDelegateFlowLayout{
    
    var lifeCategoryArr:[LifeCategoryModel] = []
    
    var categoryView:CategoryCollectionView!
    var mainCollectionView:UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        initCategoryView()
        
        initMainCollectionView()

        getCategoryData()
        
    }
    
    
    //MARK: -即将显示
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //设置头部Bar不可见 底部Bar可见
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    //MARK: - 即将消失
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    //MARK:初始化分类
    func initCategoryView(){
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
//        flowLayout.itemSize = CGSize(width: SCREEN_W / 6, height: 44)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        
        categoryView = CategoryCollectionView(frame: CGRect(x: 0, y: 20, width: SCREEN_W, height: 44), collectionViewLayout: flowLayout)
        
        categoryView.dataSource = self
        categoryView.delegate = self
        
        categoryView.register(CategoryCell.self, forCellWithReuseIdentifier: "Cate")
        categoryView.backgroundColor = UIColor.white
        categoryView.showsHorizontalScrollIndicator = false
        view.addSubview(categoryView)
        
//        categoryView.contentInset.left = 10
    }
    
    func initMainCollectionView(){
        //        let statusBarckView = UIView(frame: CGRect(x: 0, y: -1 * UIApplication.sharedApplication().statusBarFrame.size.height, width: UIScreen.mainScreen().bounds.size.width, height: UIApplication.sharedApplication().statusBarFrame.size.height))
        //        statusBarckView.backgroundColor = Constants.naviBgColor
        
        //        view.addSubview(statusBarckView)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = CGSize(width: view.frame.width, height: SCREEN_H - 50 - categoryView.frame.maxY)
        flowLayout.scrollDirection = .horizontal
        
        mainCollectionView = UICollectionView(frame: CGRect(x: 0, y: categoryView.frame.maxY, width: view.frame.width, height: SCREEN_H - 50 - categoryView.frame.maxY), collectionViewLayout: flowLayout)
        
        mainCollectionView.isPagingEnabled = true
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
        mainCollectionView.register(LifeNativeCollectionViewCell.self, forCellWithReuseIdentifier: "BigCell")
        mainCollectionView.backgroundColor = LifeConstant.mainBackgroundColor
        mainCollectionView.alwaysBounceHorizontal = true
        
        for _ in 0..<lifeCategoryArr.count{
            lifeDatas.append(LifeData())
        }

//        print("lifeDatas.count: \(lifeDatas.count) categoryStrings.count: \(categoryStrings.count)")
        
        view.addSubview(mainCollectionView)
    }

    //MARK:分类
    func getCategoryData() {
        
        self.view.addBadNetworkingDefaultImageView(isadd: false)
        let url = "api/tag/catedisplay"
        let params:[String:Any] = ["" : ""]
        let successClosure: ((_ body:AnyObject) -> Void) = {
            (bodyData) in
            let arr = bodyData as! [NSDictionary]
            let m1 = LifeCategoryModel()
            m1.categoryName = "推荐"
            self.lifeCategoryArr = [m1]
            for item in arr {
                let model = LifeCategoryModel()
                model.setValueForDic(item)
                self.lifeCategoryArr.append(model)
            }
            //            self.lifeCategoryArr.popLast()
            //            self.lifeCategoryArr.popLast()
            
            let flowLayout = self.categoryView.collectionViewLayout as! UICollectionViewFlowLayout
            var space:CGFloat = 0
            flowLayout.minimumInteritemSpacing = space
            flowLayout.minimumLineSpacing = space
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: space, bottom: 0, right: space)
            self.categoryView.reloadAllSections()
            //重新布局
            if let layout = self.categoryView.layoutAttributesForItem(at: IndexPath(row:self.lifeCategoryArr.count - 1, section: 0)){
                if (layout.frame.maxX) < SCREEN_W{
                    let flowLayout = self.categoryView.collectionViewLayout as! UICollectionViewFlowLayout
                    space = (SCREEN_W - layout.frame.maxX) / CGFloat(self.lifeCategoryArr.count + 1)
                    flowLayout.minimumInteritemSpacing = space
                    flowLayout.minimumLineSpacing = space
                    flowLayout.sectionInset = UIEdgeInsets(top: 0, left: space, bottom: 0, right: space)
                    self.categoryView.reloadAllSections()
                }
            }
            self.categoryView.addLine()
            self.categoryView.selectInCategoryView(0)
            //看生活内容
            self.lifeDatas = []
            for item in self.lifeCategoryArr{
                let data = LifeData()
                data.storyId = item.categoryId
                self.lifeDatas.append(data)
            }
            self.mainCollectionView.reloadAllSections()
        }
        let failureClosure: (() -> Void) = {
            self.view.addBadNetworkingDefaultImageView(isadd: true, target: self, action: #selector(LifeNativeViewController.getCategoryData))
        }
        LifeUtils.request(url: url, pamams: params, successClosure: successClosure, failureClosure: failureClosure)
    }
    
    func arrForJsonString(_ str:NSString)->[NSDictionary]{
        let data = str.data(using: String.Encoding.utf8.rawValue)
        let obj = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
        return (obj as! [NSDictionary])
    }
    
    //MARK:- UIScrollViewDelegate
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView){
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView != mainCollectionView && scrollView != categoryView {
            lifeDatas[scrollView.tag].yOffset = scrollView.contentOffset.y
        }
        
        if scrollView == mainCollectionView {
            let f = scrollView.contentOffset.x / SCREEN_W
            if f >= 0 && f <= CGFloat(lifeCategoryArr.count - 1){
                categoryView.scrollLineInCategoryView(f)
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == mainCollectionView {
            let row = Int(scrollView.contentOffset.x / SCREEN_W)
            if row >= 0 && row < lifeCategoryArr.count{
                categoryView.selectInCategoryView(row)
            }
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

    }
    
    // MARK: - Parse
    func parseDataFromArr(_ arr:NSArray,collectionView:UICollectionView?,index:Int,isrefresh:Bool = false){
        
        
        
        let lifeData = lifeDatas[index]
        
        if arr.count < lifeData.pageSize {
            lifeData.isEnd = true
        }else{
            lifeData.pageNo += 1
        }
        
        if  isrefresh == true {
            lifeData.lifeModels = []
        }

        
        for item in arr{
            let model = LifeModel()
            
            model.setValueForDic(item as! NSDictionary)
            
            lifeInner?.addLifeDatas(model)
            
            lifeData.lifeModels.append(model)
            
        }
        
        print("before refesh lifeData index \(index): \(lifeData.lifeModels.count)")
        
        if  isrefresh == true {
            collectionView?.reloadAllSections()
        }else{
            collectionView?.insertItemsTo(section: 1)
        }
        
        if lifeInner?.isViewLoaded == true {
            lifeInner?.mainCollectionView.insertItemsTo(section: 0)
        }
        
    }
    
    var choicedMinNum = 0
    var storyMinNum = 0
    
    //MARK:获取数据
    func getDataFromServer(_ collectionView:UICollectionView?, isrefresh:Bool = false){
        
        guard let index = collectionView?.tag else{
            return
        }
        
        let lifeData = lifeDatas[index]
        
        if isrefresh == true{
            lifeData.isEnd = false
        }
        
        if lifeData.canRequest == false{
            return
        }else{
            lifeData.canRequest = false
        }
        
        if lifeData.isEnd == true {
            return
        }
        print("发请求 request for index :\(index)")
        //修正refresh
        var adjustedIsrefresh = isrefresh
        if adjustedIsrefresh == true{
            lifeData.pageNo = 1
        }else{
            //修正下拉刷新的错误
            if lifeData.pageNo == 1 {
                adjustedIsrefresh = true
            }
        }
        
        var params:[String:Any] = ["pageNo":lifeData.pageNo,"pageSize":lifeData.pageSize,"categoryId":lifeData.storyId]
        var url = "api/life/catelist"
        
        if index == 0{
            url = "api/life/recommand"
            params = ["pageNo":lifeData.pageNo, "pageSize":lifeData.pageSize, "userId":"0"]
        }
        
        
        if lifeData.pageNo > 1{
            if index == 0{
                params["choicedMinNum"] = choicedMinNum
                params["storyMinNum"] = storyMinNum
            }else{
                if let minId  = lifeData.lifeModels.last?.sequence_num {
                    params["minId"] = minId
                }
            }
        }
        
        let successClosure: ((_ body:AnyObject) -> Void) = {
            (bodyData) in
            self.endRefresh(collectionView,index: index)
            if index == 0 {
                let dic = bodyData as! NSDictionary
                
                if let dic = dic.value(forKey: "storyList") as? NSDictionary {
                    if let arr = dic.value(forKey: "list") as? [NSDictionary] {
                        self.parseDataFromArr(arr as NSArray,collectionView:collectionView,index:index,isrefresh: adjustedIsrefresh)
                    }
                    self.choicedMinNum = dic.int(forKey: "choicedMinNum")
                    self.storyMinNum = dic.int(forKey: "storyMinNum")
                }
            }else{
                //其他标签
                let dic = bodyData as! NSDictionary
                if let arr = dic.value(forKey: "storyList") as? [NSDictionary] {
                    self.parseDataFromArr(arr as NSArray,collectionView:collectionView,index:index,isrefresh: adjustedIsrefresh)
                }
            }
        }
        let failureClosure: (() -> Void) = {
            self.endRefresh(collectionView,index: index)
        }
        let nullClosure: (() -> Void) = {
            self.endRefresh(collectionView,index: index)
            lifeData.isEnd = true
        }
        
        LifeUtils.request(url: url, pamams: params, successClosure: successClosure, failureClosure: failureClosure, nullClosure: nullClosure)
        
    }
    
    func endRefresh(_ collectionView:UICollectionView?,index:Int){
        print("endRefresh collectionView?.tag:\(collectionView?.tag) index:\(index)")
        if collectionView?.tag == index{
        }else{
            print("not end index: \(index)")
        }
        let lifeData = lifeDatas[index]
        lifeData.canRequest = true
    }
    
    override func footerRefreshData(){
        getDataFromServer(lifeCollectionView)
    }
    
    //MARK:-  UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == categoryView || collectionView == mainCollectionView {
            return 1
        }else{
            return 2
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryView {
            return lifeCategoryArr.count
        }else{
            if collectionView == mainCollectionView{
                return lifeDatas.count
            }else{
                if section == 1 {
                    let index = collectionView.tag
                    return lifeDatas[index].lifeModels.count
                }else{
                    return 0
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cate", for: indexPath) as! CategoryCell
            cell.l.text = lifeCategoryArr[indexPath.row].categoryName
            if indexPath.row == categoryView.selectedIndex {
                cell.toSelected()
            }else{
                cell.toDeselected()
            }
            return cell
        }else{
            
            if collectionView == self.mainCollectionView{

                let index = indexPath.row

                let lifeData = lifeDatas[index]
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BigCell", for: indexPath) as! LifeNativeCollectionViewCell
                cell.index = index
                cell.vc = self

                cell.setRelatedCollectionView()
                
                cell.relatedCollectionView.gifHeader?.endRefreshing()
 
                cell.relatedCollectionView.addHeaderRefresh({ 
                    [weak self,weak cv = cell.relatedCollectionView] in
                    self?.getDataFromServer(cv, isrefresh: true)
                })
                
                cell.relatedCollectionView.addFooterRefresh({
                    [weak self,weak cv = cell.relatedCollectionView] in
                    self?.getDataFromServer(cv)
                })
                
                if lifeData.isEnd == true{
                    cell.relatedCollectionView.gifFooter.noticeNoMoreData()
                }
                
                //没数据时刷新
                if lifeCategoryArr[index].categoryName == "活动"{
                    if lifeData.activityModels.count == 0 && lifeData.isEnd == false{
                        print("活动 tag:\(cell.relatedCollectionView?.tag)")
                        cell.relatedCollectionView.gifHeader?.beginRefreshing()
                    }
                }else{
                    if lifeData.lifeModels.count == 0 && lifeData.isEnd == false{
                        print("beginRefreshing tag:\(cell.relatedCollectionView?.tag)")
                        cell.relatedCollectionView.gifHeader?.beginRefreshing()
                    }
                }
                
                cell.relatedCollectionView.contentOffset.y = lifeData.yOffset
                
                return cell
            }else{
                if indexPath.section == 1 {
                    
                    let index = collectionView.tag
                    
                    if index == 0{
                        if indexPath.row == 0{
                            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Zhi", for: indexPath) as! ZhiCell
                            LifeUtils.setImageViewForUrl(cell.iv, url: hotModel.hotImg)
                            return cell
                        }else{
                            let lifeModel = lifeDatas[index].lifeModels[indexPath.row - 1]
                            if indexPath.row - 1 == lifeDatas[index].lifeModels.count - 7{
                                getDataFromServer(collectionView)
                            }
                            
                            if lifeModel.isDaren {
                                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DarenCell", forIndexPath: indexPath) as! DarenCollectionViewCell
                                cell.setData(lifeModel)
                                return cell
                            }else{
                                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LifeCollectionViewCell
                                cell.setData(lifeModel)
                                return cell
                            }
                        }
                        
                    }else{
                        let lifeModel = lifeDatas[index].lifeModels[indexPath.row]
                        if indexPath.row == lifeDatas[index].lifeModels.count - 7{
                            getDataFromServer(collectionView)
                        }
                        
                        if lifeModel.isDaren {
                            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DarenCell", forIndexPath: indexPath) as! DarenCollectionViewCell
                            cell.setData(lifeModel)
                            return cell
                        }else{
                            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LifeCollectionViewCell
                            cell.setData(lifeModel)
                            return cell
                        }
                    }
                }else if indexPath.section == 0{
                    let index = collectionView.tag
                    if index == 0 {
                        //推荐
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Ad", for: indexPath) as! AdCell
                        cell.b.addTarget(self, action: #selector(LifeNativeViewController.removeAd(_:)), for: UIControlEvents.touchUpInside)
//                        LifeUtils.setImageViewForUrl(cell.iv, url: adModel.advertImg)
                        cell.iv.sd_setImageWithURL(URL(string: adModel.advertImg.changeImageUrlToUsIp())!, completed: { (img, _, _, _) in
                            if self.adSizeChanged == false{
                                self.adSizeChanged = true
                                self.adHeigth = SCREEN_W * img.size.height / img.size.width
                                if  let cell = self.mainCollectionView.cellForItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? LifeNativeCollectionViewCell{
                                    cell.relatedCollectionView.reloadAllSections()
                                }
                            }
                        })

                        return cell
                    }else if lifeCategoryArr[index].categoryName == "活动"{
                        //活动
                        let model = lifeDatas[index].activityModels[indexPath.row]
                        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Activity", forIndexPath: indexPath) as! LifeActivityCell
                        cell.setData(model)
                        return cell
                    }else{
                        return UICollectionViewCell()
                    }
                }else{
                    return UICollectionViewCell()
                }
            }
        }
    }
    
    
    
    
    
    //    var lifeInner:LifeInnerController!
    
    //    var canInsert = false
    
//    func selectInCategoryView(index: Int){
//        if let cell = categoryView.cellForItemAtIndexPath(NSIndexPath(forRow: selectedIndex, inSection: 0))as? CategoryCell {
//            cell.toDeselected()
//        }
//        
//        if let cell = categoryView.cellForItemAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as? CategoryCell {
//            cell.toSelected()
//        }
//        
//        selectedIndex = index
//        categoryView.scrollToItemAtIndexPath(NSIndexPath(forRow: index, inSection: 0), atScrollPosition: .CenteredHorizontally, animated: true)
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == categoryView {
            categoryView.selectInCategoryView(indexPath.row)
            print("点击第\(indexPath.row)项")
            mainCollectionView.scrollToItem(at: IndexPath(row: indexPath.row, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
        }else{
            
            if collectionView == mainCollectionView {
                
            }else{
                if indexPath.section == 1 {
                    let index = collectionView.tag
                    if index == 0{
                        if indexPath.row == 0{
                            if hotModel.hotUrl != "" {
                                let args = ["title":"Finding·志", "url":(Constants.FINDING_ZHI_H5 + "?userId=" + Constants.CURRENT_USER_ID), "action":"", "rightType" : "", "right":""]
                                MyScriptHandler.navigate(self, args: args)
                            }
                            return
                        }else{
                            mainLifeData = lifeDatas[collectionView.tag]
                            lifeCollectionView = collectionView
                            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CommonCollectionViewCell
                            presentLifeInner(cell, index: indexPath.row - 1)
                        }
                    }else{
                        mainLifeData = lifeDatas[collectionView.tag]
                        lifeCollectionView = collectionView
                        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CommonCollectionViewCell
                        presentLifeInner(cell, index: indexPath.row)
                    }
                }else{
                    let index = collectionView.tag
                    if index == 0{
                        let args = ["title":adModel.advertTitle, "url":adModel.advertUrl, "action":adModel.action, "rightType" : adModel.rightType, "right":adModel.right]
        
                        MyScriptHandler.navigate(self, args: args)
                        Constants.isLifeAdClick = true
                    }else if lifeCategoryArr[index].categoryName == "活动"{
                        let model = lifeDatas[index].activityModels[indexPath.row]
                        let args = ["title":model.activityName, "url":model.activityUrl, "action":"", "rightType" : "", "right":""]
                        MyScriptHandler.navigate(self, args: args)
                    }
                    
                }
            }
        }
        
    }
    
//    override func frameForIndex(index:Int)->CGRect{
////        let iH = mainLifeData.lifeModels[index].imagesH
////        
////        let indexPath = NSIndexPath(forRow: index + 1, inSection: 1)
////        
////        var idx = index + 1
////        if hasAd == true{
////            idx += 1
////        }
////        
////        let layoutAttributes = self.waterfallLayout.layoutAttributes[idx]
////        
////        return frameForCollectionView(self.lifeCollectionView,indexPath: indexPath, iH: iH, layoutAttributes: layoutAttributes)
//        
//        let indexPath = NSIndexPath(forRow: index, inSection: 1)
//        let iH = mainLifeData.lifeModels[index].imagesH
////        let currentWaterfallLayout = lifeCollectionView.layoutAttributesForItemAtIndexPath(indexPath)
////        let layoutAttributes = currentWaterfallLayout.layoutAttributes[index]
////        let layoutAttributes = currentWaterfallLayout.layoutAttributesForItemAtIndexPath(indexPath)!
////        let layoutAttributes = lifeCollectionView.layoutAttributesForItemAtIndexPath(indexPath)!
////        return frameForCollectionView(self.lifeCollectionView,indexPath: indexPath, iH: iH, layoutAttributes: layoutAttributes)
//        return frameForCollectionView(indexPath, iH: iH)
////        return CGRect.zero
//    }
    
//    override func frameForIndex(index:Int)->CGRect{
//        let indexPath = NSIndexPath(forRow: index, inSection: 1)
////        let iH = mainLifeData.lifeModels[index].imagesH
//        let cell = lifeCollectionView.cellForItemAtIndexPath(indexPath) as! CommonCollectionViewCell
//        
//        let rect = cell.contentView.convertRect(cell.iView.frame, toView: rootController.view)
//        return rect
//        
////        let layoutAttributes = currentWaterfallLayout.layoutAttributes[index]
////                let layoutAttributes = currentWaterfallLayout.layoutAttributesForItemAtIndexPath(indexPath)!
////        return frameForCollectionView(self.lifeCollectionView,indexPath: indexPath, iH: iH, layoutAttributes: layoutAttributes)
//        //        return CGRect.zero
//    }
    
//    override func frameForCollectionView(collectionView:UICollectionView,indexPath:NSIndexPath,iH:CGFloat,layoutAttributes:UICollectionViewLayoutAttributes)->CGRect{
//        //        let window = UIApplication.sharedApplication().keyWindow
//        
//        var newFrame = collectionView.convertRect(layoutAttributes.frame, toView: rootController.view)
//        
//        if newFrame.origin.y + iH < 64 || newFrame.origin.y > UIScreen.mainScreen().bounds.size.height - 70{
//            collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Top, animated: false)
//            newFrame = collectionView.convertRect(layoutAttributes.frame, toView: rootController.view)
//        }
//        
//        newFrame.size.height = iH
//        print("newFrame: \(newFrame)")
//        return newFrame
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == mainCollectionView {
            return CGSize(width: view.frame.width, height: SCREEN_H - 50 - categoryView.frame.maxY)
        }else{
            let size =  LifeUtils.calculateSizeForStr(lifeCategoryArr[indexPath.row].categoryName, size: CGSize(width: 500, height: 44), font: UIFont.systemFont(ofSize: CategoryCell.fontSize))
            return CGSize(width: size.width + 10, height: 44)
        }
    }
    
//    var space:CGFloat = 0
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat{
//        if collectionView == mainCollectionView {
//            return 0
//        }else{
//            return space
//        }
//    }
//    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
//        if collectionView == mainCollectionView {
//            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        }else{
//            return UIEdgeInsets(top: 0, left: space, bottom: 0, right: space)
//        }
//    }
    
    
    override func frameForIndex(_ index:Int)->CGRect{
        if lifeCollectionView.tag == 0{
            let iH = mainLifeData.lifeModels[index].imagesH
            let indexPath = IndexPath(row: index + 1, section: 1)
            return frameForCollectionView(indexPath, iH: iH)
        }else{
            return super.frameForIndex(index)
        }
    }
    
    let plistCommentKey = "CommentKey"
    
    var adHeigth = SCREEN_W / 2
    func waterFlowViewLayout(_ waterFlowViewLayout: WaterFlowViewLayout, heightForWidth: CGFloat, indextPath: IndexPath) -> CGFloat {
        
        let index = waterFlowViewLayout.index
        if indextPath.section == 1{
            if index == 0 {
                if indextPath.row == 0{
                    return WaterFlowViewLayout.columnWidth * 16 / 9 + 55.aduJustHeight()
                }else{
                    return lifeDatas[index].lifeModels[indextPath.row - 1].height
                }
            }else{
                return lifeDatas[index].lifeModels[indextPath.row].height
            }
            
        }else{
            if lifeCategoryArr[index].categoryName == "活动" {
                return lifeDatas[index].activityModels[indextPath.row].height
            }else if index == 0 {
                return adHeigth
            }else{
                return 0
            }
            
        }
    }
    
    //MARK: -是否需要评分
    func getIsComment(){

        
        let defaults = UserDefaults.standard
        let num = defaults.object(forKey: plistCommentKey) as? Bool
        if num == nil{
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: plistCommentKey)
            return
        }
        
        NetKit.sharedInstance.doPostRequest(RequestURL.REQUEST_IS_COMMENT_URL, params:["key":"AppStoreComment"], successClosure:
            { (bodyData) in
                
                if (bodyData as? String) == "1"{
                    // 需要提示评分时候
                    if(DocumentUtil.queryScoreMessage() == Constants.scoreNo || DocumentUtil.queryScoreMessage() == Constants.scoreDone){
                        return
                    }
                    
                    if DocumentUtil.queryScoreMessage() == ""{
                        self.goAction()
                    }else {
                        let formatter:NSDateFormatter = NSDateFormatter()
                        formatter.dateFormat = "yyyyMMddHHmmss"
                        let rejectDate:NSDate = formatter.dateFromString(DocumentUtil.queryScoreMessage())!
                        let nowDate:NSDate = NSDate()
                        
                        let seconds = nowDate.timeIntervalSinceDate(rejectDate)
                        let day = seconds/(60*60*24)
                        if day > 3{       //残忍拒绝3天后， 再次提示
                            self.goAction()
                        }
                    }
                }
                
            }, failClosure: {
                
            },noDataClosure:{
                
        })
        
    }
    
    //MARK： - 去应用市场评分
    func goAction(){
        let goHandler = {(action:UIAlertAction!) -> Void in
            print("马上就去", terminator: "")
            
            let url = URL(string: Constants.itunesLink)!
            if UIApplication.sharedApplication().canOpenURL(url){
                UIApplication.sharedApplication().openURL(url)
                DocumentUtil.saveScoreMessage(Constants.scoreDone)
            }else{
                print("can not open", terminator: "")
            }
        }
        let noOneHandler = {(action:UIAlertAction!) -> Void in
            print("残忍拒绝", terminator: "")
            // 暂时拒绝记录当前时间，  x天后 再次提醒
            let date:Date = Date()
            let formatter:DateFormatter = DateFormatter()
            formatter.dateFormat = "yyyyMMddHHmmss"
            let dateString = formatter.string(from: date)
            print(dateString, terminator: "")
            DocumentUtil.saveScoreMessage(dateString)
        }
        let noMoreHandler = {(action:UIAlertAction!) -> Void in
            print("不再显示", terminator: "")
            DocumentUtil.saveScoreMessage(Constants.scoreNo)
        }
        
        let alertController = UIAlertController(title: "", message: "去应用市场评分", preferredStyle: UIAlertControllerStyle.alert)
        
        let goAction = UIAlertAction(title: "马上就去", style: UIAlertActionStyle.default, handler: goHandler)
        let noOneAction = UIAlertAction(title: "残忍拒绝", style: UIAlertActionStyle.default, handler: noOneHandler)
        let noMoreAction = UIAlertAction(title: "不再显示", style: UIAlertActionStyle.default, handler: noMoreHandler)
        alertController.addAction(goAction)
        alertController.addAction(noOneAction)
        alertController.addAction(noMoreAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        print("内存爆了")
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//Finding.志
class ZhiCell:UICollectionViewCell{
    let iv:UIImageView!
    let iv2:UIImageView!
    override init(frame: CGRect) {
        iv = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height - 55.aduJustHeight()))
        let v = UIView(frame: CGRect(x: 0, y: iv.frame.maxY + 1, width: frame.size.width, height: 55.aduJustHeight()))
        v.backgroundColor = UIColor(red: 226/225.0, green: 74/225.0, blue: 46/225.0, alpha: 1)
        let img = UIImage(named: "FindingZhi")
        iv2 = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width - 40, height: (frame.size.width - 40) * img!.size.height/img!.size.width))
        //        iv2 = UIImageView(frame: CGRectMake(0, 0, frame.size.width - 40, 20))
        iv2.image = img
        super.init(frame: frame)
        contentView.addSubview(iv)
        contentView.addSubview(v)
        v.addSubview(iv2)
        iv2.center = CGPoint(x: v.frame.size.width/2, y: v.frame.size.height/2)
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.contentView.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//广告
class AdCell:UICollectionViewCell{
    let iv:UIImageView!
    let b:UIButton!
    override init(frame: CGRect) {
        iv = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        iv.autoresizingMask = .flexibleHeight
        let l:CGFloat = 30
        b = UIButton(frame: CGRect(x: frame.size.width - l - 5 , y: 5, width: l, height: l))
        b.setBackgroundImage(UIImage(named: "btn_cancel"), for: UIControlState())
        super.init(frame: frame)
        contentView.addSubview(iv)
        contentView.addSubview(b)
        self.contentView.backgroundColor = UIColor.white

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//分类
class CategoryCell:UICollectionViewCell{
    static let fontSize:CGFloat = 16
    let l:UILabel
    let lineV:UIView
    override init(frame: CGRect) {
        l = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        l.font = UIFont.systemFont(ofSize: 14)
        l.autoresizingMask = .flexibleWidth
        
        lineV = UIView(frame: CGRect(x: 0, y: frame.size.height - 2, width: frame.size.width, height: 2))
        lineV.backgroundColor = UIColor.red
        lineV.autoresizingMask = .flexibleWidth
        super.init(frame: frame)
        l.textAlignment = .center
        contentView.addSubview(l)
//        contentView.addSubview(lineV)
        
        contentView.backgroundColor = UIColor.white
    }
    
    func toSelected(){
        self.l.font = UIFont.systemFont(ofSize: 14)
        self.l.textColor = UIColor.red
        lineV.isHidden = false
    }
    
    func toDeselected(){
        self.l.font = UIFont.systemFont(ofSize: 14)
        self.l.textColor = UIColor.black
        lineV.isHidden = true
    }
    
    func setFontColor(_ fractional:CGFloat){
        self.l.textColor = UIColor(red: fractional, green: 0, blue: 0, alpha: 1)
        lineV.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LifeBotttomView:UIView{
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nickLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
}

class InnerHeadView:UIView{
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nickLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var darenLabel: UILabel!
}

class InnerAddressView:UIView{
    @IBOutlet weak var addressLabel: UILabel!
}

class InnerWantView:UIView{
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var collectButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var wantButton: UIButton!
}

class CategoryCollectionView:UICollectionView{
    var selectedIndex = 0
    let lineV = UIView()
    func addLine(){
        
        //红线
        lineV.frame = CGRect(x: 0, y: self.frame.size.height - 2, width: 50, height: 2)
        lineV.backgroundColor = UIColor.red
        self.addSubview(lineV)

//        if let cell = self.cellForItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? CategoryCell {
//            self.lineV.frame.size.width = cell.frame.size.width
//            self.lineV.center.x = cell.center.x
//        }
        if let la = self.layoutAttributesForItem(at: IndexPath(row: 0, section: 0)) {
            self.lineV.frame.size.width = la.frame.size.width
            self.lineV.center.x = la.center.x
        }
    }
    
    
    
    func selectInCategoryView(_ index: Int){

        if let cell = self.cellForItem(at: IndexPath(row: selectedIndex, section: 0))as? CategoryCell {
            cell.toDeselected()
        }
        
        if let cell = self.cellForItem(at: IndexPath(row: index, section: 0)) as? CategoryCell {
            cell.toSelected()
            
            UIView.animate(withDuration: 0.25, animations: { 
                self.lineV.frame.size.width = cell.frame.size.width
                self.lineV.center.x = cell.center.x
                self.setScrollContentOffset()
            })
            
        }
        
        selectedIndex = index
    }
    
    func scrollLineInCategoryView(_ f: CGFloat){
        
        let index = Int(ceil(f))
        
        let preIndex = index - 1
        
        let fractional = f - CGFloat(preIndex)
        
        if let cell = self.cellForItem(at: IndexPath(row: index, section: 0)) as? CategoryCell,let preCell = self.cellForItem(at: IndexPath(row: preIndex, section: 0)) as? CategoryCell {
            self.lineV.center.x = preCell.center.x + (cell.center.x - preCell.center.x) * fractional
            self.lineV.frame.size.width = preCell.frame.size.width + (cell.frame.size.width - preCell.frame.size.width) * fractional
            
            setScrollContentOffset()
            
            cell.setFontColor(fractional)
            preCell.setFontColor(1 - fractional)
        }
        
    }
    
    func setScrollContentOffset(){
        if (self.lineV.center.x - SCREEN_W / 2) < 0{
            self.contentOffset.x = 0
        }else if (self.lineV.center.x - SCREEN_W / 2) > 0 && self.lineV.center.x + SCREEN_W / 2 < self.contentSize.width {
            self.contentOffset.x = (self.lineV.center.x - SCREEN_W / 2)
        }else{
            self.contentOffset.x = (self.contentSize.width - SCREEN_W)
        }
    }
}



