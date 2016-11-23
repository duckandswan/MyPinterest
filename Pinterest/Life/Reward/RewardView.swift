//
//  RewardView.swift
//  finding
//
//  Created by zhoumin on 16/5/4.
//  Copyright © 2016年 zhangli. All rights reserved.
//  悬赏

import UIKit

protocol RewardViewDelegate:NSObjectProtocol
{
    //点击关闭按钮，当前页面关闭
    func rewardViewClosed()
}

class RewardView: UIView , UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate{
    
    var storyId:String = ""

    var rewardTable:UITableView!
    var totalCountLabel:UILabel!
    var contentView:UIView!
    
    var questionView:UIView!
    var questionLabel:UILabel!
    
    var bottomView:UIView!
    var rewardText:UITextField!

    var pageNo = 1
    var pageSize = 10
    
    var bestRewardModelArr:[RewardModel] = []
    var otherRewardModelArr:[RewardModel] = []
    var isReload = false //true：下拉刷新  false：上拉加载更多

    weak var delegateVC:UIViewController?
    weak var delegate:RewardViewDelegate?
    
    var defaulPage:DefaultPage!
    
    
    func isUnData() {
        if (defaulPage != nil){
            defaulPage.removeFromSuperview()
        }
        if self.bestRewardModelArr.count + self.otherRewardModelArr.count < 1 {
            defaulPage = DefaultPage()
            
            if self.questionLabel.text == ""{
                defaulPage.frame = CGRect(x: 0, y: 0, width:  rewardTable.frame.size.width, height: rewardTable.frame.size.height)
            }else{
                defaulPage.frame = CGRect(x: 0, y: questionView.height, width:  rewardTable.frame.size.width, height: rewardTable.frame.size.height - questionView.height)
            }
            defaulPage.delegate = self
            defaulPage.unData("img_want")
            defaulPage.backgroundColor = UIColor.clearColor()
            rewardTable.addSubview(defaulPage)
            
        }else {
            if (defaulPage != nil){
                defaulPage.removeFromSuperview()
            }
        }
    }
    
    
    init(frame: CGRect,storyId:String) {
        super.init(frame: frame)
        
        self.storyId = storyId

        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        
        contentView = UIView.init(frame: CGRect(x: 0, y: Height, width: Width, height: Height-64))
        contentView.backgroundColor = UIColor.init(rgb: 0xf0eff5)
        self.addSubview(contentView)
        
        
        let headView = UIView.init(frame: CGRect(x: 0, y: 0, width: Width, height: 88))
        headView.backgroundColor = UIColor.whiteColor()
        contentView.addSubview(headView)
        
        let tipImageView = UIImageView.init(frame: CGRect(x: 12, y: 8, width: 260, height: 39))
        tipImageView.image = UIImage.init(named: "reward_tip")
        headView.addSubview(tipImageView)
        
        let closeBtn = UIButton.init(type: .custom)
        closeBtn.frame = CGRect(x: Width-36, y: 12, width: 24, height: 24)
        closeBtn.setImage(UIImage.init(named: "btn_cancel"), for: UIControlState())
        closeBtn.addTarget(self, action: #selector(RewardView.closeReward), for: .touchUpInside)
        headView.addSubview(closeBtn)
        
        totalCountLabel = UILabel.init(frame: CGRect(x: 12, y: (tipImageView.frame).maxY + 10, width: Width - 24, height: 21))
        totalCountLabel.font = UIFont.systemFont(ofSize: 14)
        totalCountLabel.textColor = UIColor.init(rgb: 0x333333)
        totalCountLabel.text = "0条线索"
        headView.addSubview(totalCountLabel)
        
        let line = UIView.init(frame: CGRect(x: 0, y: headView.height - 0.5, width: headView.width, height: 0.5))
        line.backgroundColor = UIColor.init(rgb: 0xdedde3)
        headView.addSubview(line)
        
        rewardTable = UITableView.init(frame: CGRect(x: 0, y: (headView.frame).maxY, width: Width, height: contentView.frame.height -  (headView.frame).maxY - 65), style: .Plain)
        rewardTable.dataSource = self
        rewardTable.delegate = self
        rewardTable.backgroundColor = UIColor.clear
        rewardTable.separatorStyle = .none
        contentView.addSubview(rewardTable)
        
        initQuestionView()
        
        bottomView = UIView.init(frame: CGRect(x: 0, y: Height - 65, width: Width, height: 65))
        bottomView.backgroundColor = UIColor.white
        self.addSubview(bottomView)
        
        let textBgView = UIView.init(frame: CGRect(x: 12, y: 14, width: Width - 66, height: 36))
        textBgView.backgroundColor = UIColor.init(rgb: 0xe5e5e6)
        textBgView.layer.cornerRadius = 6
        textBgView.layer.masksToBounds = true
        bottomView.addSubview(textBgView)
        
        rewardText = UITextField.init(frame: CGRect(x: 10, y: 3, width: textBgView.width - 20, height: 30))
        rewardText.borderStyle = .none
        rewardText.textAlignment = .left
        rewardText.placeholder = "提供线索"
        rewardText.delegate = self
        rewardText.returnKeyType = .done
        textBgView.addSubview(rewardText)
        
        
        let sendBtn = UIButton.init(type: .system)
        sendBtn.setTitle("发送", for: UIControlState())
        sendBtn.setTitleColor(UIColor.init(rgb: 0xf15732), forState: .Normal)
        sendBtn.frame = CGRect(x: bottomView.width - 54, y: 14, width: 54, height: 36)
        sendBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        sendBtn.addTarget(self, action: #selector(RewardView.sendReward), for: .touchUpInside)
        bottomView.addSubview(sendBtn)
        
        addHeaderRefresh()
        addFooterRefresh()
        
        rewardTable.gifHeader.beginRefreshing()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func headImageTap(_ tapGes:UserIdTapGestureRecognizer) {
        
        print(tapGes.userId)
        if delegateVC != nil {
            MyScriptHandler.toUserPage(delegateVC!, userId: String(tapGes.userId))
        }
    }
    
    func initQuestionView() {
        
        questionView = UIView.init(frame: CGRect(x: 0, y: 0, width: Width, height: 0))
        questionView.backgroundColor = UIColor.clear
        
        questionLabel = UILabel.init(frame: CGRect(x: 10, y: 10, width: Width-20, height: 0))
        questionLabel.backgroundColor = UIColor.clear
        questionLabel.font = UIFont.systemFont(ofSize: 15)
        questionLabel.text = ""
        questionLabel.textAlignment = .center
        questionLabel.numberOfLines = 0
        questionLabel.lineBreakMode = .byWordWrapping
        let size = questionLabel.text?.textSizeWithFont(questionLabel.font, constrainedToSize: CGSize(width: Width - 20, height: 1000))
        questionLabel.frame = CGRect(x: 10, y: 10, width: Width-20, height: (size?.height)!)
        questionView.frame = CGRect(x: 0, y: 0, width: Width, height: (size?.height)! + 20)
        questionView.addSubview(questionLabel)

    }
    
    func resetTableHeaderView() {
        let size = questionLabel.text?.textSizeWithFont(questionLabel.font, constrainedToSize: CGSize(width: Width - 20, height: 1000))
        questionLabel.frame = CGRect(x: 10, y: 10, width: Width-20, height: (size?.height)!)
        questionView.frame = CGRect(x: 0, y: 0, width: Width, height: (size?.height)! + 20)
        
        rewardTable.tableHeaderView = questionView
    }
    //MARK: -下拉刷新，上拉加载更多
    func addHeaderRefresh() {
        let img = UIImage(named: "img_loading")
        
        rewardTable.addGifHeaderWithRefreshingTarget(self, refreshingAction: #selector(RewardView.headerRefreshData))
        rewardTable.gifHeader.setRefreshingmages([img!])
        rewardTable.gifHeader.setIdleImsages([img!])
        rewardTable.gifHeader.stateHidden = true
        rewardTable.gifHeader.updatedTimeHidden = true
        
    }
    
    func addFooterRefresh() {
        if rewardTable.gifFooter == nil {
            rewardTable.addGifFooterWithRefreshingTarget(self, refreshingAction: #selector(RewardView.footerGetMoreData))
            rewardTable.gifFooter.refreshingImages = [UIImage(named: "img_loading")!]
            rewardTable.gifFooter.stateHidden = true
            rewardTable.gifFooter.setTitle("", forState: MJRefreshFooterStateRefreshing)
            rewardTable.gifFooter.setTitle("", forState: MJRefreshFooterStateIdle)
        }
    }

    
    
    //MARK:- show/hide
    func closeReward() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
            self.contentView.frame = CGRect(x: 0, y: Height, width: Width, height: Height-64)
        }, completion: { (isCompleted) in
            if isCompleted{
                if self.delegate != nil && (self.delegate?.responds(to: Selector("rewardViewClosed")))!{
                    self.delegate?.rewardViewClosed()
                }
                self.removeFromSuperview()
            }
        }) 
    }
    
    func showInView(_ viewCtr:UIViewController){
        viewCtr.view.addSubview(self)
        delegateVC = viewCtr
        UIView.animateWithDuration(0.3, animations: {
            self.alpha = 1
        }) { (isCompleted) in
            UIView.animateWithDuration(0.3, animations: {
                self.contentView.frame = CGRect(x: 0, y: 64, width: Width, height: Height-64)
            })
        }
    }
    
    //MARK:- HTTPRequest
    
    func sendReward() {
        
        
        if !DocumentUtil.haveLogin(){
            DocumentUtil.logIn(delegateVC!,animated: true)
            return
        }
        
        if rewardText.text == "" {
            TWMessageBarManager().showMessageWithTitle("", description: "请输入线索内容", type: TWMessageBarMessageTypeError)
            return
        }
        
        let params:[String:AnyObject] = ["storyId":storyId,"content":rewardText.text!,"userId":Constants.CURRENT_USER_ID]

        NetKit.sharedInstance.doPostRequest(RequestURL.SEND_REWARD, params:params, successClosure:
            { (bodyData) in
                
                self.rewardText.text = ""
                self.rewardText.resignFirstResponder()
                self.rewardTable.gifHeader.beginRefreshing()
                
            }, failClosure: {
                
            },noDataClosure:{
                
        })
        
     
    }
    
    func getRewardList() {
        
        let params:[String:AnyObject] = ["storyId":storyId,"pageNo":pageNo,"pageSize":pageSize]
        
        NetKit.sharedInstance.doPostRequest(RequestURL.QUERY_REWARD_REPLY, params:params, successClosure:
            { (bodyData) in
                
                if let bodyDic = bodyData as? NSDictionary {
                    if let size = bodyDic["size"] as? NSInteger{
                        self.totalCountLabel.text = "\(size)条线索"
                    }
                    if let question = bodyDic["askQuestion"] as? String {
                        if question != "" {
                            self.questionLabel.text = question
                            self.resetTableHeaderView()
                        }
                    }
                    
                    if let rewardReplyList = bodyDic["rewardReplyList"] as? NSArray{
                        
                        if self.isReload{
                            self.bestRewardModelArr.removeAll()
                            self.otherRewardModelArr.removeAll()
                        }
                        
                        
                        for item in rewardReplyList {
                            let rewardModel = RewardModel()
                            if let rewardDic = item as? NSDictionary{
                                rewardModel.setValueForDic(rewardDic)
                                if rewardModel.isBest == 1{
                                    self.bestRewardModelArr.append(rewardModel)
                                }else{
                                    self.otherRewardModelArr.append(rewardModel)
                                }
                            }
                        }
                        
                        self.rewardTable.reloadData()
                    }
                }
                
                self.rewardTable.header.endRefreshing()
                self.rewardTable.footer.endRefreshing()
                
                self.isUnData()
            }, failClosure: {
                self.rewardTable.header.endRefreshing()
                self.rewardTable.footer.endRefreshing()
                
                self.isUnData()
            },noDataClosure:{
                if self.isReload{
                    self.bestRewardModelArr.removeAll()
                    self.otherRewardModelArr.removeAll()
                }
                self.rewardTable.header.endRefreshing()
                self.rewardTable.footer.endRefreshing()
                
                self.isUnData()
        })
        
    }
    
    func headerRefreshData(){
        pageNo = 1
        isReload = true
        getRewardList()
    }
    
    func footerGetMoreData(){
        pageNo += 1
        isReload = false
        getRewardList()
    }
    
    
    
    //MARK:-  UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        if bestRewardModelArr.count > 0  && otherRewardModelArr.count > 0{
            return 2
        }else{
            return 1
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if bestRewardModelArr.count > 0 {
            if section == 0 {
                return bestRewardModelArr.count
            }else{
                return otherRewardModelArr.count
            }
        }else{
            return otherRewardModelArr.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:RewardCell = RewardCell.init(style: .default, reuseIdentifier: "")
        
        var model:RewardModel
        if bestRewardModelArr.count > 0{
            if indexPath.section == 0{
                model = bestRewardModelArr[indexPath.row]
            }else{
                model = otherRewardModelArr[indexPath.row]
            }
        }else{
            model = otherRewardModelArr[indexPath.row]
        }
        

        cell.setData(model)
        
        cell.headImage.isUserInteractionEnabled = true
        
        let tapGestureRecognizer = UserIdTapGestureRecognizer(target: self,
                                                              action: #selector(RewardView.headImageTap(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.userId = model.userId.integerValue
        cell.headImage.addGestureRecognizer(tapGestureRecognizer)
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let cell = self.tableView(tableView, cellForRowAt: indexPath) as? RewardCell
        return (cell?.line.frame)!.maxY
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if bestRewardModelArr.count == 0 {
            return nil
        }
        
        
        
        if section == 0 {
            
            let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: Width, height: 35))
            headerView.backgroundColor = UIColor.init(rgb: 0xf8f8f8)
            
            let logoImgView = UIImageView()
            logoImgView.backgroundColor = UIColor.clear
            
            logoImgView.image = UIImage.init(named: "reward_bestMsg")
            logoImgView.frame = CGRect(x: 12, y: 0, width: 30, height: 32)
            headerView.addSubview(logoImgView)
            
            let desLabel = UILabel()
            desLabel.font = UIFont.systemFont(ofSize: 16)
            desLabel.textColor = UIColor.init(rgb: 0x333333)
            desLabel.frame = CGRect(x: (logoImgView.frame).maxX + 9, y: 0, width: Width - (logoImgView.frame).maxX - 18, height: 35)
            desLabel.text = "最佳线索"
            headerView.addSubview(desLabel)
            

            
            let line = UIView.init(frame: CGRect(x: 0, y: headerView.height - 0.5, width: headerView.width, height: 0.5))
            line.backgroundColor = UIColor.init(rgb: 0xdedde3)
            headerView.addSubview(line)
            
            return headerView

        }else{
            
            let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: Width, height: 50))
            headerView.backgroundColor = UIColor.init(rgb: 0xf0eff5)
            
            let bgView = UIView.init(frame: CGRect(x: 0, y: 15, width: Width, height: 35))
            bgView.backgroundColor = UIColor.init(rgb: 0xf8f8f8)
            headerView.addSubview(bgView)
            
            let logoImgView = UIImageView()
            logoImgView.backgroundColor = UIColor.clear
            logoImgView.image = UIImage.init(named: "reward_otherMsg")
            logoImgView.frame = CGRect(x: 12, y: 7, width: 20, height: 20)
            bgView.addSubview(logoImgView)
            
            let desLabel = UILabel()
            desLabel.font = UIFont.systemFont(ofSize: 16)
            desLabel.frame = CGRect(x: (logoImgView.frame).maxX + 9, y: 0, width: Width - (logoImgView.frame).maxX - 18, height: 35)
            desLabel.textColor = UIColor.init(rgb: 0x333333)
            desLabel.text = "其他线索"
            bgView.addSubview(desLabel)
            
            let line = UIView.init(frame: CGRect(x: 0, y: headerView.height - 0.5, width: headerView.width, height: 0.5))
            line.backgroundColor = UIColor.init(rgb: 0xdedde3)
            headerView.addSubview(line)
            
            return headerView

        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if bestRewardModelArr.count > 0 {
            if section == 0 {
                return 35
            }else{
                return 50
            }
        }else{
            return 0
        }
    }
    
    
    //MARK:- UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{

