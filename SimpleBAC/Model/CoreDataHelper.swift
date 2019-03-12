//
//  CoreDataHandler.swift
//  LastDrop
//
//  Created by Mark Wong on 10/8/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

//import Foundation
import CoreData
import UIKit
import Foundation

class CoreDataHandler {
    static let debug: Bool = true
    class func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    /*
        Save to settings entity
    */    
    class func saveSettingsEntity(entity entityName: String, weight w: Double, gender g: String) {
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: getContext())
        let manageObject = NSManagedObject(entity: entity!, insertInto: getContext())
        
        
        
        manageObject.setValue(w, forKey: "weight")
        manageObject.setValue(g, forKey: "gender")
        manageObject.setValue(AlcoholicDrink.country, forKey: "country")
        manageObject.setValue(Date(), forKey: "date")
        do {
            try getContext().save()

        } catch {
            let nserror = error as NSError
            print("\(nserror)")
        }
    }
    
    class func resetEntity() {
        //to be completed
    }
    
    class func fetchSettingsEntity() -> Settings? {
        let entityName = "Settings"
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.fetchLimit = 1
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            let settingsEntity: [Settings] = try getContext().fetch(fetchRequest) as! [Settings]
            if (settingsEntity.count > 0) {
                //clean up
                for (index, obj) in settingsEntity.enumerated() {
                    if (index > 0) {
                        getContext().delete(obj)
                    }
                }
                try getContext().save()
                //return latest settings entity
                return settingsEntity[0]
            }
            else {
                return nil
            }
        } catch {
            print("Alarm could not be fetched")
            return nil
        }
    }
    
    //save to core data
    class func saveAlcoholicDrink(alcoholicDrink: AlcoholicDrink) -> Void {
        let entityName = "DrinkStats"
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: getContext())
        let manageObject = NSManagedObject(entity: entity!, insertInto: getContext())
        //check
        
        manageObject.setValue(alcoholicDrink.bac, forKey: "bac")
        manageObject.setValue(alcoholicDrink.drinks, forKey: "drinks")
        manageObject.setValue(alcoholicDrink.startingTime, forKey: "startTime") //id
        

        do {
            try getContext().save()
            assert(self.debug, "CoreDataHandler: Saved")
        } catch {
            assert(self.debug, "CoreDataHandler: Not Saved")
        }
    }
    
    class func removeObjectInEntity(_ entityName: String, _ attribute: String, _ value: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let predicate = NSPredicate(format: "\(attribute) == %@", value)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        
        do {
            let count = try getContext().count(for: fetchRequest)
            print("CoreDataHandler Count: \(count)")
            if (count == 1) {
                return true
            }
            else {
                return false
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error)")
            return false
        }
    }
    
    class func checkIfAttributeExistsInEntity(_ entityName: String, _ attribute: String, _ value: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let predicate = NSPredicate(format: "\(attribute) == %@", value)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        
        do {
            let count = try getContext().count(for: fetchRequest)
            print("CoreDataHandler Count: \(count)")
            if (count == 1) {
                return true
            }
            else {
                return false
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error)")
            return false
        }
    }
    
    private class func printInfo(str: String) {
        print("CoreDataHandler: \(str)")
    }
    
    class func printDrinkEntity() {
        guard let e: [DrinkStats] = self.fetchDrinkEntity() else {
            return
        }
        
        for drinkRecord in e {
            print(drinkRecord.bac)
        }
    }
    
    class func printGenericEntity<T>(entity: T) {
        print("Print Generic Entity")
        
        //fix
        
    }
    
    class func fetchDrinkEntity() -> [DrinkStats]? {
        do {
            let context = getContext()
            let request = NSFetchRequest<NSManagedObject>(entityName: "DrinkStats")
            request.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: true)]
            let drinkEntity: [DrinkStats] = try context.fetch(request) as! [DrinkStats]
            
            return drinkEntity
        } catch {
            print("Alarm could not be fetched")
            return nil
        }
    }
    
    class func deleteAllObjectsInEntity(entityName: String) -> Bool {
        let context = getContext()
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try context.execute(deleteRequest)
            try context.save()
            return true
        } catch let error as NSError {
            print ("There was an error - \(error)")
            return false
        }
    }
}
