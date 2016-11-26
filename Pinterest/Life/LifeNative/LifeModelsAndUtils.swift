//
//  LifeModelsAndUtils.swift
//  finding
//
//  Created by bob song on 16/9/19.
//  Copyright © 2016年 zhangli. All rights reserved.
//

import UIKit

class LifeData{
    var pageNo = 1
    let pageSize = 10
    var lifeModels:[LifeModel] = []
    var storyId = 0
    var canRequest = true
    var isEnd = false
    var yOffset:CGFloat = 0
}

class LifeModel:NSObject{
    var avatar = "";
    var collectionImgArr:[String] = []
    var collectionName = ""
    var collectionUrl = ""
    var content = ""
    var isfans = 0
    var islike = 0
    var iscollect = 0
    var likeSize = 0
    var release_time = ""
    var releaseTime = ""
    var replySize = 0
    var sequence_num = 0
    var sizes:[NSDictionary] = []
    var slogon = ""
    var source = ""
    var storyCollectionId = 0
    var userId = 0
    var userNick = ""
    var tagId:[String] = []
    var tagName:[String] = []
    var article_url = ""
    var sponsored_url = ""
    var sponsored_url_type = 0
    var goods_title = ""
    var tagList:[NSDictionary] = []
    var readFlag = 0
    var remarks = ""
    
    //是否加载了内页数据
    var isSet = false

    func setValueForDic(_ dic:NSDictionary){
        
        avatar = dic.string(forKey: "avatar")
        collectionImgArr = dic.stringArr(forKey: "collectionImgArr")
        content = dic.string(forKey: "content")
        likeSize = dic.int(forKey: "likeSize")
        replySize = dic.int(forKey: "replySize")
        collectionName = dic.string(forKey: "collectionName")
        collectionUrl = dic.string(forKey: "collectionUrl")
        sequence_num = dic.int(forKey: "sequence_num")
        sizes = sizeArrForJsonString(dic)
        slogon = dic.string(forKey: "slogon")
        source = dic.string(forKey: "source")
        storyCollectionId = dic.int(forKey: "storyCollectionId")
        userId = dic.int(forKey: "userId")
        userNick = dic.string(forKey: "userNick")
        remarks = dic.string(forKey: "remarks")
        //设置高度
        setH()
    }
    
    //内页
    func setValueForDicInSecondStep(_ dic:NSDictionary){
        if isSet == true{
            return
        }
        
        iscollect = dic.int(forKey: "collection")
        article_url = dic.string(forKey: "article_url")
        sponsored_url_type = dic.int(forKey: "sponsored_url_type")
        sponsored_url = dic.string(forKey: "sponsored_url")
        goods_title = dic.string(forKey: "goods_title")
        readFlag = dic.int(forKey: "readFlag")
        
        
        if let storyCollection = dic["storyCollection"] as? NSDictionary {
            isfans = storyCollection.int(forKey: "isfans")
            islike = storyCollection.int(forKey: "islike")
            tagList = storyCollection.dicArr(forKey: "tagList")
        }
        
        isSet = true
    }
    
    func sizeArrForJsonString(_ dic:NSDictionary)->[NSDictionary]{
        let str = (dic["sizes"] ?? "[]") as! NSString
        
        let data = str.data(using: String.Encoding.utf8.rawValue)
        var arr = ((try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)) ?? [NSDictionary]()) as! [NSDictionary]
        if arr.count < collectionImgArr.count{
            for _ in arr.count..<collectionImgArr.count {
                arr.append(["width":NSNumber(value: 500 as Int),"height":NSNumber(value: 500 as Int)])
            }
        }
        
        
        return arr
    }
    
    var height:CGFloat = 0
    var bigHeight:CGFloat = 0
    var imagesH:CGFloat = 0
    var bigImagesH:CGFloat = 0
    var titleH:CGFloat = 0
    var contentH:CGFloat = 0
