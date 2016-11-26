//
//  ImageRecord+CoreDataProperties.swift
//  Pinterest
//
//  Created by bob song on 16/11/25.
//  Copyright © 2016年 finding. All rights reserved.
//

import Foundation
import CoreData


extension ImageRecord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageRecord> {
        return NSFetchRequest<ImageRecord>(entityName: "ImageRecord");
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var imageData: NSData?
    @NSManaged public var urlString: String?

}
