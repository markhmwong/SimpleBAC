//
//  Settings+CoreDataProperties.swift
//  LastDrop
//
//  Created by Mark Wong on 2/9/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//
//

import Foundation
import CoreData


extension Settings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Settings> {
        return NSFetchRequest<Settings>(entityName: "Settings")
    }

    @NSManaged public var country: String?
    @NSManaged public var gender: String?
    @NSManaged public var weight: Float
    @NSManaged public var date: NSDate?
}
