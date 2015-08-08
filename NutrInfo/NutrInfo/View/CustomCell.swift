//
//  CustomCell.swift
//  NutrInfo
//
//  Created by Rakesh NS on 08/08/15.
//  Copyright (c) 2015 Rakesh. All rights reserved.
//

import UIKit

class CustomCell: UICollectionViewCell
{
    @IBOutlet weak var nutritionItemLabel: UILabel!
    @IBOutlet weak var nutritionValueLabel: UILabel!
    @IBOutlet weak var nameLabelXPostionConstraint: NSLayoutConstraint!
    
    func updateCellLayout(indexPath:NSIndexPath)
    {
        switch indexPath.section {
        case 2, 3, 7, 8:
            self.nameLabelXPostionConstraint.constant   = 25.0
            self.nutritionItemLabel.font = UIFont.systemFontOfSize(15.0)
            self.nutritionItemLabel.textColor   = UIColor.darkGrayColor()
        default:
            self.nameLabelXPostionConstraint.constant   = 10.0
            self.nutritionItemLabel.font = UIFont.boldSystemFontOfSize(17.0)
        }
    }
}
