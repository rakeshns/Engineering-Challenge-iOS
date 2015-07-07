//
//  DataManager.swift
//  NutrInfo
//
//  Created by Rakesh NS on 04/07/15.
//  Copyright (c) 2015 Rakesh. All rights reserved.
//

import UIKit

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
    
    
}
