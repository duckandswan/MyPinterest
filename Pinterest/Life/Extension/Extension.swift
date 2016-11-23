//
//  Extension.swift
//  asus
//
//  Created by 张立 on 15/7/14.
//  Copyright (c) 2015年 zhangli. All rights reserved.
//

import UIKit
import AVFoundation
import WebKit

let SCREEN_W=UIScreen.main.bounds.size.width
let SCREEN_H=UIScreen.main.bounds.size.height
let STATUS_H = UIApplication.shared.statusBarFrame.size.height

extension UIView{
    
    func addRotate(isAddition:Bool) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let t = 20050
        if isAddition == true{
            if self.viewWithTag(t) != nil {
                return
            }else{
                imageView.center =
                imageView.image = UIImage(named: "img_loading")
                imageView.tag = t
                self.addSubview(imageView)
                let rotationAnimation:CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
                rotationAnimation.toValue =  CGFloat(M_PI * 2)
                
                rotationAnimation.duration = 1
                rotationAnimation.repeatCount = Float(Int.max)
                rotationAnimation.isRemovedOnCompletion = false
                rotationAnimation.fillMode = kCAFillModeForwards
                imageView.layer.add(rotationAnimation, forKey: "UIViewRotation")
            }
        }else{
            if let v = self.viewWithTag(t) {
                v.layer.removeAllAnimations()
                v.removeFromSuperview()
            }
        }
        
    }
    
    func showRotateWithOverlay(show:Bool) {
        
        var bgView:UIView!
        var imageView:UIImageView!

        if show == true{
            if self.viewWithTag(20060) != nil {
                return
            }else{
                CGRect(
                bgView = UIView.init(frame: CGRect(
                bgView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
                bgView.tag = 20060
                self.addSubview(bgView)
                
                imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
                imageView.center = self.middlePoint
                imageView.image = UIImage(named: "img_loading")
                imageView.tag = 20050
                self.addSubview(imageView)
                
                let rotationAnimation:CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
                rotationAnimation.toValue =  CGFloat(M_PI * 2)
                
                rotationAnimation.duration = 1
                rotationAnimation.repeatCount = Float(Int.max)
                rotationAnimation.removedOnCompletion = false
                rotationAnimation.fillMode = kCAFillModeForwards
                imageView.layer.addAnimation(rotationAnimation, forKey: "UIViewRotation")
            }
        }else{
            
            if let v = self.viewWithTag(20050) {
                v.layer.removeAllAnimations()
                v.removeFromSuperview()
            }
            if let v = self.viewWithTag(20060)
            {
                v.removeFromSuperview()
            }
        }
        
    }
    
    
    func rotate(size:CGSize,imageName:String) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        imageView.center = self.middlePoint
        imageView.image = UIImage(named: imageName)
        imageView.tag = 20050
        self.addSubview(imageView)
        let rotationAnimation:CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue =  CGFloat(M_PI * 2)
        
        rotationAnimation.duration = 1
        rotationAnimation.repeatCount = Float(Int.max)
        rotationAnimation.removedOnCompletion = false
        rotationAnimation.fillMode = kCAFillModeForwards
        imageView.layer.addAnimation(rotationAnimation, forKey: "UIViewRotation")
    }
    
    func dismiss() {
        if let imageView = self.viewWithTag(20050){
            imageView.layer.removeAllAnimations()
            imageView.removeFromSuperview()
        }
        
    }
}

extension UIViewController{
    
//    //当前屏幕的宽度
//    var SCREEN_W : CGFloat{
//        get{
//            return UIScreen.mainScreen().bounds.size.width
//        }
//    }
//    //当前屏幕的高度
//    var SCREEN_H : CGFloat{
//        get{
//            return UIScreen.mainScreen().bounds.size.height
//        }
//    }
    
    //navi bar 高度
    var naviH : CGFloat?{
        return navigationController?.navigationBar.frame.size.height
    }
    
//    //navi bar 宽度
//    var naviW : CGFloat?{
//        return navigationController?.navigationBar.frame.width
//    }
    
    var statuH : CGFloat{
        get{
            return  UIApplication.sharedApplication().statusBarFrame.size.height
        }
    }
    
    //隐藏导航栏
    func hideNavigationBar(){
        self.navigationController?.navigationBarHidden = true
        self.navigationController?.navigationBar.hidden = true
        self.navigationController?.navigationBar.translucent = false
    }
    
    func hideTabBar(){
        rootController.showOrhideToolbar(false)
    }
    
    //显示导航栏
    func showNavigationBar(){
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.navigationBar.translucent = false
    }
    
    //提示信息
    func errorMsg(msg:String){
        let hud = MBProgressHUD()
        view.addSubview(hud)
        hud.mode = MBProgressHUDModeText
        hud.labelText = msg
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = true
        hud.show(true)
        hud.hide(true, afterDelay: 0.7)
    }
    
    func screenWidth() -> CGFloat{
        return UIScreen.mainScreen().bounds.size.width
    }
    
    func screenHeight() -> CGFloat{
        return UIScreen.mainScreen().bounds.size.height
    }
    
    //生成uuid
    func bulidUUID() ->String{
        let uuid_ref = CFUUIDCreate(nil)
        let uuid_string_ref = CFUUIDCreateString(nil , uuid_ref)
        let uuid:String = NSString(format: uuid_string_ref) as String
        return uuid
    }
    
    func setNavigationBarColor(){
        navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        navigationController?.navigationBar.tintColor = UIColor.blackColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor(),NSFontAttributeName:UIFont(name: "HelveticaNeue", size: 18)!]
    }
    
    func navigationControllerSetting(navigationController:UINavigationController,navigationItem:UINavigationItem){
        navigationController.navigationBar.barTintColor = Constants.naviBgColor
//        navigationController.navigationBar.tintColor = UIColor.whiteColor()
        navigationItem.hidesBackButton = true
        navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(),NSFontAttributeName:UIFont(name: "HelveticaNeue", size: 18)!]
    }
    
    /**********设置透明的navigationBar**************/
    func navigationControllerSettingTransparent(navigationController : UINavigationController, navigationItem : UINavigationItem, backgroundColor: UIColor) {
        //设置navigationBar为透明
        
        
        navigationController.navigationBar.setBackgroundImage(imageWithColor(backgroundColor), forBarMetrics: UIBarMetrics.Default)
        //设置navigationBar的样式为没有边框线
        
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        
//        navigationController.navigationBar.tintColor = UIColor.whiteColor()
        navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(),NSFontAttributeName:UIFont(name: "HelveticaNeue", size: 18)!]
       
    }
    //根据传进来的颜色创建一张图片
    func imageWithColor(color : UIColor) ->UIImage
    {
        let rect = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 64);
        UIGraphicsBeginImageContext(rect.size);
        let context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context!, color.CGColor);
        CGContextFillRect(context!, rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!;
    }
    
    //设置状态栏的背景
    func setStatusbackGroudView(view : UIView) ->UIView{
        let  statusBarckView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.size.width, height: UIApplication.sharedApplication().statusBarFrame.size.height))
        statusBarckView.backgroundColor = Constants.naviBgColor
        view.addSubview(statusBarckView)
        return statusBarckView
    }
    
    /*********设置的navigationItem*****************/
    func addBarButtonItem(navigationItem:UINavigationItem , image : UIImage, action : Selector) ->UIBarButtonItem {
        return UIBarButtonItem(image:image, style: UIBarButtonItemStyle.Plain, target: self, action: action)
    }
    
    //添加返回按钮
    func addBackButton(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "btn_back"), style: UIBarButtonItemStyle.Plain, target: self, action: "back")
    }
    
    
    
    func addLeftBarButtonItem(navigationItem:UINavigationItem){

        navigationItem.leftBarButtonItem =  UIBarButtonItem(image:UIImage(named: "btn_back")!, style: UIBarButtonItemStyle.Plain, target: self, action: "leftBarButtonItemClick")
    }
    
    func addLeftBarButtonItem1(navigationController : UINavigationController) {
        //if isShow == true {
           // navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Done, target: self, action: "leftBarButtonItemClick")
        
            navigationItem.leftBarButtonItem =  UIBarButtonItem(image:UIImage(named: "btn_back")!, style: UIBarButtonItemStyle.Plain, target: self, action: "leftBarButtonItemClick")
            navigationItem.leftBarButtonItem?.imageInsets = UIEdgeInsetsMake(0, -10, 0, 0)

      
    }
    
    func addBackBarButton() {
        navigationItem.leftBarButtonItem =  UIBarButtonItem(image:UIImage(named: "btn_back")!, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(UIViewController.customBack))
        navigationItem.leftBarButtonItem?.imageInsets = UIEdgeInsetsMake(0, -10, 0, 0)
        navigationItem.leftBarButtonItem?.tintColor = UIColor.blackColor()
    }
    
    

    
    //弹出alert带按钮
    func alert(title:String,message:String,viewController:UIViewController) ->UIAlertController{
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "确认", style: UIAlertActionStyle.Default, handler: nil))
        viewController.presentViewController(alertController, animated: true, completion: nil)
        return alertController
    }
    
    //弹出alert不带按钮
    func alertWithoutButton(title:String,message:String,viewController:UIViewController) ->UIAlertController{
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        viewController.presentViewController(alertController, animated: true, completion: nil)
        return alertController
    }
    
    
    func bulidHeaderWithoutBgAndLine(viewController:UIViewController,letfButtonImage:UIImage!,titleString:String,rightString:String,rightColor:UIColor) ->UIView{
        
        let  header = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_W, height: 0))
        header.backgroundColor = UIColor.clearColor()
        if letfButtonImage != nil {
            bulidLeftButton(letfButtonImage,viewController:viewController,header:header)
        }
        header.addSubview(bulidTitle(titleString,width:SCREEN_W))
        if rightString != "" {
            bulidRightTitle(rightString,width:SCREEN_W,viewController:viewController,rightColor:rightColor,header:header)
        }
        return header
    }

    
    func bulidHeader(viewController:UIViewController,letfButtonImage:UIImage!,titleString:String,rightString:String,rightColor:UIColor) ->UIView {
        let w=UIScreen.mainScreen().bounds.size.width
        let header = UIView(frame: CGRect(x: 0, y: 0, width: w, height: 0))
        let headerLine = UIImageView(frame: CGRect(x: 0, y: 0-0.5, width: w, height: 0.5))
        headerLine.image = UIImage(named: Constants.ROW_LINE)
        header.backgroundColor = Constants.AUTO_NAVIGATIONBAR_COLOR
        
        if letfButtonImage != nil {
            bulidLeftButton(letfButtonImage,viewController:viewController,header:header)
        }
        header.addSubview(bulidTitle(titleString,width:w))
        bulidRightTitle(rightString,width:w,viewController:viewController,rightColor:rightColor,header:header)
        header.addSubview(headerLine)
        header.backgroundColor = UIColor(red: 46/255, green: 46/255, blue: 58/255, alpha:1)
        return header
    }
        
    func bulidLeftButton(letfButtonImage:UIImage,viewController:UIViewController,header:UIView){
        
        let leftButton =  UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        let leftButtonTap = UITapGestureRecognizer()//获取验证码手势
        leftButtonTap.addTarget(viewController, action: "leftButtonClick")
        leftButton.addGestureRecognizer(leftButtonTap)
        leftButton.userInteractionEnabled = true
        
        let leftImage = UIImageView(frame: CGRect(x: 10, y: 30, width: 20, height: 20))
        leftImage.image = letfButtonImage
        
        
        header.addSubview(leftButton)
        header.addSubview(leftImage)
        
        
        //        let returnButton = UIButton(type: UIButtonType.System)
        //        returnButton.frame =  CGRect(x: 7, y: 32, width: AppConstants.NAVIGATION_BUTTON_SIZE, height: AppConstants.NAVIGATION_BUTTON_SIZE)
        //        returnButton.setBackgroundImage(letfButtonImage, forState: UIControlState.Normal)
        //        returnButton.addTarget(viewController, action: "leftButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        //        return returnButton
    }

    
    
    func bulidTitle(titleString:String,width:CGFloat)  -> UILabel{
        let titleLabel = UILabel(frame: CGRectMake(0,24,width,40))
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.text = titleString
        titleLabel.font = UIFont(name: "HiraKakuProN-W3", size: 18)!
        titleLabel.textColor = UIColor.whiteColor()
        return titleLabel
    }
    
    func bulidRightTitle(rightString:String,width:CGFloat,viewController:UIViewController,rightColor:UIColor,header:UIView){
        
        let rightButton = UIImageView(frame: CGRect(x: width-80, y: 0, width: 80, height: 80))
        let rightButtonTap = UITapGestureRecognizer()//获取验证码手势
        rightButtonTap.addTarget(viewController, action: "rightButtonClick")
        rightButton.addGestureRecognizer(rightButtonTap)
        rightButton.userInteractionEnabled = true
        
        let headerRightLabel = UILabel(frame: CGRect(x: width-95, y: 24, width: 80, height: 40))
        headerRightLabel.textAlignment = NSTextAlignment.Right
        headerRightLabel.text = rightString
        headerRightLabel.font = UIFont(name: "HelveticaNeue", size: 18)!
        headerRightLabel.textColor = rightColor
        
        header.addSubview(rightButton)
        header.addSubview(headerRightLabel)
    }
    
    //MARK: - url做缓存处理
    func doUrlCache(webView:WebView,url:String) {
        
        let requests:NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: url)!, cachePolicy: NSURLRequestCachePolicy.ReloadRevalidatingCacheData, timeoutInterval: 60)
        let response  = urlCache.cachedResponseForRequest(requests)
        if response != nil {
            requests.cachePolicy = NSURLRequestCachePolicy.ReturnCacheDataDontLoad
        }
        webView.request = requests

    }
    
    
    func load(task: () ->()) {
        for _ in 0..<10 {
            task()
        }
    }
    
}


