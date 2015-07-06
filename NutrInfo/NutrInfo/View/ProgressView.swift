//
//  ProgressView.swift
//  NutrInfo
//
//  Created by Rakesh NS on 06/07/15.
//  Copyright (c) 2015 Rakesh. All rights reserved.
//

import UIKit
import QuartzCore

class ProgressView: UIView {

    var xOffset:CGFloat = 0.0
    var yOffset:CGFloat = 0.0
    var activityContainerWidth:CGFloat  = 60.0
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor    = UIColor.clearColor()
    }
    
    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func displayProgressView()
    {
        let activityContainer   = UIView(frame: CGRectMake(self.center.x + xOffset - activityContainerWidth / 2.0, self.center.y + yOffset - activityContainerWidth / 2.0, activityContainerWidth, activityContainerWidth))
        activityContainer.backgroundColor   = UIColor.blackColor()
        activityContainer.layer.cornerRadius    = 8.0;
        
        let activityIndicator   = UIActivityIndicatorView() as UIActivityIndicatorView
        activityIndicator.frame = CGRectMake(activityContainerWidth / 2.0 - 10.0, activityContainerWidth / 2.0 - 10.0, 20.0, 20.0)
        activityIndicator.activityIndicatorViewStyle    = UIActivityIndicatorViewStyle.White
        activityIndicator.startAnimating()
        
        activityContainer.addSubview(activityIndicator)
        self.addSubview(activityContainer)
    }
    
    func removeActivityIndicator()
    {
        self.removeFromSuperview()
    }
}
