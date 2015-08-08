//
//  Utilities.swift
//  NutrInfo
//
//  Created by Rakesh NS on 08/08/15.
//  Copyright (c) 2015 Rakesh. All rights reserved.
//

import UIKit

class Utilities: NSObject
{
    func displayNoInputMessage(viewController:UIViewController)
    {
        displayAlert("Please enter text to be searched", onController: viewController)
    }
    
    func displayGeneralMessage(viewController:UIViewController)
    {
        displayAlert("No Results found", onController: viewController)
    }

    func displayNetworkErrorMessage(viewController:UIViewController, networkError error:NSError)
    {
        displayAlert(error.localizedDescription, onController: viewController)
    }
    
    func displayAlert(message:String, onController viewController:UIViewController)
    {
        var alert = UIAlertController(title: "NutrInfo", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
}