//扩展UIColor属性，16进制颜色转换为UIColor对象
//
extension UIColor {
    //调用方式 UIColor(rgb: 0x2f8916)
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    //调用方式 UIColor(rgba: "#2f8916")
    convenience init(stringReb: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        if stringReb.hasPrefix("#") {
             //let index =  advanc
            let index   =   stringReb.startIndex.advancedBy(1) //advance(stringReb.startIndex, 1)
            
           
            let hex     = stringReb.substringFromIndex(index)
            let scanner = NSScanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexLongLong(&hexValue) {
                switch (hex.stringLength()) {
                case 3:
                    red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                    green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                    blue  = CGFloat(hexValue & 0x00F)              / 15.0
                case 4:
                    red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                    green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                    blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                    alpha = CGFloat(hexValue & 0x000F)             / 15.0
                case 6:
                    red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                    blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
                case 8:
                    red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
                default:
                    print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8")
                }
            } else {
                print("Scan hex error")
            }
        } else {
            print("Invalid RGB string, missing '#' as prefix")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}
//没有数据占位图
extension UIView{
    //没有相关
    func addNoDataDefaultImageView(isadd:Bool, imgName:String = "img_collect-1"){
        let t = 8080
        if isadd == true{
            if viewWithTag(t) != nil {
                return
            }
            
            let imageW:CGFloat = SCREEN_W / 3
            let image = UIImage(named:imgName)!
            let defaulImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageW, height: imageW * image.size.height / image.size.width))
            defaulImageView.center = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
            defaulImageView.image = UIImage(named:imgName)
            defaulImageView.tag = t
            addSubview(defaulImageView)
        }else{
            if let dv = viewWithTag(t){
                dv.removeFromSuperview()
            }
        }
        
        
    }
    //网络不好
    func addBadNetworkingDefaultImageView(isadd:Bool, target:AnyObject? = nil, action: Selector? = nil, imgName:String? = nil){
        let t = 9090
        if isadd == true{
            if viewWithTag(t) != nil {
                return
            }
            
            let iName = "img_net"
            
            let whiteView = UIView(frame: bounds)
            whiteView.backgroundColor = LifeConstant.mainBackgroundColor
            let imageW:CGFloat = SCREEN_W / 3
            let image = UIImage(named:iName)!
            let defaulImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageW, height: imageW * image.size.height / image.size.width))
            defaulImageView.center = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
            defaulImageView.image = image
            whiteView.addSubview(defaulImageView)
            whiteView.tag = t
            if  target != nil && action != nil {
                let gestureRecognizer = UITapGestureRecognizer(target: target!, action: action!)
                gestureRecognizer.numberOfTapsRequired = 1
                whiteView.addGestureRecognizer(gestureRecognizer)
            }
            addSubview(whiteView)
        }else{
            if let dv = viewWithTag(t){
                dv.removeFromSuperview()
            }
        }
        
        
    }
}

