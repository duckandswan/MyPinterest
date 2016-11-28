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
import CoreData

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
                
                imageView.center = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
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
    
}

extension UIViewController{
    //生成uuid
    func bulidUUID() ->String{
        let uuid_ref = CFUUIDCreate(nil)
        let uuid_string_ref = CFUUIDCreateString(nil , uuid_ref)!
        let uuid:String = NSString(format: uuid_string_ref) as String
        return uuid
    }
}


//没有数据占位图
extension UIView{
    //没有相关
    func addNoDataDefaultImageView(isadd:Bool, imgName:String = "img_search"){
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

extension UIImageView{
    
    func setImageForURLString(str:String){
        setImageForURLStringWithCache(str: str)
//        self.image = nil
//        URLSession.shared.dataTask(with: URL(string: str)!, completionHandler: { (data, response, error) in
//            DispatchQueue.main.async { () -> Void in
//                guard let imageData = data else {
//                    return
//                }
//                print("download str:\(str)")
//                self.image = UIImage(data: imageData)
//            }
//        }) .resume()
    }
    
    func setImageForURLStringWithCache(str:String){
        self.image = nil
        
        let imageFetch: NSFetchRequest<ImageRecord> = ImageRecord.fetchRequest()
        let predicate = NSPredicate(format: "urlString = %@", str)
        imageFetch.predicate = predicate
        imageFetch.fetchLimit = 1
        
        let asyncFetchRequest =
            NSAsynchronousFetchRequest(fetchRequest: imageFetch)
            {[weak self] (result: NSAsynchronousFetchResult! )
                -> Void in
                let irs = result.finalResult!
                for ir in irs{
                    print("str:\(str)\nir.urlString:\(ir.urlString)")
                    self?.image = UIImage(data: ir.imageData as! Data)
                }
                
                if irs.count == 0{
                    
//                    DispatchQueue.global().async {
//                        if let imageData = NSData(contentsOf: URL(string: str)!){
//                            DispatchQueue.main.async { () -> Void in
//                                let myImage = ImageRecord(context: MyCoreDataStack.coreDataStack.context)
//                                myImage.urlString = str
//                                myImage.imageData = imageData
//                                myImage.date = NSDate()
//                                do {
//                                    try MyCoreDataStack.coreDataStack.context.save()
//                                } catch let error as NSError {
//                                    print("Could not save \(error), \(error.userInfo)")
//                                }
//                                print("download str:\(str)")
//                                self?.image = UIImage(data: imageData as Data)
//                            }
//                        }
//                }
                
                    URLSession.shared.dataTask(with: URL(string: str)!, completionHandler: { (data, response, error) in
                        guard let imageData = data else {
                            return
                        }
                        let serialQueue = DispatchQueue(label: "queuename")
                        serialQueue.sync {
                            let myImage = ImageRecord(context: MyCoreDataStack.coreDataStack.context)
                            myImage.urlString = str
                            myImage.imageData = imageData as NSData
                            myImage.date = NSDate()
                            do {
                                try MyCoreDataStack.coreDataStack.context.save()
                            } catch let error as NSError {
                                print("Could not save \(error), \(error.userInfo)")
                            }
                        }
                        DispatchQueue.main.async { () -> Void in
                            print("download str:\(str)")
                            self?.image = UIImage(data: imageData)
                        }
                    }) .resume()
                
                    
                }
        }
        
        do {
            _ = try MyCoreDataStack.coreDataStack.context.execute(asyncFetchRequest)
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        //        do {
        //
        //            let irs = try MyCoreDataStack.coreDataStack.context.fetch(imageFetch)
        //            for ir in irs{
        //                print("str:\(str)\nir.urlString:\(ir.urlString)")
        //                image = UIImage(data: ir.imageData as! Data)
        //            }
        //
        //
        //            if irs.count == 0{
        //                self.image = nil
        //                DispatchQueue.global().async {
        //                    if let imageData = NSData(contentsOf: URL(string: str)!){
        //                        DispatchQueue.main.async { () -> Void in
        //                            let myImage = ImageRecord(context: MyCoreDataStack.coreDataStack.context)
        //                            myImage.urlString = str
        //                            myImage.imageData = imageData
        //                            myImage.date = NSDate()
        //                            do {
        //                                try MyCoreDataStack.coreDataStack.context.save()
        //                            } catch let error as NSError {
        //                                print("Could not save \(error), \(error.userInfo)")
        //                            }
        //                            self.image = UIImage(data: imageData as Data)
        //                        }
        //                    }
        //
        //                }
        //            }
        //        }catch{
        //
        //        }
        
    }

}

extension NSDictionary{
    
    func stringArr(forKey key:String)->[String]{
        if self[key] is NSArray{
            return (self[key] as? [String]) ?? []
        }else{
            return []
        }
    }
    
    func string(forKey key:String, df:String = "")->String{
        if self[key] is String{
            return self[key] as! String
        }else if self[key] is NSNumber {
            return String(describing: self[key] as! NSNumber)
        }else{
            return df
        }
    }
    
    func int(forKey key:String, df:Int = 0)->Int{
        if self[key] is NSNumber{
            return self[key] as! Int
        }else if self[key] is String{
            return (Int(self[key] as! String) ?? df)
        }else{
            return df
        }
    }
    
    func double(forKey key:String,df:Double = 0.0)->Double{
        if self[key] is NSNumber{
            return (self[key] ?? df) as! Double
        }else if self[key] is String{
            return (Double(self[key] as! String) ?? df)
        }else{
            return df
        }
    }
    
    func dicArr(forKey key:String)->[NSDictionary]{
        return (self[key] ?? Array<NSDictionary>()) as! [NSDictionary]
    }
    
    func dic(forKey key:String)->NSDictionary{
        return (self[key] ?? NSDictionary()) as! NSDictionary
    }
}

extension UIScrollView{
    
    //MARK: -下拉刷新，上拉加载更多
    func addHeaderRefresh(obj:AnyObject, action:Selector) {

    }
    
    func addFooterRefresh(obj:AnyObject, action:Selector) {
        
    }
    
    //MARK: -下拉刷新，上拉加载更多
    func addHeaderRefresh(block:()->Void) {
    }
    
    func addFooterRefresh(block:()->Void) {
        
    }
    
}

extension UICollectionView{
    
    func insertItemsTo(section:Int){
        let n = self.numberOfItems(inSection: section)
        let number = self.dataSource!.collectionView(self, numberOfItemsInSection: section)
        if n == number {
            return
        }
        var indexPathArr:[NSIndexPath] = []
        for i in n..<number{
            indexPathArr.append(NSIndexPath(row: i, section: section))
        }
        self.insertItems(at: indexPathArr as [IndexPath])
    }
    
    func reloadAllSections(){
        let n = self.numberOfSections
        UIView.performWithoutAnimation({
            self.reloadSections(NSIndexSet(indexesIn: NSMakeRange(0, n)) as IndexSet)
        })
    }
    
}

extension UITableView{
    
    func insertSections(){
        let n = self.numberOfSections
        let number = self.dataSource!.numberOfSections!(in: self)
        if n == number {
            return
        }
        let indexSet = NSMutableIndexSet()
        for i in n..<number{
            indexSet.add(i)
        }
        self.insertSections(indexSet as IndexSet, with: UITableViewRowAnimation.automatic)
    }
}

extension String {
    func truncatedHanTo(number:Int)->String{
        var i = 0
        for character in characters{
            if String(character).range(of: "\\p{Han}", options: .regularExpression) != nil{
                i += 1
            }
        }
        if i >= number {
            return substring(to: characters.index(startIndex, offsetBy: 8))
        }else{
            return self
        }
    }
}


