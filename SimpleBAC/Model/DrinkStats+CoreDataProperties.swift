//
//  DrinkStats+CoreDataProperties.swift
//  LastDrop
//
//  Created by Mark Wong on 1/9/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//
//

import Foundation
import CoreData


extension DrinkStats {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DrinkStats> {
        return NSFetchRequest<DrinkStats>(entityName: "DrinkStats")
    }

//    @NSManaged public var alcoholMass: Double
    @NSManaged public var bac: Float
    @NSManaged public var drinks: Float
    @NSManaged public var startTime: NSDate?
    @NSManaged public var timeRemaining: NSDate?

}
