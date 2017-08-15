//
//  DBCandle+CoreDataClass.swift
//  Stock
//
//  Created by Aleksandr on 06/06/2017.
//  Copyright © 2017 Records. All rights reserved.
//

import Foundation
import CoreData

@objc(DBCandle)
public class DBCandle: NSManagedObject {

    static func getAll() -> Array<DBCandle>?
    {
        var entities: Array<DBCandle>?
        let ctx: NSManagedObjectContext = DataSource.shared.context;
        
        ctx.performAndWait {
            
            do
            {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.description())
                entities = try ctx.fetch(fetchRequest) as? [DBCandle]
            }
            catch{}
        }
        
        return entities
    }
    
    static func add(data: Dictionary<String, Any>) -> DBCandle?
    {
        let low = data["low"] as? Double
        let high = data["high"] as? Double
        let open = data["sell"] as? Double
        let close = data["buy"] as? Double
        
        if low == nil || high == nil || open == nil || close == nil
        {
            return nil
        }

        let ctx: NSManagedObjectContext = DataSource.shared.context;
        var candle: DBCandle?
        
        ctx.performAndWait {
           
            guard let entity = NSEntityDescription.entity(forEntityName: self.description(), in: ctx)
                else { return }

            guard let cl = NSManagedObject(entity: entity, insertInto: ctx) as? DBCandle
                else { return }

            cl.low = low!
            cl.high = high!
            cl.open = open!
            cl.close = close!
            ctx.needsSave()
            
            candle = cl
        }
        
        return candle
    }
}