extension UIViewController{
    //MARK: - 初始化头部
    func initCustomNavigationBar(name:String) {
        
        let headBgView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_W, height: 64))
        headBgView.backgroundColor = UIColor.whiteColor()
        
        
        let headTitle = UILabel(frame: CGRect(x: 0, y: 0, width: SCREEN_W - 128, height: 30))
        headTitle.text = name
        headTitle.textColor = UIColor.blackColor()
        headTitle.font = UIFont.boldSystemFontOfSize(18)
        headTitle.textAlignment = .Center
        headTitle.center.y = (headBgView.frame.size.height) * CGFloat(0.5) + 10
        headTitle.center.x = headBgView.center.x
        
        let leftBtn = UIButton(frame: CGRect(x: 0, y: 20, width: 44, height: 44))
        leftBtn.setImage(UIImage(named: "btn_back"), forState: UIControlState.Normal)
        leftBtn.addTarget(self, action: #selector(UIViewController.customBack), forControlEvents: UIControlEvents.TouchUpInside)
        
        headBgView.addSubview(leftBtn)
        headBgView.addSubview(headTitle)
        self.view.addSubview(headBgView)
        
        let lineView: UIView = UIView(frame: CGRect(x: 0, y: headBgView.height - 1, width: headBgView.width, height: 1))
        lineView.backgroundColor = UIColor(red: 224/255, green: 225/255, blue: 227/255, alpha: 1)
        headBgView.addSubview(lineView)
    }
    
    func customBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }
}

