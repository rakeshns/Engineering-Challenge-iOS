//
//  ViewController.swift
//  NutrInfo
//
//  Created by Rakesh NS on 18/05/15.
//  Copyright (c) 2015 Rakesh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var tableViewBottomSpace: NSLayoutConstraint!
    
    var arrayFoodDetals: [AnyObject] = []
    var activityView:ProgressView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        generateFoodDetails()
        setUpTableview()
    }

    override func viewWillAppear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func updateUI()
    {
        self.tableview.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
    }
    
    func generateFoodDetails()
    {
        arrayFoodDetals    = JSONParser().dataForTopFoodItems()
    }
    
    func setUpTableview()
    {
        self.tableview.delegate     = self;
        self.tableview.dataSource   = self;
        
        self.tableview.reloadData()
    }
    override func didReceiveMemoryWarning() {
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
        return self.arrayFoodDetals.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as? UITableViewCell
        
        if (cell == nil)
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        }
        
        let foodDetail: NSDictionary = arrayFoodDetals[indexPath.row] as! NSDictionary
        
        let imageview = cell?.viewWithTag(1) as! UIImageView
    
        imageview.image = UIImage(named: foodDetail["_id"] as! String)
        
        var nameLabel   = cell?.viewWithTag(2) as! UILabel
        nameLabel.text  = foodDetail["name"] as? String
        
        var dictionary  = foodDetail["protein"] as! NSDictionary
        
        var unit        = dictionary["unit"] as! String
        var value       = dictionary["value"] as! Int
        
        nameLabel       = cell?.viewWithTag(3) as! UILabel
        nameLabel.text  = "Protein " + String(value) + unit
        
        dictionary      = foodDetail["calories"] as! NSDictionary
        unit            = dictionary["unit"] as! String
        value           = dictionary["value"] as! Int
        
        nameLabel       = cell?.viewWithTag(4) as! UILabel
        nameLabel.text  = "Calories " + String(value) + " " + unit
        
        return cell!
    }
    // MARK: Tableview delegates
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 110.0
    }
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath)
    {
        // tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    // MARK: Textfield delegates
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
        displayProgrssView()
        
        return true
    }
    func keyboardWillShow(notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
        {
            self.tableViewBottomSpace.constant  += (keyboardSize.height - 20.0)
            self.view.layoutIfNeeded()
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
        activityView?.displayProgressView()
        
        self.view.addSubview(activityView!)
    }
    
}