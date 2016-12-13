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
        flowLayout.itemSize = CGSize(width: view.frame.width, height: SCREEN_H - categoryView.frame.maxY)
        flowLayout.scrollDirection = .horizontal
        
        mainCollectionView = UICollectionView(frame: CGRect(x: 0, y: categoryView.frame.maxY, width: view.frame.width, height: SCREEN_H - categoryView.frame.maxY), collectionViewLayout: flowLayout)
        
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
        let url = "http://api.finding.com/api/tag/catedisplay"
        let params:[String:Any] = ["" : ""]
        let successClosure: ((_ body:Any) -> Void) = {
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
        if scrollView != categoryView && scrollView != mainCollectionView {
//            if scrollView.contentOffset.y > scrollView.contentSize.height - SCREEN_H + 45{
//                getDataFromServer(scrollView as? UICollectionView)
//            }
        }
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
        var url = "http://api.finding.com/api/life/catelist"
        
        if index == 0{
            url = "http://api.finding.com/api/life/recommand"
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
        
        let successClosure: ((_ body:Any) -> Void) = {
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
            (collectionView as? MyRefreshCollectionView)?.endMyRefresh()
        }else{
            print("not end index: \(index)")
        }
        let lifeData = lifeDatas[index]
        lifeData.canRequest = true
    }
    
    override func footerRefreshData(){
        getDataFromServer(lifeCollectionView)
    }
    
    func refresh(sender:UIActivityIndicatorView) {
        let collectionView = sender.superview as! UICollectionView
        getDataFromServer(collectionView, isrefresh: true)
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
                
//                cell.relatedCollectionView.addHeaderRefresh(block: { 
//                    [weak self,weak cv = cell.relatedCollectionView] in
//                    self?.getDataFromServer(cv, isrefresh: true)
//                })
                
//                cell.relatedCollectionView.addHeaderRefresh(obj: self, action: #selector(LifeNativeViewController.refresh(sender:)))

                cell.relatedCollectionView.addMyHeaderRefresh(obj: self, action: #selector(LifeNativeViewController.refresh(sender:)))
                
                cell.relatedCollectionView.addFooterRefresh(block: {
                    [weak self,weak cv = cell.relatedCollectionView] in
                    self?.getDataFromServer(cv)
                })
                
                if lifeData.isEnd == true{
                }
                
                //没数据时刷新
                if lifeData.lifeModels.count == 0 && lifeData.isEnd == false{
                    print("beginRefreshing tag:\(cell.relatedCollectionView?.tag)")
//                    getDataFromServer(cell.relatedCollectionView, isrefresh: true)
                }
                
//                cell.relatedCollectionView.contentOffset.y = lifeData.yOffset
//                UIView.animate(withDuration: 2.0, animations: {
//                    cell.relatedCollectionView.contentInset.top = 100
//                }, completion: { (b) in
//                    UIView.animate(withDuration: 2.0, animations: {
//                        cell.relatedCollectionView.contentInset.top = 0
//                    })
//                })
                
                print("cell.relatedCollectionView.contentInset.top: \(cell.relatedCollectionView.contentInset.top)")
                
//                UIView.animate(withDuration: 1.0, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
//                    cell.relatedCollectionView.contentOffset.y = -75
//                }, completion: { (b) in
//                    UIView.animate(withDuration: 1.0, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
//                        cell.relatedCollectionView.contentOffset.y = 0
//                    })
//                })
                cell.relatedCollectionView.beginMyRefresh()
                
                return cell
            }else{
                if indexPath.section == 1 {
                    
                    let index = collectionView.tag
                    let lifeModel = lifeDatas[index].lifeModels[indexPath.row]
                    if indexPath.row - 1 == lifeDatas[index].lifeModels.count - LifeCollectionViewCell.requestNumber{
                        getDataFromServer(collectionView)
                    }
                    
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LifeCollectionViewCell
                    cell.setData(lifeModel)
                    return cell
                }else if indexPath.section == 0{
                    return UICollectionViewCell()
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
                    mainLifeData = lifeDatas[collectionView.tag]
                    lifeCollectionView = collectionView
                    let cell = collectionView.cellForItem(at: indexPath) as! CommonCollectionViewCell
                    presentLifeInner(cell, index: indexPath.row)
                }else{
                    
                }
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == mainCollectionView {
            return CGSize(width: view.frame.width, height: SCREEN_H - categoryView.frame.maxY)
        }else{
            let size =  LifeUtils.calculateSizeForStr(lifeCategoryArr[indexPath.row].categoryName, size: CGSize(width: 500, height: 44), font: UIFont.systemFont(ofSize: CategoryCell.fontSize))
            return CGSize(width: size.width + 10, height: 44)
        }
    }
    
    
//    override func frameForIndex(_ index:Int)->CGRect{
//        if lifeCollectionView.tag == 0{
//            let iH = mainLifeData.lifeModels[index].imagesH
//            let indexPath = IndexPath(row: index + 1, section: 1)
//            return frameForCollectionView(indexPath, iH: iH)
//        }else{
//            return super.frameForIndex(index)
//        }
//    }
    
    let plistCommentKey = "CommentKey"
    
    var adHeigth = SCREEN_W / 2
    func waterFlowViewLayout(_ waterFlowViewLayout: WaterFlowViewLayout, heightForWidth: CGFloat, indextPath: IndexPath) -> CGFloat {
        
        let index = waterFlowViewLayout.index
        if indextPath.section == 1{
//            if index == 0 {
//                if indextPath.row == 0{
//                    return WaterFlowViewLayout.columnWidth * 16 / 9 + 55.aduJustHeight()
//                }else{
//                    return lifeDatas[index].lifeModels[indextPath.row - 1].height
//                }
//            }else{
//                return lifeDatas[index].lifeModels[indextPath.row].height
//            }
            return lifeDatas[index].lifeModels[indextPath.row].height
        }else{
//            if lifeCategoryArr[index].categoryName == "活动" {
//                return lifeDatas[index].activityModels[indextPath.row].height
//            }else if index == 0 {
//                return adHeigth
//            }else{
//                return 0
//            }
            return 0
        }
    }
    
    override func didReceiveMemoryWarning() {
        print("内存爆了")
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    @IBOutlet weak var headImageView: MyWebImageView!
    @IBOutlet weak var nickLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
}

class InnerHeadView:UIView{
    @IBOutlet weak var headImageView: MyWebImageView!
    @IBOutlet weak var nickLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var followBtn: UIButton!

}

class CategoryCollectionView:UICollectionView{
    var selectedIndex = 0
    let lineV = UIView()
    func addLine(){
        
        //红线
        lineV.frame = CGRect(x: 0, y: self.frame.size.height - 2, width: 50, height: 2)
        lineV.backgroundColor = UIColor.red
        self.addSubview(lineV)

        if let la = self.layoutAttributesForItem(at: IndexPath(row: 0, section: 0)) {
            self.lineV.frame.size.width = la.frame.size.width
            self.lineV.center.x = la.center.x
        }
    }
    
    
    
    func selectInCategoryView(_ index: Int){

//        if let cell = self.cellForItem(at: IndexPath(row: selectedIndex, section: 0))as? CategoryCell {
//            cell.toDeselected()
//        }
        
        for cell in self.visibleCells{
            (cell as? CategoryCell)?.toDeselected()
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