        rewardText.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        UIView.animateWithDuration(0.3) {
            self.bottomView.frame = CGRect(x: 0, y: Height - 65, width: Width, height: 65)
        }
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        UIView.animateWithDuration(0.3) { 
            self.bottomView.frame = CGRect(x: 0, y: Height - 65 - 219 - 60, width: Width, height: 65)
        }
        return true
    }
    
    
}

class RewardModel:NSObject {
    /*
     {
     avatar = "http://img.finding.com/8d74ada4f79becb78fd5875ac6e2b812";
     content = qwedwqswq;
     createTime = "5\U5c0f\U65f6\U524d";
     isBest = 1;
     point = 98;
     "user_nick" = "\U5218\U6676";
     }
    */
    var avatar:String = ""
    var content:String = ""
    var createTime:String = ""
    var isBest:NSNumber = 0
    var pointStr:String = ""
    var user_nick:String = ""
    var userId:NSNumber = 0
    var type:NSNumber = 0

    func setValueForDic(_ dic:NSDictionary){
        
        avatar      =  (dic["avatar"] ?? "") as! String
        content     =  (dic["content"] ?? "") as! String
        createTime  =  (dic["createTime"] ?? "") as! String
        isBest      =  (dic["isBest"] ?? 0) as! NSNumber
        pointStr    =  (dic["pointStr"] ?? "") as! String
        user_nick   =  (dic["user_nick"] ?? "") as! String
        type        = (dic["type"] ?? 0) as! NSNumber
        userId      = (dic["userId"] ?? 0) as! NSNumber
    }
}
