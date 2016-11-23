//
//  AnswerViewController.swift
//  finding
//
//  Created by zhoumin on 16/5/9.
//  Copyright © 2016年 zhangli. All rights reserved.
//

import UIKit

class AnswerViewController: UIViewController, UITextViewDelegate {

    var questionIndex = 0
    var questionModel:QuestionModel!
    var answerTextView:UITextView!
    var countLabel:UILabel!
    var placeHolderLabel:UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        BaiduMobStat.defaultStat().pageviewStartWithName("我来回答")
        MobClick.beginLogPageView("我来回答")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //结束百度统计
        BaiduMobStat.defaultStat().pageviewEndWithName("我来回答")
        MobClick.endLogPageView("我来回答")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.init(rgb: 0xf0eff5)
        initHeadView()
        
        let bgView = UIView()
        bgView.backgroundColor = UIColor.white
        bgView.frame = CGRect(x: 0, y: 10 + 64, width: Width, height: Height - 219 - 44 - 64 - 10 - 30)
        self.view.addSubview(bgView)
        
        answerTextView = UITextView.init(frame: CGRect(x: 15, y: 20, width: bgView.frame.width - 30, height: bgView.frame.height - 40))
        answerTextView.font = UIFont.systemFont(ofSize: 16)
        answerTextView.textColor = UIColor.init(rgb: 0x8e8e8e)
        answerTextView.delegate = self
        answerTextView.backgroundColor = UIColor.clear
        answerTextView.textContainerInset = UIEdgeInsets.zero
        bgView.addSubview(answerTextView)
        
        
        placeHolderLabel = UILabel.init(frame: CGRect(x: 5, y: 0, width: Width, height: 21))
        placeHolderLabel.font = UIFont.systemFont(ofSize: 16)
        placeHolderLabel.textColor = UIColor.init(rgb: 0x8e8e8e)
        placeHolderLabel.text = "请输入回答......"
        answerTextView.addSubview(placeHolderLabel)
        
        countLabel = UILabel.init(frame: CGRect(x: bgView.frame.width - 100 - 15, y: bgView.frame.height - 21, width: 100, height: 21))
        countLabel.text = "0/300"
        countLabel.font = UIFont.systemFont(ofSize: 16)
        countLabel.textColor = UIColor.init(rgb: 0x8e8e8e)
        countLabel.textAlignment = .right
        bgView.addSubview(countLabel)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        leftBtn.addTarget(self, action: #selector(AnswerViewController.leftBarButtonItemClick), for: UIControlEvents.touchUpInside)
        headBgView.addSubview(leftBtn)
        //初始化标
        let lineView: UIView = UIView(frame: CGRect(x: 0, y: headBgView.height - 1, width: Width, height: 1))
        lineView.backgroundColor = UIColor(red: 224/255, green: 225/255, blue: 227/255, alpha: 1)
        headBgView.addSubview(lineView)
        
        let headTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
        headTitle.textAlignment = .center
        headTitle.text = ""
        headTitle.textColor = UIColor.black
        headTitle.font = UIFont.systemFont(ofSize: 18)
        
        headTitle.center = headBgView.middlePoint
        headTitle.centerY = (headBgView.height) * CGFloat(0.5)  + 10
        headBgView.addSubview(headTitle)
        
        //创建头部Bar右侧按钮
        let rightBtn = UIButton.init(type: .system)
        rightBtn.frame = CGRect(x: Width - 5 - 40, y: leftBtn.y, width: 40, height: 30)
        rightBtn.setTitle("发布", for: UIControlState())
        rightBtn.setTitleColor(UIColor.black, for: UIControlState())
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        rightBtn.addTarget(self, action: #selector(AnswerViewController.rightBtnClick), for: UIControlEvents.touchUpInside)
        headBgView.addSubview(rightBtn)
    }

    func leftBarButtonItemClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func rightBtnClick() {
        answerTextView.resignFirstResponder()
        
        if answerTextView.text == "" {
            TWMessageBarManager().showMessageWithTitle("", description: "内容不能为空", type: TWMessageBarMessageTypeError)
            return
        }
        
        let askId = questionModel.id
        
        MBProgressHUD.showMessage("发布中...", toView: self.view)
        
        let params:[String:AnyObject] = ["content":answerTextView.text,"askId":String(askId),"userId":Constants.CURRENT_USER_ID]
        
        NetKit.sharedInstance.doPostRequest(RequestURL.ANSWER_QUESTION, params:params, successClosure:
            { (bodyData) in
                
                MBProgressHUD.hideAllHUDsForView(self.view, animated: false)
                if self.questionModel.likes.count <= 2 && self.questionIndex == 0 {
                    NSNotificationCenter.defaultCenter().postNotificationName("GuessSendSuccess", object: nil)
                }
                NSNotificationCenter.defaultCenter().postNotificationName("ReloadUWant", object: nil)
                
                MBProgressHUD.showSuccess("发布成功")
                self.performSelector(#selector(AnswerViewController.leftBarButtonItemClick), withObject: nil, afterDelay: 1)
                
            }, failClosure: {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: false)
                MBProgressHUD.showError("发布失败", toView: self.view)
            },noDataClosure:{
                MBProgressHUD.hideAllHUDsForView(self.view, animated: false)

        })
        
        
    }
    
    //MARK:- UITextViewDelegate
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool{
        return true
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool{
        return true

    }
    func textViewDidBeginEditing(_ textView: UITextView){
        
    }
    func textViewDidEndEditing(_ textView: UITextView){
        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        return true

    }
    func textViewDidChange(_ textView: UITextView){
        if textView.text.stringLength() == 0 {
            placeHolderLabel.isHidden = false
        }else{
            placeHolderLabel.isHidden = true
        }
        
        let testStr:NSString = textView.text
        if textView.text.stringLength() >= 300 {
            textView.text = testStr.substring(to: 300)
        }
        countLabel.text = "\(textView.text.stringLength())/300"
    }
    func textViewDidChangeSelection(_ textView: UITextView){
        
    }
}