extension NSDictionary{
    
    func stringArrForKey(key:String)->[String]{
        if self[key] is NSArray{
            return (self[key] as? [String]) ?? []
        }else{
            return []
        }
    }
    
    func stringForKey(key:String, df:String = "")->String{
        if self[key] is String{
            return self[key] as! String
        }else if self[key] is NSNumber {
            return String(self[key] as! NSNumber) ?? df
        }else{
            return df
        }
    }
    
    func intForKey(key:String, df:Int = 0)->Int{
        if self[key] is NSNumber{
            return self[key] as! Int
        }else if self[key] is String{
            return (Int(self[key] as! String) ?? df)
        }else{
            return df
        }
    }
    
    func doubleForKey(key:String,df:Double = 0.0)->Double{
        if self[key] is NSNumber{
            return (self[key] ?? df) as! Double
        }else if self[key] is String{
            return (Double(self[key] as! String) ?? df)
        }else{
            return df
        }
    }
    
    func dicArrForKey(key:String)->[NSDictionary]{
        return (self[key] ?? Array<NSDictionary>()) as! [NSDictionary]
    }
    
    func dicForKey(key:String)->NSDictionary{
        return (self[key] ?? NSDictionary()) as! NSDictionary
    }
}

extension UIScrollView{
    
    
    //MARK: -下拉刷新，上拉加载更多
    func addHeaderRefresh(obj:AnyObject, action:Selector) {
        if self.gifHeader == nil{
            let img = UIImage(named: "img_loading")
            self.addGifHeaderWithRefreshingTarget(obj, refreshingAction: action)
            self.gifHeader.setRefreshingmages([img!])
            self.gifHeader.setIdleImsages([img!])
            self.gifHeader.stateHidden = true
            self.gifHeader.updatedTimeHidden = true
        }
    }
    
