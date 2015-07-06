//
//  JSONParser.swift
//  NutrInfo
//
//  Created by Rakesh NS on 04/07/15.
//  Copyright (c) 2015 Rakesh. All rights reserved.
//

import UIKit

class JSONParser: NSObject {
    
    override init() {
        
    }
    func dataForTopFoodItems() -> [AnyObject]
    {
        
        let data = DataManager().initialLocalStoredData() as NSData?
        
        var arrayJsonObjects : [AnyObject] = []
        
        if let data = DataManager().initialLocalStoredData() as NSData?
        {
            let arrayFoodDetails: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil)
            
            arrayJsonObjects    = arrayFoodDetails as! [AnyObject]
        }
        
        return arrayJsonObjects
    }
}
