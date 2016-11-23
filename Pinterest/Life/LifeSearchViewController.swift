//
//  LifeSearchViewController.swift
//  finding
//
//  Created by admin on 15/12/29.
//  Copyright © 2015年 zhangli. All rights reserved.
//

import UIKit
import WebKit
//看生活搜索页面
class LifeSearchViewController: UIViewController,WKScriptMessageHandler,FriendSearchTableViewControllerDelegate,UITextFieldDelegate {
    //属性
    var headBgView        :UIView!//头部背景视图
    var searchBarTextField:UITextField!//搜索输入框
    var labelBgView       :UIView!//标签栏背景视图
    let LABELBTN_TAG      = 10000 //标签栏按钮tag起始值
    var potoWeb           :WebView!//照片web
    var productWeb        :WebView!//商品Web
    var potoUrl           :URLRequest!//{ return Constants.focusWebUrl + "?userId=\(Constants.CURRENT_USER_ID)" }//照片WebUrl
    var productUrl        :URLRequest!//{ return Constants.focusWebUrl + "?userId=\(Constants.CURRENT_USER_ID)" } //商品WebUrl
    var friendSearchVC    : FriendSearchTableViewController!//用户搜索结果控制器
    var currentPage       = 1//搜索用户分页： 第一页
    var pageSize          = 500//搜索用户分页： 一页500条数据
    var menthod           :String!//点击搜索要执行的方法
    var labelLineView     : UIView!//红线
    var isSearching:Bool = false
    var isLogin:Bool! = false
    //MARK: - 加载完毕
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        //初始化头部
        initHeadView()
        //初始化标签栏
        initLabel()
        //初始化Web
        initWeb()
        //初始化用户搜索结果控制街
        initSearchUserVC()
        let potoBtn = labelBgView.viewWithTag(LABELBTN_TAG) as! UIButton
        clickLabelBtn(potoBtn)
    }
    
    //MARK: - 即将显示
    override func viewWillAppear(_ animated: Bool) {
        //接入百度统计
         BaiduMobStat.defaultStat().pageviewStartWithName("看生活搜索页")
         MobClick.beginLogPageView("看生活搜索页")
        self.navigationController?.isNavigationBarHidden = true
        rootController.showOrhideToolbar(false)
      
    }
    
    //MARK: - 即将消失
    override func viewWillDisappear(_ animated: Bool) {
        BaiduMobStat.defaultStat().pageviewEndWithName("看生活搜索页")
        MobClick.endLogPageView("看生活搜索页")
    }
    
    
    //MARK: - 初始化
    init(potoUrl:URLRequest,productUrl:URLRequest) {
        self.potoUrl = potoUrl
        self.productUrl = productUrl
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -初始化头部
    func initHeadView() {
        //初始化头部背景图
        headBgView = UIView(frame: CGRect(x: 0, y: 20, width: Width, height: 44))
        headBgView.backgroundColor = UIColor.white
        
        //初始化搜索框
        searchBarTextField = UITextField(frame: CGRect(x: 12, y: 2, width: Width - 75, height: 29))
        searchBarTextField.borderStyle = UITextBorderStyle.roundedRect
        searchBarTextField.returnKeyType = UIReturnKeyType.search
        searchBarTextField.clearButtonMode = UITextFieldViewMode.whileEditing
        searchBarTextField.backgroundColor = UIColor(red: 224/255, green: 225/255, blue: 227/255, alpha: 1)
        searchBarTextField.delegate = self
        searchBarTextField.font = UIFont.systemFont(ofSize: 14)
        searchBarTextField.centerY = headBgView.middleY
        //初始化搜索按钮
        let searchBtn:UIButton = UIButton(frame: CGRect(x: Width - 50, y: 7, width: 40, height: 29))
        searchBtn.setTitle("取消", for: UIControlState())
        searchBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        searchBtn.setTitleColor(UIColor(rgb: 333333), forState: UIControlState.Normal)
        searchBtn.addTarget(self, action: #selector(LifeSearchViewController.searchBarBtnClick(_:)), for: UIControlEvents.touchUpInside)
        searchBtn.centerY = headBgView.middleY
        headBgView.addSubview(searchBarTextField)
        headBgView.addSubview(searchBtn)
        self.view.addSubview(headBgView)
        
        let lineView: UIView = UIView(frame: CGRect(x: 0, y: headBgView.height - 1, width: Width, height: 1))
        lineView.backgroundColor = UIColor(red: 224/255, green: 225/255, blue: 227/255, alpha: 1)
        headBgView.addSubview(lineView)

        
    }
    
    //MARK: -初始化三个标签
    func initLabel() {
        //初始化标签栏背景视图
        labelBgView = UIView(frame: CGRect(x: 0, y: -53/*headBgView.bottom*/, width: Width, height: 53))
        labelBgView.backgroundColor = UIColor.white
        //创建数组
        let lableArr:Array<String> = ["照片","用户","商品"]
        let lableBtnWidth:CGFloat = Width / 3 * 0.5 + 30
        let lableMarginLeft:CGFloat = (Width - ((Width / 3 * 0.5 + 30) * 3 ) ) * 0.5
        //初始化红线
        labelLineView = UIView(frame: CGRect(x: lableMarginLeft, y: labelBgView.height - 2, width: lableBtnWidth, height: 2))
        labelLineView.backgroundColor = UIColor.red
        labelBgView.addSubview(labelLineView)
    
        //循环创建标签button 
        for (index ,lableStr) in lableArr.enumerated() {
            print(lableBtnWidth)
            print(index)
            let btn:UIButton = UIButton(frame: CGRect(x: lableMarginLeft + CGFloat(index) * lableBtnWidth , y: 0, width: lableBtnWidth , height: 29))
            btn.centerY = labelBgView.middleY
            
            btn.setTitle(lableStr, for: UIControlState())
            btn.setTitleColor(UIColor(stringReb: "#8B8E97"), forState: UIControlState.Normal)
            btn.tag = LABELBTN_TAG + index
            btn.addTarget(self, action: #selector(LifeSearchViewController.clickLabelBtn(_:)), for: UIControlEvents.touchUpInside)
            labelBgView.addSubview(btn)
        }
        self.view.addSubview(labelBgView)
    }
    
    //MARK: -初始化web
    func initWeb() {
        //初始化照片Web
        potoWeb = WebView(frame: CGRect(x: 0, y: headBgView.bottom/*labelBgView.bottom*/, width: Width, height: Height - headBgView.bottom/*labelBgView.bottom*/), delegates: self,isRefersh: false)
    
        potoWeb.request = potoUrl
        self.view.addSubview(potoWeb)
        //初始化商品Web
        productWeb = WebView(frame: CGRect(x: 0, y: self.headBgView.bottom + 50, width: Width, height: Height - (self.headBgView.bottom + 50)), delegates: self,isRefersh: false)
        productWeb.request = productUrl
 
        productWeb.hidden = true
        self.view.addSubview(productWeb)
    }
    
    //MARK: -初始化用户搜索结果控制器
    func initSearchUserVC() {
        friendSearchVC = FriendSearchTableViewController()
        friendSearchVC.tableView.frame = CGRect(x: 0, y: self.headBgView.bottom + 50, width: Width, height: Height - (self.headBgView.bottom + 50))
        friendSearchVC.tableView.hidden = true
        friendSearchVC.delegates = self
        self.view.addSubview(friendSearchVC.tableView)
        self.view.bringSubview(toFront: headBgView)
        
        
    }

    
    //MARK: -点击按钮方法
    //MARK: - 搜索框按钮点击方法
    func searchBarBtnClick(_ sender:UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    //MARK: - 点击标签栏按钮方法
    func clickLabelBtn(_ sender:UIButton) {
        let potoBtn = labelBgView.viewWithTag(LABELBTN_TAG) as! UIButton
        let userBtn = labelBgView.viewWithTag(LABELBTN_TAG + 1) as! UIButton
        let productBtn = labelBgView.viewWithTag(LABELBTN_TAG + 2) as! UIButton
        labelLineView.centerX = sender.centerX
        if sender.tag == LABELBTN_TAG {
            potoWeb.hidden = false
            productWeb.hidden = true
            friendSearchVC.tableView.hidden = true
            menthod = "searchResult"
            potoBtn.setTitleColor(UIColor(stringReb: "#E85332"), forState: UIControlState.Normal)
            userBtn.setTitleColor(UIColor(stringReb: "#8B8E97"), forState: UIControlState.Normal)
            productBtn.setTitleColor(UIColor(stringReb: "#8B8E97"), forState: UIControlState.Normal)
            if searchBarTextField.text != "" {
                searchResult()
            }
        }
        if sender.tag == LABELBTN_TAG + 1 {
            potoWeb.hidden = true
            productWeb.hidden = true
            friendSearchVC.tableView.hidden = false
            menthod = "searchBarSearchUserBtnClicked"
            potoBtn.setTitleColor(UIColor(stringReb: "#8B8E97"), forState: UIControlState.Normal)
            userBtn.setTitleColor(UIColor(stringReb: "#E85332"), forState: UIControlState.Normal)
            productBtn.setTitleColor(UIColor(stringReb: "#8B8E97"), forState: UIControlState.Normal)
            if searchBarTextField.text != "" {
//                searchBarSearchUserBtnClicked()
            }
        }
        if sender.tag == LABELBTN_TAG + 2 {
            potoWeb.hidden = true
            productWeb.hidden = false
            friendSearchVC.tableView.hidden = true
              menthod = "searchResult"
            potoBtn.setTitleColor(UIColor(stringReb: "#8B8E97"), forState: UIControlState.Normal)
            userBtn.setTitleColor(UIColor(stringReb: "#8B8E97"), forState: UIControlState.Normal)
            productBtn.setTitleColor(UIColor(stringReb: "#E85332"), forState: UIControlState.Normal)
            if searchBarTextField.text != "" {
                searchResult()
            }
        }
    }
    
    //MARK: - h5搜索
    func searchResult() {
        if potoWeb.hidden == false {
          //potoWeb.evaluateJavaScript("window.showSearchResult(2,\(searchBarTextField.text!))", completionHandler: nil)
            print(searchBarTextField.text!)
           // potoWeb.isLoad = true
            //potoWeb.evaluateJavaScript("window.location.reload();", completionHandler: nil)
            potoWeb.evaluateJavaScript("showSearchResult(2,'\(searchBarTextField.text!)')", completionHandler: { (a, e) -> Void in
                print(a)
                print(e)
            })
        }else if  productWeb.hidden == false {
           // productWeb.isLoad = true
            productWeb.evaluateJavaScript("showSearchResult(3,'\(searchBarTextField.text!)')", completionHandler: { (a, e) -> Void in
                print(a)
                print(e)
            })
        }
    }
    
    //MARK: - 汉字转拼音
    func getPreString(_ str: String) ->String {
        let ms = NSMutableString(string: str)
        CFStringTransform(ms, nil, kCFStringTransformMandarinLatin, false)
        CFStringTransform(ms, nil, kCFStringTransformStripDiacritics, false)
        var fristPinyin = ""
        if ms != "" {
            
            fristPinyin = ms.substring(to: 1)
            
        }
        return  fristPinyin.uppercased()
        
    }
    
    //MARK: -排序
    func formtUser(_ userList:inout [ChatUserInfo]) {
//        for var i = 0; i < userList.count - 1; i++ {
//            for var k = i + 1;k < userList.count; k++ {
//              let b =  Constants.sortS(getPreString(userList[i].username),bstr:getPreString( userList[k].username))
//                if b == false {
//                    let user = userList[i]
//                    userList[i] = userList[k]
//                    userList[k] = user
//                  
//                }
//            }
        
//        }
    
      userList = userList.sort { (str1, str2) -> Bool in
            if str1.username == "#" && str2.username !=  "#" {
                return  str1.username > str2.username
                
            }else if str2.username == "#" && str1.username != "#" {
                return  str2.username < str1.username
            }
            if str1.username > str2.username {
                return str1.username < str2.username
            }else if str1.username < str2.username {
                return str1.username < str2.username
            }
            
            return str1.username == str2.username
        }
        self.friendSearchVC.tableView.dismiss()
        isSearching = false
    }
    
    
    //MARK: - 搜索用户
//    func searchBarSearchUserBtnClicked() {
//        if isSearching == false {
//        isSearching = true
//        self.friendSearchVC.userList.removeAll(keepCapacity: true)
//         self.friendSearchVC.watchUser.removeAll(keepCapacity: true)
//        // 没有搜索内容时显示全部组件
//        self.friendSearchVC.tableView.rotate(size, imageName: "img_loading")
//        if searchBarTextField.text == "" {
//            print("空", terminator: "")
//        }else {
//            print(searchBarTextField.text!)
//            Constants.alamofireManager.request(.POST, Constants.REQUEST_USER_FOR_SEARCH_URL, parameters: ["userNick":"\(searchBarTextField.text!)","userId":"\(Constants.CURRENT_USER_ID)","pageSize":pageSize,"pageNo":currentPage]).responseJSON {
//                (r) -> Void in
//            let result = r.result
//                if result.isSuccess {
//                    if let j = result.value as? NSDictionary {
//                        self.friendSearchVC.tableView.dismiss()
//                        print("\(j)")
//                        let msg: String = j.valueForKey("code") as! String
//                        if(msg == "100"){
//                            if let s = j.valueForKey("body") as? NSArray{
//                                for ap in s {
//                                    print(ap)
//                                    
//                                    let user = ChatUserInfo.getChatUserInfo(ap as! NSDictionary)
//
//                                    if user.isfans == "0" {
//                                        self.friendSearchVC.userList.append(user)
//                                    }else {
//                                        self.friendSearchVC.watchUser.append(user)
//                                    }
//                                    
//
//                                }
//                                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
//                                  
//                                    self.formtUser(&self.friendSearchVC.userList)
//                                    self.formtUser(&self.friendSearchVC.watchUser)
//                                    
//                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                                        
//                                          self.friendSearchVC.tableView.reloadData()
//                                    })
//                                })
//                             
//                                
//                            }
//                        }
//                    }else {
//                         self.friendSearchVC.tableView.dismiss()
//                    }
//                }
//            }
//            
//           
//        }
//        }
//        
//    }
    //MARK: -搜索输入框代理方法，点击搜索执行
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
         searchBarTextField.resignFirstResponder()
        self.perform(Selector(menthod))
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.labelBgView.y = self.headBgView.bottom
            self.potoWeb.y = self.headBgView.bottom + 50
            self.potoWeb.height = Height - (self.headBgView.bottom + 50)
        }) 
        return true
    }
    
    //MARK: - 搜索结果控制街代理方法
    func pushNextController(_ vc : UIViewController){
        print(vc.classForCoder)
        if String(vc.classForCoder) != "UINavigationController" {
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            self.present(vc, animated: false, completion: { () -> Void in
                
            })
            
        }
        

    }
    // MARK: -WKScriptMessageHandler 接收到脚本信息执行
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        print("收到消息", terminator: "")
        let fun = message.name
        print(message.body, terminator: "")
        print("方法名为："+fun, terminator: "")
        let args:NSDictionary = message.body as! NSDictionary
        //登录
        if fun == "login"{
//            loginClass = LifeRootViewController.self
//            let loginView = NewUserLoginViewController()
//            self.navigationController?.pushViewController(loginView, animated: false)
        }else if fun == "navigate" {
            MyScriptHandler.navigate(self, args: args)
//            if let naviType = args["type"] {
//                
//                MyScriptHandler.shareInstance.navigateToInternal(self, args: args,method: naviType as! String)
//            }else {
//                MyScriptHandler.shareInstance.navigateToInternal(self, args: args,method: "navigateToInternal")
//            }
        }

        
    }
    //MARK: - 点击空白收起键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if searchBarTextField != nil {
          searchBarTextField.resignFirstResponder()
        }
    }
    
    
    //MARK: - 内存不足
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
