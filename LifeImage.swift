//
//  LifeImage+CoreDataClass.swift
//  Pinterest
//
//  Created by Song Bo on 24/11/2016.
//  Copyright © 2016 finding. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData

@objc(LifeImage)
public class LifeImage: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<LifeImage> {
        return NSFetchRequest<LifeImage>(entityName: "LifeImage");
    }
    
    @NSManaged public var date: NSDate?
    @NSManaged public var imageData: NSData?
    @NSManaged public var urlString: String?
}
