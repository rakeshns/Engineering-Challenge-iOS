//
//  FoodInfoTableViewCell.swift
//  NutrInfo
//
//  Created by Rakesh NS on 04/07/15.
//  Copyright (c) 2015 Rakesh. All rights reserved.
//

import UIKit

class FoodInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
