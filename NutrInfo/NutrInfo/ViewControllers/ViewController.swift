//
//  ViewController.swift
//  NutrInfo
//
//  Created by Rakesh NS on 18/05/15.
//  Copyright (c) 2015 Rakesh. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var foodItemList: UITableView!
    @IBOutlet weak var tableViewBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var suggestionList: UITableView!
    
    @IBOutlet weak var suggestionListHeightConstraint: NSLayoutConstraint!
    
    var arrayFoodDetals: [AnyObject] = []
    var arraySuggestions    = []
    var activityView:ProgressView?
    var searchQuery:String? = ""
    var foodDataId = ""
    var keyBoardHeight:CGFloat = 0.0
    
    //MARK: UI related methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        updateUI()
        generateFoodDetails()
        setUpTableview()
        self.foodItemList.reloadData()
    }

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        self.searchTextfield.text = ""
        self.navigationController?.navigationBarHidden = true
        updateSuggestionListHeight(self.suggestionList, isHidden: true)
    }

    override func viewWillDisappear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func updateUI()
    {
        self.foodItemList.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        
        self.suggestionList.layer.borderColor = UIColor(white: 0.1, alpha: 0.3).CGColor
        self.suggestionList.layer.borderWidth   = 1.0;
        self.suggestionList.layer.cornerRadius  = 5.0
        
    }
    
    func generateFoodDetails()
    {
        arrayFoodDetals    = JSONParser().dataForTopFoodItems()
    }
    
    func setUpTableview()
    {
        self.foodItemList.delegate     = self;
        self.foodItemList.dataSource   = self;
        
        self.suggestionList.delegate    = self
        self.suggestionList.dataSource  = self
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Tableview data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == suggestionList
        {
            return self.arraySuggestions.count
        }
        return self.arrayFoodDetals.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell:UITableViewCell?
        
        if tableView == self.foodItemList
        {
            var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as? FoodInfoTableViewCell
            
            if (cell == nil)
            {
                cell = FoodInfoTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
            }
            
            let foodDetail: NSDictionary = arrayFoodDetals[indexPath.row] as! NSDictionary
            
            cell?.foodImage.image   = UIImage(named: foodDetail["_id"] as! String)
            cell?.foodName.text     = foodDetail["name"] as? String
            
            var dictionary  = foodDetail["protein"] as! NSDictionary
            var unit        = dictionary["unit"] as! String
            var value       = dictionary["value"] as! Int
            
            cell?.proteinLabel.text = "Protein " + String(value) + unit
            
            dictionary      = foodDetail["calories"] as! NSDictionary
            unit            = dictionary["unit"] as! String
            value           = dictionary["value"] as! Int
            
            cell?.caloriesLabel.text    = "Calories " + String(value) + " " + unit
            
            return cell!
        }
        
        cell = tableView.dequeueReusableCellWithIdentifier("Suggestion", forIndexPath: indexPath) as? UITableViewCell
        
        if (cell == nil)
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Suggestion")
        }
        
        if let foodDetails = self.arraySuggestions[indexPath.row] as? NSManagedObject
        {
            cell?.textLabel?.text   = foodDetails.valueForKey("foodName") as? String
        }
        
        return cell!
    }
    // MARK: Tableview delegates
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if tableView == self.suggestionList
        {
            return 40.0
        }
        return 110.0
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if tableView == self.suggestionList
        {
            let cell:UITableViewCell?   = tableView.cellForRowAtIndexPath(indexPath)
            self.searchTextfield.text   = cell?.textLabel?.text
            
            updateSuggestionListHeight(self.suggestionList, isHidden: true)
        }
        else
        {
            let cell:FoodInfoTableViewCell    = tableView.cellForRowAtIndexPath(indexPath) as! FoodInfoTableViewCell
            
            searchQuery = cell.foodName.text
            self.searchTextfield.text   = searchQuery
            sendNutritionInfoRequest()
        }
        
    }
    
    // MARK: Textfield delegates
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
    
        searchQuery = textField.text
        
        sendNutritionInfoRequest()
        
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let newString = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
        displaySuggestions(newString)
        
        return true
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool
    {
        updateSuggestionListHeight(self.suggestionList, isHidden: true)
        return true
    }
    
    // MARK: Helper methods
    
    func keyboardWillShow(notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
        {
            self.tableViewBottomSpace.constant  += (keyboardSize.height - 20.0)
            self.view.layoutIfNeeded()
            keyBoardHeight = keyboardSize.height
        }
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
        {
            self.tableViewBottomSpace.constant  -= (keyboardSize.height - 20.0)
            self.view.layoutIfNeeded()
        }
    }
    
    func displayProgrssView()
    {
        activityView    = ProgressView(frame: self.view.frame) as ProgressView
        activityView?.yOffset   = 30.0
        activityView?.displayProgressView()
        
        self.view.addSubview(activityView!)
    }
    
    func sendNutritionInfoRequest()
    {
        if self.searchTextfield.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0
        {
            let utility = Utilities()
            utility.displayNoInputMessage(self)
            self.searchTextfield.text   = ""
        }
        else
        {
            displayProgrssView()
            self.searchTextfield.resignFirstResponder()
            
            let webService:WebServiceManager = WebServiceManager()
            
            if (searchQuery != nil)
            {
                if Reachability.isConnectedToNetwork()
                {
                    webService.getNutritionInformationOfFood(searchQuery!, completionHandler: { (data, error) -> Void in
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            activityView?.removeActivityIndicator()
                        })
                        
                        
                        let dataManager = DataManager()
                        
                        dataManager.saveFoodInformationFromData(data, completionHandler: { (foodDetailsID) -> Void in
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.foodDataId = foodDetailsID
                                self.performSegueWithIdentifier("details", sender: nil)
                            })
                            }, errorHandler: { (error) -> Void in
                                let utility = Utilities()
                                utility.displayGeneralMessage(self)
                        })
                    })
                }
                else
                {
                    let dataManager = DataManager()
                    
                    if let identifier = dataManager.getFoodIdentifierFromFoodName(searchQuery!)
                    {
                        self.foodDataId = identifier
                        self.performSegueWithIdentifier("details", sender: nil)
                    }
                    else
                    {
                        let utility = Utilities()
                        utility.displayGeneralMessage(self)
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        activityView?.removeActivityIndicator()
                    })
                }
                
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
    {
        let destinationVC = segue.destinationViewController as! NutritionDetailsViewController
        destinationVC.foodDataId = self.foodDataId
    }
    
    func displaySuggestions(searchText:String?)
    {
        if searchText != nil
        {
            let dataManager = DataManager()
            
            let arrayResults = dataManager.getMatchingFoodnames(searchText!)
            
            if (arrayResults != nil && arrayResults?.isKindOfClass(NSArray) == true)
            {
                self.arraySuggestions = arrayResults!
                
                self.suggestionList.reloadData()
                
                if (arrayResults?.count == 0)
                {
                    updateSuggestionListHeight(self.suggestionList, isHidden: true)
                }
                else
                {
                    updateSuggestionListHeight(self.suggestionList, isHidden: false)
                }
            }
        }
    }
    
    func updateSuggestionListHeight(list:UITableView, isHidden ishidden:Bool)
    {
        if ishidden
        {
            self.suggestionListHeightConstraint.constant = 0.0
        }
        else
        {
            self.suggestionListHeightConstraint.constant = CGRectGetHeight(self.view.frame) - self.suggestionList.frame.origin.y - keyBoardHeight
        }
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
}