//
//  NutritionDetailsViewController.swift
//  NutrInfo
//
//  Created by Rakesh NS on 06/08/15.
//  Copyright (c) 2015 Rakesh. All rights reserved.
//

import UIKit
import CoreData

class NutritionDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nutritionInfoTable: UICollectionView!
    
    var foodDataId:String?
    var arrayNutrients = []
    var arrayNutrientKeys = []
    var nutritionsInfo = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        displayNutritionInformationOfFoodItem(self.foodDataId!)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayNutritionInformationOfFoodItem(foodItemId:String)
    {
        let dataManager:DataManager = DataManager()
        if let arrayNutritionInfo = dataManager.getNutritionInformationForFoodId(foodItemId)
        {
            if let nutritionInfo = arrayNutritionInfo.firstObject as? NSManagedObject
            {
                self.nutritionsInfo = arrayNutritionInfo
                self.nameLabel.text = nutritionInfo.valueForKey("foodName") as? String
                initializeArrays()
                setUpCollectionView()
                displayFoodItemImage(nutritionInfo.valueForKey("foodName") as! String)
            }
        }
    }
    
    func setUpCollectionView()
    {
        self.nutritionInfoTable.delegate = self
        self.nutritionInfoTable.dataSource = self
    }
    
    func initializeArrays()
    {
        arrayNutrients = ["Calories", "Total Fat", "Saturated fat", "Monounsaturated fat", "Cholesterol", "Potassium", "Total Carbohydrate", "Dietary fiber", "Sugar", "Protein"]
        arrayNutrientKeys = ["calories", "total_fats", "saturated", "monounsaturated", "cholesterol", "potassium", "total_carbs", "dietary_fibre", "sugar",  "protein"]
    }
    
    func displayFoodItemImage(foodName:String)
    {
        let webService = WebServiceManager()
        webService.downloadImageForFoodItem(foodName, completionHandler: { (image) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                UIView.transitionWithView(self.imageView, duration: 0.4, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
                    self.imageView.image  = image
                }, completion: { Bool -> Void in
                })
            })
        })
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return arrayNutrients.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! CustomCell
    
        cell.nutritionItemLabel.text = arrayNutrients[indexPath.section] as? String
        
        if let nutritionInfo = self.nutritionsInfo.firstObject as? NSManagedObject
        {
            cell.nutritionValueLabel.text = nutritionInfo.valueForKey(arrayNutrientKeys[indexPath.section] as! String) as? String
        }
        
        cell.updateCellLayout(indexPath)
        
        return cell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return CGSizeMake(self.view.frame.size.width - 2.0, 40.0);
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        return 1.0;
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        return 1.0;
    }

}