    func addFooterRefresh(obj:AnyObject, action:Selector) {
        if self.gifFooter == nil {
            self.addGifFooterWithRefreshingTarget(obj, refreshingAction: action)
            self.gifFooter.refreshingImages = [UIImage(named: "img_loading")!]
            self.gifFooter.stateHidden = true
            self.gifFooter.setTitle("", forState: MJRefreshFooterStateRefreshing)
            self.gifFooter.setTitle("", forState: MJRefreshFooterStateIdle)
        }
    }
    
    //MARK: -下拉刷新，上拉加载更多
    func addHeaderRefresh(block:()->Void) {
        self.addGifHeaderWithRefreshingBlock(block)
        let img = UIImage(named: "img_loading")
        self.gifHeader.setRefreshingmages([img!])
        self.gifHeader.setIdleImsages([img!])
        self.gifHeader.stateHidden = true
        self.gifHeader.updatedTimeHidden = true
    }
    
    func addFooterRefresh(block:()->Void) {
        self.addGifFooterWithRefreshingBlock(block)
        self.gifFooter.refreshingImages = [UIImage(named: "img_loading")!]
        self.gifFooter.stateHidden = true
        self.gifFooter.setTitle("", forState: MJRefreshFooterStateRefreshing)
        self.gifFooter.setTitle("", forState: MJRefreshFooterStateIdle)
    }
    
    
}