//    var contentListH:CGFloat = 0
    var bigTitleH:CGFloat = 0
    var bigContentH:CGFloat = 0
    
    var bigImageY:CGFloat = 0
    
    var relatedHeight:CGFloat = 0
    
    func getImagesHeight(_ width:CGFloat)->CGFloat{
        var hg:CGFloat = 0

        for size in sizes{
            hg += (size["height"] as! CGFloat)/(size["width"] as! CGFloat)*width
        }
        return hg
    }
    
    //设置高度
    func setH(){
        //        print("sizes:\(sizes)")
        
        height = 0
        
        let width = WaterFlowViewLayout.columnWidth
        
        imagesH = getImagesHeight(width)
        height += imagesH
        
        let set = CharacterSet(charactersIn: "\n")
        content = content.trimmingCharacters(in: set)
        
        if collectionName != "" {
            //            titleH += LifeUtils.calculateSizeForStr(collectionName, size: CGSizeMake(width - LifeConstant.margin, LifeConstant.titleHeight), font: LifeConstant.titleFont).height
            titleH += LifeUtils.calculateHeightForTitleStr(collectionName)
            height += titleH
            height += LifeConstant.margin
        }

        contentH += LifeUtils.calculateHeightForContentStr(content)
        height += contentH
        height += LifeConstant.margin
        height += LifeConstant.margin
        
        if likeSize != 0 || replySize != 0 {
            height += 20
        }
        
        height += 50
        
        //内页高度
        bigHeight = 0
        //头部
        bigHeight += LifeConstant.BIG_HEAD_HEIGHT
        
        if collectionName != "" {
            bigTitleH = LifeUtils.calculateHeightForBigTitleStr(collectionName)
            bigHeight += bigTitleH
            bigHeight +=  LifeConstant.articleMargin
        }
        
        //间隔
        bigHeight +=  LifeConstant.articleMargin
        
        bigImageY = bigHeight
        
        bigImagesH += (LifeConstant.bigInnerWidth / width) * imagesH
        bigHeight += bigImagesH
        
        //内容
        bigContentH = LifeUtils.calculateHeightForBigContentStr(content) + LifeConstant.articleMargin
        bigHeight += bigContentH
        
        //阅读
        bigHeight += LifeConstant.BIG_READ_HEIGHT
        //        bigHeight += LifeConstant.margin/2
        
        //tag
        bigHeight += LifeConstant.BIG_TAG_HEIGHT
        
        //喜欢
        bigHeight += LifeConstant.BIG_LIKE_HEIGHT
        
        //底部相关内容
        bigHeight += 40
        
        //相关高度
        relatedHeight = bigHeight + 24
        
    }
    
}

class LifeCategoryModel:NSObject{
    
    var categoryId = 0
    var categoryName = ""
    
    func setValueForDic(_ dic:NSDictionary){
        categoryId    = dic.int(forKey: "categoryId")
        categoryName  = dic.string(forKey: "categoryName")
    }
}



class LifeConstant{
    static let titleFont = UIFont.boldSystemFont(ofSize: 12.5)
    static let contentFont = UIFont.systemFont(ofSize: 11.5)
    static let darenContentFont = UIFont.boldSystemFont(ofSize: 11.5)
    
    static let width = WaterFlowViewLayout.columnWidth
    static let margin:CGFloat = 5
    static let innerWidth:CGFloat = width - margin * 2
    
    static let titleHeight:CGFloat = 45
    static let contentHeight:CGFloat = 55
    
    static let darenContentHeight:CGFloat = 75
    
    static let bigTitleHeight:CGFloat = CGFloat.greatestFiniteMagnitude
    static let bigContentHeight:CGFloat = CGFloat.greatestFiniteMagnitude
    
    static let bigWidth = UIScreen.main.bounds.size.width
    static let bigMargin:CGFloat = 10
    static let bigInnerWidth:CGFloat = bigWidth - bigMargin * 2
    
    static let articleMargin:CGFloat = margin
    
    static let bigTitleFont = UIFont.boldSystemFont(ofSize: 16)
    static let bigContentFont = UIFont.systemFont(ofSize: 14)
    
    static let mainBackgroundColor = UIColor(red: 237/255.0, green: 236/255.0, blue: 245/255.0, alpha: 1)
    
    static let redFontColor = UIColor(red: 226/255.0, green: 74/255.0, blue: 44/255.0, alpha: 1)
    
    static let BOTTOM_HEIGHT:CGFloat = 50
    
    static let BIG_HEAD_HEIGHT:CGFloat = 70
    static let BIG_TAG_HEIGHT:CGFloat = 25
    static let BIG_LIKE_HEIGHT:CGFloat = 30
    static let BIG_READ_HEIGHT:CGFloat = 20
    
    static var contentAttributesDic:[String : AnyObject] = {
//        var style: NSMutableParagraphStyle = NSMutableParagraphStyle()
//        style.lineSpacing = 5
//        let dic = [NSFontAttributeName : LifeConstant.contentFont, NSParagraphStyleAttributeName:style] as [String : AnyObject]
//        return dic
        attributesDicFor(font: LifeConstant.contentFont, lineSpacing: 5)
    }()
    
    static var titleAttributesDic:[String : AnyObject] = {
//        var style: NSMutableParagraphStyle = NSMutableParagraphStyle()
//        style.lineSpacing = 5
//        let dic = [NSFontAttributeName : LifeConstant.titleFont, NSParagraphStyleAttributeName:style]
//        return dic
        attributesDicFor(font: LifeConstant.titleFont, lineSpacing: 5)
    }()
    
