//
//  CoreDataStack.swift
//  finding
//
//  Created by bob song on 16/2/26.
//  Copyright © 2016年 zhangli. All rights reserved.
//

import Foundation
import CoreData

class MyCoreDataStack {
    
    var context:NSManagedObjectContext
    var psc:NSPersistentStoreCoordinator
    var model:NSManagedObjectModel
    var store:NSPersistentStore?
    
    init() {
        
        let bundle = Bundle.main
        let modelURL =
        bundle.url(forResource: "MyImage", withExtension:"momd")
        model = NSManagedObjectModel(contentsOf: modelURL!)!
        
        psc = NSPersistentStoreCoordinator(managedObjectModel:model)
        
        context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        context.persistentStoreCoordinator = psc
        
        let documentsURL = applicationDocumentsDirectory()
        let storeURL =
        documentsURL.appendingPathComponent("MyImage.sqlite")
        
        let options =
        [NSMigratePersistentStoresAutomaticallyOption: true]
        
        var error: NSError? = nil
        do {
            store = try psc.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: storeURL,
                options: options)
        } catch let error1 as NSError {
            error = error1
            store = nil
        }
        
        if store == nil {
            print("Error adding persistent store: \(error)")
            abort()
        }
        
    }
    
    func saveContext() {
        
        var error: NSError? = nil
        if context.hasChanges {
            do {
                try context.save()
            } catch let error1 as NSError {
                error = error1
                print("Could not save: \(error), \(error?.userInfo)")
            }
        }
        
    }
    
    func applicationDocumentsDirectory() -> NSURL {
        
        let fileManager = FileManager.default
        
        let urls = fileManager.urls(for: .documentDirectory,
                                    in: .userDomainMask) 
        
        return urls[0] as NSURL
    }
    
}
