//
//  UWantViewController.swift
//  finding
//
//  Created by zhoumin on 16/5/7.
//  Copyright © 2016年 zhangli. All rights reserved.
//

import UIKit

class UWantViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{

    var uWantTable:UITableView!
    var questionModelArr:[QuestionModel] = []
    
    var storyCollectionId:String = ""

    var isReload = false
    
    var defaulPage:DefaultPage!

    //MARK:- LifeCycle

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func isUnData() {
        if (defaulPage != nil){
            defaulPage.removeFromSuperview()
        }
        if self.questionModelArr.count < 1 {
            defaulPage = DefaultPage()
            defaulPage.frame = CGRect(x: 0, y: 0, width:  uWantTable.frame.size.width, height: uWantTable.frame.size.height)
            defaulPage.delegate = self
            defaulPage.unData("img_guess-1")
            uWantTable.addSubview(defaulPage)
        }else {
            if (defaulPage != nil){
                defaulPage.removeFromSuperview()
            }
        }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.init(rgb: 0xf0eff5)
        initHeadView()
        
        uWantTable = UITableView.init(frame: CGRect(x: 0, y: 64, width: Width, height: Height - 64 - 50), style: .Grouped)
        uWantTable.dataSource = self
        uWantTable.delegate = self
        uWantTable.backgroundColor = UIColor.clear
        uWantTable.separatorStyle = .none
        self.view.addSubview(uWantTable)
        
        
        addHeaderRefresh()
        
        uWantTable.gifHeader.beginRefreshing()
        
        
        let bottomView = UIView()
        bottomView.backgroundColor = UIColor.clear
        bottomView.frame = CGRect(x: 0, y: Height - 50, width: Width, height: 50)
        self.view.addSubview(bottomView)
        
        let askBtn = UIButton.init(type: .system)
        askBtn.frame = CGRect(x: 125, y: bottomView.frame.height - 6 - 38, width: Width - 250, height: 38)
        askBtn.setTitle("提问", for: UIControlState())
        askBtn.setTitleColor(UIColor.white, for: UIControlState())
        askBtn.backgroundColor = UIColor.red
        askBtn.layer.cornerRadius = 6
        askBtn.layer.masksToBounds = true
        askBtn.addTarget(self, action: #selector(UWantViewController.askQuestion), for: .touchUpInside)
        bottomView.addSubview(askBtn)
        
        NotificationCenter.default.addObserver(self, selector: #selector(UWantViewController.headerRefreshData), name: "ReloadUWant", object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: "ReloadUWant", object: nil)
        
    }
    
    // -初始化头部背景视图
    func initHeadView() {
        //头部背景
        let headBgView = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: 64))
        headBgView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(headBgView)
        
        let leftBtn = UIButton(frame: CGRect(x: 0, y: 20, width: 44, height: 44))
        leftBtn.centerY = (headBgView.height) * CGFloat(0.5)  + 10
        leftBtn.setImage(UIImage(named: "btn_back"), for: UIControlState())
        leftBtn.setTitle("", for: UIControlState())
        leftBtn.addTarget(self, action: #selector(UWantViewController.leftBarButtonItemClick), for: UIControlEvents.touchUpInside)
        headBgView.addSubview(leftBtn)
        //初始化标
        let lineView: UIView = UIView(frame: CGRect(x: 0, y: headBgView.height - 1, width: Width, height: 1))
        lineView.backgroundColor = UIColor(red: 224/255, green: 225/255, blue: 227/255, alpha: 1)
        headBgView.addSubview(lineView)
        
        let headTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
        headTitle.textAlignment = .center
        headTitle.text = "猜你想"
        headTitle.textColor = UIColor.black
        headTitle.font = UIFont.systemFont(ofSize: 18)
        
        headTitle.center = headBgView.middlePoint
        headTitle.centerY = (headBgView.height) * CGFloat(0.5)  + 10
        headBgView.addSubview(headTitle)
        
        
    }
    
    func leftBarButtonItemClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func askQuestion() {
        
        if !DocumentUtil.haveLogin() {
            DocumentUtil.logIn(self)
            return
        }
        let askQuestionVC = AskQuestionViewController()
        askQuestionVC.storyCollectionId = storyCollectionId
        askQuestionVC.questionModelArr = questionModelArr
        self.navigationController?.pushViewController(askQuestionVC, animated: true)
    }
    //MARK: -下拉刷新，上拉加载更多
    func addHeaderRefresh() {
        let img = UIImage(named: "img_loading")
        
        uWantTable.addGifHeaderWithRefreshingTarget(self, refreshingAction: #selector(UWantViewController.headerRefreshData))
        uWantTable.gifHeader.setRefreshingmages([img!])
        uWantTable.gifHeader.setIdleImsages([img!])
        uWantTable.gifHeader.stateHidden = true
        uWantTable.gifHeader.updatedTimeHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        BaiduMobStat.defaultStat().pageviewStartWithName("猜你想")
        MobClick.beginLogPageView("猜你想")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //结束百度统计
        BaiduMobStat.defaultStat().pageviewEndWithName("猜你想")
        MobClick.endLogPageView("猜你想")
    }

    //MARK:- HTTPRequest
    
    func answerQuestion(_ sender:MyIndexPathButton) {
        
        if !DocumentUtil.haveLogin() {
            DocumentUtil.logIn(self)
            return
        }
        
        let indexPath = sender.indexPath
        let answerVC = AnswerViewController()
        answerVC.questionModel = questionModelArr[indexPath.section]
        answerVC.questionIndex = indexPath.section
        self.navigationController?.pushViewController(answerVC, animated: true)
    }
    //点赞
    func favBtnClick(_ sender:MyIndexPathButton){
        
        if !DocumentUtil.haveLogin() {
            DocumentUtil.logIn(self)
            return
        }
        
        
        
        
        let indexPath = sender.indexPath
        print(indexPath)
        let mayLikeId = questionModelArr[indexPath.section].likes[indexPath.row-1].id
        let askId = questionModelArr[indexPath.section].id
        let params = ["mayLikeId":String(mayLikeId),"askId":String(askId),"userId":Constants.CURRENT_USER_ID]
        
        
        let questionModel = self.questionModelArr[indexPath.section]
        questionModel.isClick = 1
        
        var answerModelArr = self.questionModelArr[indexPath.section].likes
        let answerModel = answerModelArr[indexPath.row-1]
        answerModel.isClick = 1
        answerModel.clickCount = NSNumber.init(value: answerModel.clickCount.intValue + 1 as Int)
        
        answerModelArr.remove(at: indexPath.row - 1)
        answerModelArr.insert(answerModel, at: indexPath.row - 1)
        
        self.questionModelArr.remove(at: indexPath.section)
        self.questionModelArr.insert(questionModel, at: indexPath.section)
        self.uWantTable.reloadData()
        
        MBProgressHUD.showText("\(answerModel.clickCount)人跟你想的一样", view: self.view)
        
        NetKit.sharedInstance.doPostRequest(RequestURL.LIKE_CLICK, params:params, successClosure:
            { (bodyData) in
                
                self.uWantTable.header.endRefreshing()

                
            }, failClosure: {
                self.uWantTable.header.endRefreshing()

            },noDataClosure:{
                self.uWantTable.header.endRefreshing()

        })
    }
    
    func headerRefreshData(){
        
      
        isReload = true
        getQuestionAndAnswers()
    }
    
    func getQuestionAndAnswers(){
        
        var params:[String:AnyObject]!
        
        if DocumentUtil.haveLogin(){
            params = ["storyCollectionId":storyCollectionId,"userId":Constants.CURRENT_USER_ID]
        }else{
            params = ["storyCollectionId":storyCollectionId]
        }
        
        
        NetKit.sharedInstance.doPostRequest(RequestURL.UWANT_LIST, params:params, successClosure:
            { (bodyData) in
                
                if let arr = bodyData as? NSArray {
                    
                    if self.isReload{
                        self.questionModelArr.removeAll()
                    }
                    for item in arr {
                        let questionModel = QuestionModel()
                        if let dic = item as? NSDictionary{
                            questionModel.setValueForDic(dic)
                            self.questionModelArr.append(questionModel)
                        }
                    }
                    self.uWantTable.reloadData()
                }
                
                self.uWantTable.header.endRefreshing()
                self.isUnData()
                
            }, failClosure: {
                self.uWantTable.header.endRefreshing()
                self.isUnData()
            },noDataClosure:{
                if self.isReload{
                    self.questionModelArr.removeAll()
                }
                self.uWantTable.header.endRefreshing()
                self.isUnData()
        })
    }
    
    //MARK:-  UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.questionModelArr.count

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (self.questionModelArr[section].likes.count + 2)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let questionModel = questionModelArr[indexPath.section]

        if indexPath.row == 0 {
            let cell = QuestionCell.init(style: .default, reuseIdentifier: "")
            cell.setData(questionModel)
            cell.selectionStyle = .none
            return cell
        }else if indexPath.row == questionModelArr[indexPath.section].likes.count + 1{
            let cell = AnswerBtnCell.init(style: .default, reuseIdentifier: "")
            cell.answerBtn.indexPath = indexPath
            cell.answerBtn.addTarget(self, action: #selector(UWantViewController.answerQuestion), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = AnswerCell.init(style: .default, reuseIdentifier: "")
            let answerModel = questionModelArr[indexPath.section].likes[indexPath.row - 1] as AnswerModel
            cell.setData(answerModel,questionModel: questionModel)
            
            cell.favBtn.indexPath = indexPath
            cell.favBtn.addTarget(self, action: #selector(UWantViewController.favBtnClick), for: .touchDown)

            cell.selectionStyle = .none
            return cell
        }
    }

    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            let cell = self.tableView(tableView, cellForRowAt: indexPath) as? QuestionCell
            return (cell?.line.frame)!.maxY
        }else if indexPath.row == questionModelArr[indexPath.section].likes.count + 1{
            return 44
        }else {
            let cell = self.tableView(tableView, cellForRowAt: indexPath) as? AnswerCell
            return (cell?.line.frame)!.maxY
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    

    //MARK:- UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {

        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {

        return true
    }
    
    
}

class AnswerModel: NSObject {
    
    var content:String = ""
    var createTime:String = ""
    var userNick:String = ""
    var id:NSNumber = 0
    var clickCount:NSNumber = 0
    var isClick:NSNumber = 0

    func setValueForDic(_ dic:NSDictionary){
        
        content     =  (dic["content"] ?? "") as! String
        createTime  =  (dic["createTime"] ?? "") as! String
        userNick    =  (dic["userNick"] ?? "") as! String
        id          = (dic["id"] ?? 0) as! NSNumber
        clickCount  =  (dic["clickCount"] ?? 0) as! NSNumber
        isClick     =  (dic["isClick"] ?? 0) as! NSNumber

    }
}

class QuestionModel: NSObject {
    
    var askQuestion:String = ""
    var createTime:String = ""
    var id:NSNumber = 0
    var isClick:NSNumber = 0
    var likes:[AnswerModel] = []
    
    func setValueForDic(_ dic:NSDictionary){
        
        askQuestion =  (dic["askQuestion"] ?? "") as! String
        createTime  =  (dic["createTime"] ?? "") as! String
        id          =  (dic["id"] ?? 0) as! NSNumber
        isClick     =  (dic["isClick"] ?? 0) as! NSNumber
        
        if let arr = dic["likes"] as? NSArray {
            for item in arr{
                if let dic = item as? NSDictionary {
                    let answerModel = AnswerModel()
                    answerModel.setValueForDic(dic)
                    likes.append(answerModel)
                }
            }
        }
    }
}