    static var bigContentAttributesDic:[String : AnyObject] = {
//        var style: NSMutableParagraphStyle = NSMutableParagraphStyle()
//        style.lineSpacing = 7
//        let dic = [NSFontAttributeName : LifeConstant.bigContentFont, NSParagraphStyleAttributeName:style]
//        return dic
        attributesDicFor(font: LifeConstant.bigContentFont, lineSpacing: 7)
    }()
    
    static var bigTitleAttributesDic:[String : AnyObject] = {
//        var style: NSMutableParagraphStyle = NSMutableParagraphStyle()
//        style.lineSpacing = 7
//        let dic = [NSFontAttributeName : LifeConstant.bigTitleFont, NSParagraphStyleAttributeName:style]
//        return dic
        attributesDicFor(font: LifeConstant.bigTitleFont, lineSpacing: 7)
    }()
    
    static func attributesDicFor(font:UIFont, lineSpacing :CGFloat)->[String : AnyObject]{
        let style: NSMutableParagraphStyle = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        let dic = [NSFontAttributeName : font, NSParagraphStyleAttributeName:style]
        return dic
    }
}

class LifeUtils{
    
    static func request(url:String,pamams:[String : Any]?, successClosure: ((_ body:AnyObject) -> Void)?, failureClosure: (() -> Void)?, nullClosure: (() -> Void)? = {}){
//        LifeConstant.manager.request(.POST, url, parameters:pamams).responseJSON {
//            (r) -> Void in
//            let result = r.result
//            print("req: \(r.request)")
//            print("pamams: \(pamams)")
//            print("request?.HTTPBody:\(r.request?.HTTPBody)")
//            if result.isSuccess{
//                print("访问服务器成功")
//                print("result.value: \(result.value)")
//                let codeString = String((result.value)!.valueFor("code")!)
//                if codeString == "100" {
//                    print("code 100")
//                    let body = (result.value as! NSDictionary).valueFor("body")!
//                    successClosure?(body: body)
//                }else if codeString == "103" {
//                    print("code 103")
//                    nullClosure?()
//                    failureClosure?()
//                }else{
//                    print("code \(codeString)")
//                    failureClosure?()
//                }
//            }else{
//                print("访问服务器失败")
//                failureClosure?()
//            }
//        }
        print("pamams:\(pamams)")
        var request = URLRequest(url:URL(string: url)!)
        request.httpMethod = "POST"
//        let bodyString = "key1=value&key2=value&key3=value"
        var bodyString = ""
        if let ps = pamams {
            for key in ps.keys{
                bodyString += "\(key)=\(ps[key]!)&"
            }
        }
        bodyString.remove(at: bodyString.index(before: bodyString.endIndex))
        print("url:\(url)")
        print("bodyString:\(bodyString)")
        request.httpBody = bodyString.data(using: String.Encoding.utf8)
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error {
                print("error: \(error)")
                DispatchQueue.main.async { () -> Void in
                    failureClosure?()
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async { () -> Void in
                    failureClosure?()
                }
                return
            }
            print("data: \(data)")
            
            if let result = try? JSONSerialization.jsonObject(with: data, options: .allowFragments){
                let resultDic = result as! NSDictionary
                print("resultDic: \(resultDic)")
                print("访问服务器成功")
                let codeString = resultDic.string(forKey: "code")
                if codeString == "100" {
                    print("code 100")
                    let body = resultDic.value(forKey:"body") as AnyObject
                    DispatchQueue.main.async { () -> Void in
                        successClosure?(body)
                    }
                }else if codeString == "103" {
                    print("code 103")
                    DispatchQueue.main.async { () -> Void in
                        nullClosure?()
                        failureClosure?()
                    }
                }else{
                    print("code \(codeString)")
                    DispatchQueue.main.async { () -> Void in
                        failureClosure?()
                    }
                }
            }else{
                DispatchQueue.main.async { () -> Void in
                    failureClosure?()
                }
            }
            
        }).resume()
        
    }
    
    static func requestAndCache(_ url:String,pamams:[String : Any]?, successClosure: ((_ body:AnyObject) -> Void)?, failureClosure: (() -> Void)?, nullClosure: (() -> Void)? = {}){
        
        let userDefaults = UserDefaults.standard
        let key = url + (pamams?.description ?? "")
        
        LifeUtils.request(url: url, pamams:pamams!, successClosure:
            { (bodyData) in
                
                userDefaults.set(bodyData , forKey: key)
                successClosure?(bodyData )
                
        }, failureClosure: failureClosure!,nullClosure:nullClosure!)
        
    }
    
    static func arrForJsonString(_ str:NSString)->[NSDictionary]{
        let data = str.data(using: String.Encoding.utf8.rawValue)
        let obj = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
        return (obj as! [NSDictionary])
    }
    
    static func calculateHWRatioFromString(_ str:String)->CGFloat{
        let arr = str.components(separatedBy: ",")
        if arr.count == 2{
            let w = Int(arr[0])
            let h = Int(arr[1])
            if w != nil && h != nil{
                return CGFloat(h!)/CGFloat(w!)
            }else{
                return 1
            }
        }else{
            return 1
        }
    }
    
    static func calculateHeightForBigContentStr(_ str:String)->CGFloat{
        let maximumLabelSize = CGSize(width: LifeConstant.bigInnerWidth, height: LifeConstant.bigContentHeight)
        let expectedLabelRect = str.boundingRect(with: maximumLabelSize, options: [.usesLineFragmentOrigin,.usesFontLeading], attributes: LifeConstant.bigContentAttributesDic, context: nil)
        return expectedLabelRect.size.height
    }
    
    static func calculateHeightForBigTitleStr(_ str:String)->CGFloat{
        let maximumLabelSize = CGSize(width: LifeConstant.bigInnerWidth, height: LifeConstant.bigTitleHeight)
        let expectedLabelRect = str.boundingRect(with: maximumLabelSize, options: [.usesLineFragmentOrigin,.usesFontLeading], attributes: LifeConstant.bigTitleAttributesDic, context: nil)
        return expectedLabelRect.size.height
    }
    
    static func calculateHeightForContentStr(_ str:String)->CGFloat{
        let maximumLabelSize = CGSize(width: LifeConstant.innerWidth, height: LifeConstant.contentHeight)
        let expectedLabelRect = str.boundingRect(with: maximumLabelSize, options: [.usesLineFragmentOrigin,.usesFontLeading], attributes: LifeConstant.contentAttributesDic, context: nil)
        return expectedLabelRect.size.height
    }
    
    static func calculateHeightForTitleStr(_ str:String)->CGFloat{
        let maximumLabelSize = CGSize(width: LifeConstant.innerWidth, height: LifeConstant.titleHeight)
        let expectedLabelRect = str.boundingRect(with: maximumLabelSize, options: [.usesLineFragmentOrigin,.usesFontLeading], attributes: LifeConstant.titleAttributesDic, context: nil)
        return expectedLabelRect.size.height
    }
    
    static func calculateHeightForDarenStr(_ str:String)->CGFloat{
        let maximumLabelSize = CGSize(width: LifeConstant.innerWidth, height: LifeConstant.darenContentHeight)
        let expectedLabelRect = str.boundingRect(with: maximumLabelSize, options: [.usesLineFragmentOrigin,.usesFontLeading], attributes: LifeConstant.bigContentAttributesDic, context: nil)
        return expectedLabelRect.size.height
    }
    
    static var placeholderImage:UIImage = {
        let size = CGSize(width: 50, height: 50)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.white.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }()
    
    static func calculateSizeForStr(_ str:String,size:CGSize,font:UIFont)->CGSize{
        let dic = [NSFontAttributeName : font]
        let expectedLabelRect = str.boundingRect(with: size, options: [.usesLineFragmentOrigin,.usesFontLeading], attributes: dic, context: nil)
        return expectedLabelRect.size
    }
    
    static func calculateTitleHeightForStr(_ str:String)->CGFloat{
        return calculateSizeForStr(str, size: CGSize(width: LifeConstant.bigInnerWidth, height: LifeConstant.bigTitleHeight), font: LifeConstant.bigTitleFont).height
    }
    
    static func imageForView(_ view:UIView)->UIImage{
        UIGraphicsBeginImageContextWithOptions(view.frame.size, true, 0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    static func executeInMainQueue(_ closure: @escaping () -> Void){
        DispatchQueue.main.async { () -> Void in
            closure()
        }
    }
    
    static func executeInGlobalQueue(_ closure: @escaping () -> Void){
        DispatchQueue.global().async {
            closure()
        }
    }
    
    static func aspectFitFrameForFrame(_ frame:CGRect,size:CGSize)->CGRect{
        var newFrame = frame
        if size.width * frame.size.height >= size.height * frame.size.width{
            newFrame.size.height = (size.height * frame.size.width) / size.width
            newFrame.origin.y += (frame.size.height - newFrame.size.height) / 2
        }else{
            newFrame.size.width = (size.width * frame.size.height) / size.height
            newFrame.origin.x += (frame.size.width - newFrame.size.width) / 2
        }
        return newFrame
    }
}
