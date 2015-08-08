//
//  DataManager.swift
//  NutrInfo
//
//  Created by Rakesh NS on 04/07/15.
//  Copyright (c) 2015 Rakesh. All rights reserved.
//

import UIKit
import CoreData

class DataManager: NSObject {
   
    /*
    Name:           initialLocalStoredData
    Description:    return data saved in Search.json file for home screen.
    */
    func initialLocalStoredData() -> NSData?
    {
        let data = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("search.json", ofType: "")!)
        
        return data
    }
    
    /*
    Name:           saveFoodInformationFromData
    Description:    Save various food information details to database and return a uniue identifier
    */
    
    func saveFoodInformationFromData(data:NSData?, completionHandler:(foodDetailsID:String) ->Void, errorHandler:(error:NSError) ->Void)
    {
        var success = false
        
        if (data != nil)
        {
            let jsonData: AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil)
            
            if (jsonData != nil)
            {
                if jsonData!.isKindOfClass(NSArray)
                {
                    let jsonArray   = jsonData as! NSArray
                    
                    if jsonArray.count > 0
                    {
                        let foodInfo    = jsonArray.firstObject as! NSDictionary
                        
                        let arrayPortions   = foodInfo["portions"] as! NSArray
                        
                        if arrayPortions.count > 0
                        {
                            for dictionary in arrayPortions
                            {
                                let name = dictionary["name"] as! String
                                
                                let textRange = name.startIndex..<name.endIndex
                                
                                if (name.lowercaseString.rangeOfString("100g") != nil) || name.lowercaseString.rangeOfString("100 g") != nil {
                                    let nutrientsDictionary = dictionary["nutrients"] as! NSDictionary
                                    /*
                                    
                                    Cholesterol
                                    
                                    
                                    */
                                    if let importantContents = nutrientsDictionary["important"] as? NSDictionary
                                    {
                                        var foodContents:NSManagedObject?
                                        var coreDataHandler = CoreDataManager()
                                        
                                        if let foodDetails = checkDataAlreadySaved(foodInfo["_id"] as? String)
                                        {
                                            foodContents = foodDetails
                                        }
                                        else
                                        {
                                            foodContents = coreDataHandler.getManagedObjectWithEntityName("FoodDetails")!
                                        }
                                        
                                        if let foodNamae = foodInfo["name"] as? String
                                        {
                                            foodContents?.setValue(foodNamae, forKey: "foodName")
                                        }
                                        
                                        if let foodItemId = foodInfo["_id"] as? String
                                        {
                                            foodContents?.setValue(foodItemId, forKey: "identifier")
                                        }
                                        
                                        if let protein = importantContents["protein"] as? NSDictionary
                                        {
                                            var foodContent = getNutritionInfoInUnit(protein)
                                            
                                            if foodContent.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0
                                            {
                                                foodContents?.setValue(foodContent, forKey: "protein")
                                            }
                                        }
                                        if let calories = importantContents["calories"] as? NSDictionary
                                        {
                                            var foodContent = getNutritionInfoInUnit(calories)
                                            
                                            if foodContent.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0
                                            {
                                                foodContents?.setValue(foodContent, forKey: "calories")
                                            }
                                        }
                                        if let cholestrol = importantContents["cholesterol"] as? NSDictionary
                                        {
                                            var foodContent = getNutritionInfoInUnit(cholestrol)
                                            
                                            if foodContent.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0
                                            {
                                                foodContents?.setValue(foodContent, forKey: "cholesterol")
                                            }
                                        }
                                        if let total_fats = importantContents["total_fats"] as? NSDictionary
                                        {
                                            var foodContent = getNutritionInfoInUnit(total_fats)
                                        
                                            if foodContent.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0
                                            {
                                                foodContents?.setValue(foodContent, forKey: "total_fats")
                                            }
                                        }
                                        if let sugar = importantContents["sugar"] as? NSDictionary
                                        {
                                            var foodContent = getNutritionInfoInUnit(sugar)
                                            
                                            if foodContent.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0
                                            {
                                                foodContents?.setValue(foodContent, forKey: "sugar")
                                            }
                                        }
                                        if let monounsaturated = importantContents["monounsaturated"] as? NSDictionary
                                        {
                                            var foodContent = getNutritionInfoInUnit(monounsaturated)
                                            
                                            if foodContent.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0
                                            {
                                                foodContents?.setValue(foodContent, forKey: "monounsaturated")
                                            }
                                        }
                                        if let potassium = importantContents["potassium"] as? NSDictionary
                                        {
                                            var foodContent = getNutritionInfoInUnit(potassium)
                                            
                                            if foodContent.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0
                                            {
                                                foodContents?.setValue(foodContent, forKey: "potassium")
                                            }
                                        }
                                        if let saturated = importantContents["saturated"] as? NSDictionary
                                        {
                                            var foodContent = getNutritionInfoInUnit(saturated)
                                            
                                            if foodContent.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0
                                            {
                                                foodContents?.setValue(foodContent, forKey: "saturated")
                                            }
                                        }
                                        if let total_carbs = importantContents["total_carbs"] as? NSDictionary
                                        {
                                            var foodContent = getNutritionInfoInUnit(total_carbs)
                                            
                                            if foodContent.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0
                                            {
                                                foodContents?.setValue(foodContent, forKey: "total_carbs")
                                            }
                                        }
                                        if let dietary_fibre = importantContents["dietary_fibre"] as? NSDictionary
                                        {
                                            var foodContent = getNutritionInfoInUnit(dietary_fibre)
                                            
                                            if foodContent.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0
                                            {
                                                foodContents?.setValue(foodContent, forKey: "dietary_fibre")
                                            }
                                        }
                                        coreDataHandler.saveData()
                                        completionHandler(foodDetailsID: foodInfo["_id"] as! String)
                                        success = true
                                        break;
                                    }
                                }
                            }
                        }
                        
                    }
                    
                }
            }
        }
        
        if success == false
        {
            let error = NSError(domain: "general", code: 100, userInfo: nil)
            errorHandler(error: error)
        }
        
    }
    
    /*
    Name:           checkDataAlreadySaved
    Description:    Checks if the details already saved on database
    */
    
    func checkDataAlreadySaved(identifier:String?) -> NSManagedObject?
    {
        var foodInformation:NSManagedObject?
        
        if (identifier != nil)
        {
            var coreDataHandler = CoreDataManager()
            let predicate = NSPredicate(format: "self.identifier ==[c] %@", identifier!)
            let arrayResults = coreDataHandler.retrieveDataWithEntityName("FoodDetails", withPredicate: predicate, sortDescriptors: nil)
            
            if ((arrayResults != nil) && arrayResults!.isKindOfClass(NSArray))
            {
                if arrayResults?.count > 0
                {
                    let foodDetails = arrayResults?.firstObject as? NSManagedObject
                    foodInformation = foodDetails
                }
            }
        }
        
        return foodInformation
    }
    
    /*
    Name:           getNutritionInfoInUnit
    Description:    Get nutrition value in unit for given nutrition item
    */
    
    func getNutritionInfoInUnit(nutritionItem:NSDictionary) -> String
    {
        var quantityInUnit = ""
        
        if let value = nutritionItem["value"] as? String
        {
            quantityInUnit = value
        }
        else if let value = nutritionItem["value"] as? Int
        {
            quantityInUnit = String(value)
        }
        if let unit = nutritionItem["unit"] as? String
        {
            quantityInUnit = quantityInUnit + " " + unit
        }
        
        return quantityInUnit
    }
    /*
    Name:           getImageURLFromGoogleImageSearch
    Description:    Get 'url for image' from google image search API results
    */
    
    func getImageURLFromGoogleImageSearch(searchData:NSData) -> NSURL
    {
        //We assign a default URL
        var url = NSURL(string: "http://www.diabetesnews.com/wp-content/uploads/2015/06/Food-1.png")
        
        let jsonData: AnyObject? = NSJSONSerialization.JSONObjectWithData(searchData, options: NSJSONReadingOptions.AllowFragments, error: nil)
        
        if (jsonData != nil)
        {
            if (jsonData!.isKindOfClass(NSDictionary))
            {
                if let responseData = jsonData!["responseData"] as? NSDictionary
                {
                    if let results = responseData["results"] as? NSArray
                    {
                        if results.count > 0
                        {
                            let searchInfo = results.firstObject as? NSDictionary
                            let urlString = searchInfo!["url"] as? String
                            url = NSURL(string: urlString!)
                        }
                    }
                }
            }
        }
        
        return url!
    }
    
    /*
    Name:           getNutritionInformationFromFoodId
    Description:    retrieve nutrition information from Database
    */
    
    func getNutritionInformationFromFoodId(foodId:String) -> NSArray?
    {
        var coreDataHandler = CoreDataManager()
        let predicate = NSPredicate(format: "self.identifier ==[c] %@", foodId)
        
        let arrayResults = coreDataHandler.retrieveDataWithEntityName("FoodDetails", withPredicate: predicate, sortDescriptors: nil)
        
        return arrayResults
    }
    
    /*
    Name:           getMatchingFoodnames
    Description:    retrieve food information for name suggestions
    */
    
    func getMatchingFoodnames(searchString:String) ->NSArray?
    {
        var coreDataHandler = CoreDataManager()
        let predicate = NSPredicate(format: "(self.foodName BEGINSWITH[c] %@) OR (self.foodName CONTAINS[c] %@)", searchString, searchString)
        let arrayResults = coreDataHandler.retrieveDataWithEntityName("FoodDetails", withPredicate: predicate, sortDescriptors: nil)
        
        return arrayResults
    }
    
    /*
    Name:           getNutritionInformationFromFoodName
    Description:    retrieve nutrition information from Database
    */
    
    func getFoodIdentifierFromFoodName(searchString:String) ->String?
    {
        var foodId:String?
        var coreDataHandler = CoreDataManager()
        let predicate = NSPredicate(format: "(self.foodName ==[c] %@) OR (self.foodName CONTAINS[c] %@)", searchString, searchString)
        
        let arrayResults = coreDataHandler.retrieveDataWithEntityName("FoodDetails", withPredicate: predicate, sortDescriptors: nil)
        
        if ((arrayResults != nil) && (arrayResults?.isKindOfClass(NSArray) == true) && (arrayResults?.count > 0))
        {
            if let foodInformation = arrayResults?.firstObject as? NSManagedObject
            {
                foodId = foodInformation.valueForKey("identifier") as? String
            }
        }
        return foodId
    }
    
    /*
    Name:           saveImage:withFileNmae
    Description:    Saves image for offline use
    */

    func saveImage(image:UIImage, withFileNmae fileName:String)
    {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as? String
        if let destinationPath = documentsPath?.stringByAppendingPathComponent(fileName + "jpg")
        {
            UIImageJPEGRepresentation(image,1.0).writeToFile(destinationPath, atomically: true)
        }
    }
    
    /*
    Name:           getImageFromFileName
    Description:    get saved image
    */
    
    func getImageFromFileName(fileName:String) ->UIImage
    {
        var image = UIImage(named: "Food-Guidelines")
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as? String
        if let destinationPath = documentsPath?.stringByAppendingPathComponent(fileName + "jpg")
        {
            if NSFileManager.defaultManager().fileExistsAtPath(destinationPath)
            {
                if let data = NSData(contentsOfFile: destinationPath)
                {
                    image = UIImage(data: data)
                }
            }
        }
        return image!
    }
}
