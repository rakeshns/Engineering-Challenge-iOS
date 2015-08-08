//
//  HTTPConnectionManager.swift
//  NutrInfo
//
//  Created by Rakesh NS on 07/07/15.
//  Copyright (c) 2015 Rakesh. All rights reserved.
//

import UIKit

class HTTPConnectionManager: NSObject {
    func createConnectionWithURL(url:NSURL, completionHandler:(data:NSData, error:NSError?)-> Void)
    {
        let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            completionHandler(data: data, error: nil)
        })
        
        task.resume()
    }
}
