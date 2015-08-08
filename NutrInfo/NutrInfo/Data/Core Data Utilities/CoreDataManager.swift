//
//  CoreDataManager.swift
//  NutrInfo
//
//  Created by Rakesh NS on 02/08/15.
//  Copyright (c) 2015 Rakesh. All rights reserved.
//

import UIKit
import CoreData

@objc(FoodDetails)

class CoreDataManager: NSObject {
    func getManagedObjectWithEntityName(entityName:String) -> NSManagedObject?
    {
        let entity:NSEntityDescription =  NSEntityDescription.entityForName(entityName, inManagedObjectContext: self.managedContext())!
        var managedObject = NSManagedObject(entity: entity, insertIntoManagedObjectContext: self.managedContext())
        return managedObject
    }
    
    func saveData()
    {
        var error : NSError? = nil
        
        self.managedContext().save(&error)
    }
    
    func retrieveDataWithEntityName(entity:String, withPredicate predicate:NSPredicate?, sortDescriptors sortDescriptor:NSSortDescriptor?) -> NSArray?
    {
        var error: NSError? = nil
        var fetchRequest: NSFetchRequest = NSFetchRequest(entityName: entity)
        
        if predicate != nil
        {
            fetchRequest.predicate = predicate!
        }
        if sortDescriptor != nil
        {
            fetchRequest.sortDescriptors = [sortDescriptor!]
        }
    
        return self.managedContext().executeFetchRequest(fetchRequest, error:&error)!
    }
    
    func managedContext() -> NSManagedObjectContext
    {
        let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let managedObjectContext:NSManagedObjectContext = appDel.managedObjectContext!
        
        return managedObjectContext
    }
}
