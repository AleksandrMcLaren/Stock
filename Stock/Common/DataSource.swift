//
//  DataSource.swift
//  Stock
//
//  Created by Aleksandr on 06/06/2017.
//  Copyright © 2017 Records. All rights reserved.
//

import CoreData

class DataSource
{
    var modelName: String
    
    init()
    {
        modelName = "StockModel"
    }
    
    static let shared: DataSource =
    {
        let instance = DataSource ()
        return instance
    } ()

    lazy var managedObjectModel: NSManagedObjectModel =
    {
        let url = Bundle.main.url(forResource: self.modelName, withExtension: "momd")!
        
        return NSManagedObjectModel(contentsOf: url)!
    }()
   
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator =
    {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        let storeUrl = documentsURL?.appendingPathComponent(self.modelName + ".sqlite")
        
        do
        {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeUrl, options: nil)
        }
        catch let error as NSError
        {
            do
            {
                try FileManager.default.removeItem(at: storeUrl!)
                try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeUrl, options: nil)
            }
            catch let error as NSError
            {
                print("DataSource persistentStoreCoordinator error \(error.localizedDescription)")
                abort();
            }
        }
        
        return coordinator
    }()
    
    lazy var context: NSManagedObjectContext =
    {
        let coordinator = self.persistentStoreCoordinator
        var context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        
        return context
    }()
}

extension NSManagedObjectContext
{
    func needsSave()
    {
        let context = DataSource.shared.context
        
        context.performAndWait {
            
            if context.hasChanges
            {
                do
                {
                    try context.save()
                }
                catch let error as NSError
                {
                    print("DataSource saveContext error \(error.localizedDescription)")
                }
            }
        }
    }
}
