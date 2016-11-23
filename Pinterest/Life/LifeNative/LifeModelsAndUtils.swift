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
    var isJoined = 0//是否加入看生活
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
    var type = 0
    var userId = 0
    var userNick = ""
    var user_type = 0
    var reference_price = 0.0
    var location = ""
    var tagId:[String] = []
    var tagName:[String] = []
    var wantNum = 0
    var wantType = 0
    var article_url = ""
    var sponsored_url = ""
    var sponsored_url_type = 0
    var goods_title = ""
//    var rewardPoints = 0
    
    var position = 0
    
    var tagList:[NSDictionary] = []
    
    var videoUrl = ""
    var mayaskList:[NSDictionary] = []
    
    var readFlag = 0
    
    var videoType = 0
    
    var remarks = ""
    
    var contentList:[NSDictionary] = []
    
    //是否加载了内页数据
    var isSet = false
    var masterId = 0
    var masterName = ""
    var masterPhotos = ""
    var masterRemark = ""
    var masterUrl = ""
    var seqNum = 0
    var darenratio:CGFloat = 1
    var goodsId = 0
    var goodsPrice = 0.0
    var goodsBoughtNum = 0
    var remainNum = 0
    var paidNum = 0
    var userWanted = 0
    var isTuanGou = false
    
    var groupbuyStatus = 0
    
    

    
    func setValueForDic(_ dic:NSDictionary){
        
        avatar = dic.stringFor(key: "avatar")
        collectionImgArr = dic.stringArrFor(key: "collectionImgArr")
        content = dic.stringFor(key: "content")
        likeSize = dic.intFor(key: "likeSize")
        replySize = dic.intFor(key: "replySize")
        collectionName = dic.stringFor(key: "collectionName")
        collectionUrl = dic.stringFor(key: "collectionUrl")
        sequence_num = dic.intFor(key: "sequence_num")
        sizes = sizeArrForJsonString(dic)
        slogon = dic.stringFor(key: "slogon")
        source = dic.stringFor(key: "source")
        storyCollectionId = dic.intFor(key: "storyCollectionId")
        userId = dic.intFor(key: "userId")
        userNick = dic.stringFor(key: "userNick")
        reference_price = dic.doubleFor(key: "reference_price")
        tagId = dic.stringArrFor(key: "tagId")
        tagName = dic.stringArrFor(key: "tagName")

        //设置高度
        setH()
    }
    
    //内页
    func setValueForDicInSecondStep(_ dic:NSDictionary){
        if isSet == true{
            return
        }
        
        iscollect = dic.intFor(key: "collection")
        article_url = dic.stringFor(key: "article_url")
        sponsored_url_type = dic.intFor(key: "sponsored_url_type")
        sponsored_url = dic.stringFor(key: "sponsored_url")
        goods_title = dic.stringFor(key: "goods_title")
        readFlag = dic.intFor(key: "readFlag")
        
        
        if let storyCollection = dic["storyCollection"] as? NSDictionary {
            isfans = storyCollection.intFor(key: "isfans")
            islike = storyCollection.intFor(key: "islike")
            tagList = storyCollection.dicArrFor(key: "tagList")
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
        
        if videoUrl != "" {
            arr = [arr[0]]
            collectionImgArr = [collectionImgArr[0]]
        }
        
        return arr
    }
    
    var height:CGFloat = 0
    var bigHeight:CGFloat = 0
    var imagesH:CGFloat = 0
    var bigImagesH:CGFloat = 0
    var titleH:CGFloat = 0
    var contentH:CGFloat = 0
    var contentListH:CGFloat = 0
    var bigTitleH:CGFloat = 0
    var bigContentH:CGFloat = 0
    
    var bigImageY:CGFloat = 0
    
    var relatedHeight:CGFloat = 0
    
    func getImagesHeight(_ width:CGFloat)->CGFloat{
        var hg:CGFloat = 0

        if sizes.count <= 4 {
            for size in sizes{
                hg += (size["height"] as! CGFloat)/(size["width"] as! CGFloat)*width
            }
        }else if sizes.count % 2 == 0{
            hg += CGFloat(sizes.count/2) * width/2
        }else{
            hg += (sizes[0]["height"] as! CGFloat)/(sizes[0]["width"] as! CGFloat)*width
            hg += CGFloat((sizes.count - 1)/2) * width/2
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
            height += LifeConstant.margin / 2
        }
        
        
        //        contentH += LifeUtils.calculateSizeForStr(content, size: CGSizeMake(width - LifeConstant.margin, LifeConstant.contentHeight), font: LifeConstant.contentFont).height
        contentH += LifeUtils.calculateHeightForContentStr(content)
        height += contentH
        height += LifeConstant.margin / 2
        height += LifeConstant.margin / 2
        
        if likeSize != 0 || replySize != 0 {
            height += 20
        }
        
        height += 50
        
        //内页高度
        bigHeight = 0
        //头部
        bigHeight += LifeConstant.BIG_HEAD_HEIGHT
        
        if collectionName != "" {
            //            bigTitleH = LifeUtils.calculateSizeForStr(collectionName, size: CGSizeMake(bigWidth - LifeConstant.bigMargin, LifeConstant.bigTitleHeight), font: LifeConstant.bigTitleFont).height
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
        
        //猜你想
//        bigHeight += LifeConstant.BIG_GUESS_HEIGHT
        
        //我想要
//        bigHeight += LifeConstant.BIG_WANT_HEIGHT
        
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
        categoryId    = dic.intFor(key: "categoryId")
        categoryName  = dic.stringFor(key: "categoryName")
    }
}



class LifeConstant{
    static let titleFont = UIFont.boldSystemFont(ofSize: 12.5)
    static let contentFont = UIFont.systemFont(ofSize: 11.5)
    static let darenContentFont = UIFont.boldSystemFont(ofSize: 11.5)
    
    static let width = WaterFlowViewLayout.columnWidth
    static let margin:CGFloat = 5
    static let innerWidth:CGFloat = width - margin * 5
    
    static let titleHeight:CGFloat = 45
    static let contentHeight:CGFloat = 55
    
    static let darenContentHeight:CGFloat = 75
    
    static let bigTitleHeight:CGFloat = CGFloat.greatestFiniteMagnitude
    static let bigContentHeight:CGFloat = CGFloat.greatestFiniteMagnitude
    
    static let bigWidth = UIScreen.main.bounds.size.width
    static let bigMargin:CGFloat = 10
    static let bigInnerWidth:CGFloat = bigWidth - bigMargin * 10
    
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
    
    static func request(url:String,pamams:[String : AnyObject]?, successClosure: ((_ body:AnyObject) -> Void)?, failureClosure: (() -> Void)?, nullClosure: (() -> Void)? = {}){
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
        
        
    }
    
    static func requestAndCache(_ url:String,pamams:[String : AnyObject]?, successClosure: ((_ body:AnyObject) -> Void)?, failureClosure: (() -> Void)?, nullClosure: (() -> Void)? = {}){
        
        let userDefaults = UserDefaults.standard
        let key = url + (pamams?.description ?? "")
        
        LifeUtils.request(url: url, pamams:pamams!, successClosure:
            { (bodyData) in
                
                userDefaults.set(bodyData , forKey: key)
                successClosure?(bodyData)
                
        }, failureClosure: failureClosure!,nullClosure:nullClosure!)
        
    }
    
    static func arrForJsonString(_ str:NSString)->[NSDictionary]{
        let data = str.data(using: String.Encoding.utf8)
        let obj = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
        return (obj as! [NSDictionary])
    }
    
    static func setImageViewForUrl(_ imageView:UIImageView,url:String){
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.setImageForUsIpWithURL(url)
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
        let expectedLabelRect = str.boundingRect(with: maximumLabelSize, options: [.usesLineFragmentOrigin,.usesFontLeading], attributes: LifeConstant.darenContentAttributesDic, context: nil)
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
    
    static func executeInMainQueue(_ closure: () -> Void){
        DispatchQueue.main.async { () -> Void in
            closure()
        }
        
        
    }
    
    static func executeInGlobalQueue(_ closure: () -> Void){
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high).async(execute: { () -> Void in
            closure()
        })
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
    
    static func truncatedString(_ str:String)->String{
        var i = 0
        for character in str.characters{
            if String(character).range(of: "\\p{Han}", options: .regularExpression) != nil{
                i += 1
            }
        }
        if i >= 8 {
            return str.substring(to: str.characters.index(str.startIndex, offsetBy: 8))
        }else{
            return str
        }
    }
}