extension UIImageView{
    func setHeadImageForUsIpWithURL(url:String){
        self.sd_setImageWithURL(NSURL(string: url.changeImageUrlToUsIp()), placeholderImage:  UIImage.init(named: "head_big_default"), options:.RetryFailed)
    }
    
    func setImageForUsIpWithURL(url:String){
        self.sd_setImageWithURL(NSURL(string: url.changeImageUrlToUsIp()), placeholderImage:  LifeUtils.placeholderImage, options:.RetryFailed)
    }
    
    func setImageForUsIpWithURLWithNoBG(url:String, size:Int = 500){
        self.sd_setImageWithURL(NSURL(string: url.changeImageUrlToUsIp().adjustImageUrlWithSize(size)))
    }
}

extension UICollectionView{
    //    func insertItemsToNumber(number:Int,atSection section:Int){
    //        let n = self.numberOfItemsInSection(section)
    //        var indexPathArr:[NSIndexPath] = []
    //        for i in n..<number{
    //            indexPathArr.append(NSIndexPath(forRow: i, inSection: section))
    //        }
    //        self.insertItemsAtIndexPaths(indexPathArr)
    //    }
    
    func insertItemsToSection(section:Int){
        let n = self.numberOfItemsInSection(section)
        let number = self.dataSource!.collectionView(self, numberOfItemsInSection: section)
        if n == number {
            return
        }
        var indexPathArr:[NSIndexPath] = []
        for i in n..<number{
            indexPathArr.append(NSIndexPath(forRow: i, inSection: section))
        }
        self.insertItemsAtIndexPaths(indexPathArr)
    }
    
    func reloadAllSections(){
        let n = self.numberOfSections()
        UIView.performWithoutAnimation({
            self.reloadSections(NSIndexSet(indexesInRange: NSMakeRange(0, n)))
        })
    }
    
}

extension UITableView{
    
    func insertSections(){
        let n = self.numberOfSections
        let number = self.dataSource!.numberOfSectionsInTableView!(self)
        if n == number {
            return
        }
        let indexSet = NSMutableIndexSet()
        for i in n..<number{
            indexSet.addIndex(i)
        }
        self.insertSections(indexSet, withRowAnimation: UITableViewRowAnimation.Automatic)
    }

}


