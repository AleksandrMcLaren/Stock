//
//  DBCandle+CoreDataProperties.swift
//  Stock
//
//  Created by Aleksandr on 07/06/2017.
//  Copyright © 2017 Records. All rights reserved.
//

import Foundation
import CoreData


extension DBCandle {

    @NSManaged public var high: Double
    @NSManaged public var low: Double
    @NSManaged public var open: Double
    @NSManaged public var close: Double

}
