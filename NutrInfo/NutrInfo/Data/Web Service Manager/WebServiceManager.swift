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
    func getNutritionInformationOfFood(foodName:String, completionHandler: (data:NSData, error:NSError?) -> Void)
    {
        let urlString:String    = "http://test.holmusk.com/food/search?q="
        let queryString         = foodName.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        let url : NSURL         = NSURL(string: urlString + queryString!)!
        
        let connection          = HTTPConnectionManager()
        connection.createConnectionWithURL(url, completionHandler: { (data, error) -> Void in
            completionHandler(data: data, error: error)
        })
    }
    
    func downloadImageForFoodItem(foodName:String, completionHandler:(image:UIImage)->Void)
    {
        let queryString         = foodName.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        let urlString:String    = "https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=" + queryString! + "&imgsz=medium"
        let url : NSURL?        = NSURL(string: urlString)
        
        let connection          = HTTPConnectionManager()
        connection.createConnectionWithURL(url!, completionHandler: { (data, error) -> Void in
            let dataManager     = DataManager()
            let imageURL:NSURL  = dataManager.getImageURLFromGoogleImageSearch(data)
            
            if let data:NSData = NSData(contentsOfURL: imageURL)
            {
                if let image:UIImage = UIImage(data: data)
                {
                    completionHandler(image: image)
                }
            }
        })
    }
}
