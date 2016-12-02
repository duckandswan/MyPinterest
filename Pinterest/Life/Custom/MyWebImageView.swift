//
//  MyWebImageView.swift
//  MyPinterest
//
//  Created by Song Bo on 30/11/2016.
//  Copyright © 2016 finding. All rights reserved.
//

import UIKit
import CoreData

//class CacheImage:UIImage{
//    var url:String = ""
//    var image:UIImage?
//    
//    override init() {
//        super.init()
//    }
//    
//    init(image:UIImage?,url:String){
//        super.init()
//        self.url = url
//        self.image = image
//    }
//    
//    required convenience init(imageLiteralResourceName name: String) {
//        fatalError("init(imageLiteralResourceName:) has not been implemented")
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}

class MyWebImageView: UIImageView {
    static var cacheArr = Array<(String,UIImage?)>(repeating: ("",UIImage()), count: 50)
    var urlString = ""
    func setImageForURLString(str:String){
        for ci in MyWebImageView.cacheArr {
            if ci.0 == str {
                self.image = ci.1
                return
            }
        }
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
        self.urlString = str
        //        self.image = UIImage(color: .white)
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
                    DispatchQueue.main.async { () -> Void in
                        let image = UIImage(data: ir.imageData as! Data)
                        self?.image = image
                        _ = MyWebImageView.cacheArr.removeFirst()
                        MyWebImageView.cacheArr.append((str,image))
                    }

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
//                        let serialQueue = DispatchQueue(label: "queuename")
//                        serialQueue.sync {
//                            let concurrentQueue = DispatchQueue(label: "queuename", attributes: .concurrent)
//                            concurrentQueue.sync {
//                            let myImage = ImageRecord(context: MyCoreDataStack.coreDataStack.context)
//                            myImage.urlString = str
//                            myImage.imageData = imageData as NSData
//                            myImage.date = NSDate()
//                            do {
//                                try MyCoreDataStack.coreDataStack.context.save()
//                            } catch let error as NSError {
//                                print("Could not save \(error), \(error.userInfo)")
//                            }
//                        }
                        MyCoreDataStack.coreDataStack.context.perform({ 
                            let myImage = ImageRecord(context: MyCoreDataStack.coreDataStack.context)
                            myImage.urlString = str
                            myImage.imageData = imageData as NSData
                            myImage.date = NSDate()
                            do {
                                try MyCoreDataStack.coreDataStack.context.save()
                            } catch let error as NSError {
                                print("Could not save \(error), \(error.userInfo)")
                            }
                        })
                        DispatchQueue.main.async { () -> Void in
                            print("download str:\(str)")
                            let image = UIImage(data: imageData)
                            self?.image = image
                            _ = MyWebImageView.cacheArr.removeFirst()
                            MyWebImageView.cacheArr.append((str, image))
                            if self?.urlString == str {
                                self?.image = image
                            }
                        }
                    }) .resume()
                    
                    
                }
        }
        MyCoreDataStack.coreDataStack.context.perform({
            do {
                _ = try MyCoreDataStack.coreDataStack.context.execute(asyncFetchRequest)
                
            } catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            }
        })

        
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
