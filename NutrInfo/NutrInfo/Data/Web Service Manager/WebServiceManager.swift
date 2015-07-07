//
//  WebServiceManager.swift
//  NutrInfo
//
//  Created by Rakesh NS on 06/07/15.
//  Copyright (c) 2015 Rakesh. All rights reserved.
//

import UIKit

class WebServiceManager: NSObject
{
    func getNutritionInformationOfFood(foodName:String, completionHandler: (data:NSData, error:NSError) -> Void)
    {
        let urlString:String    = "http://test.holmusk.com/food/search?q="
        let queryString         = foodName.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        let url : NSURL         = NSURL(string: urlString + queryString!)!
        
        let connection          = HTTPConnectionManager()
        connection.createConnectionWithURL(url, completionHandler: { (data, error) -> Void in
            completionHandler(data: data, error: error)
        })
    }
}
