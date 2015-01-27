//
//  AddImageViewController.swift
//  SickAF MGR
//
//  Created by Cody Kolodziejzyk on 10/23/14.
//  Copyright (c) 2014 sickaf. All rights reserved.
//

import UIKit
import Alamofire

class AddImageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    var chosenCategory:Category?
    var dateString:String?
    let clientID = "c16a25899b924b27aaea9a83bf6e3a8f"
    let getUsernameEndpoint: String = "https://api.instagram.com/v1/users/search"
    var currentTextCell:TextFieldCell!
    var firstTextField:UITextField!
    var secondTextField:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Image"
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardDidHideNotification, object: nil)
    }
    
    // MARK: Notifications
    
    func keyboardWillShow(note: NSNotification) {
        
        let info = note.userInfo
        let duration = info![UIKeyboardAnimationDurationUserInfoKey] as Double
        let s: NSValue = info![UIKeyboardFrameEndUserInfoKey] as NSValue;
        let rect: CGRect = s.CGRectValue();
        
        var contentInsets = UIEdgeInsetsMake(0, 0, rect.height, 0)
        
        self.tableView.contentInset = contentInsets;
        self.tableView.scrollIndicatorInsets = contentInsets;
        
        let indPath = self.tableView.indexPathForCell(currentTextCell)
        self.tableView.scrollToRowAtIndexPath(indPath!, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
    }
    
    func keyboardWillHide(note: NSNotification) {
        
        var contentInsets = UIEdgeInsetsZero
        
        let info = note.userInfo
        let duration = info![UIKeyboardAnimationDurationUserInfoKey] as Double
        
        UIView.animateWithDuration(duration, animations: { () -> Void in
            self.tableView.contentInset = contentInsets;
            self.tableView.scrollIndicatorInsets = contentInsets;
        })
        
        firstTextField.userInteractionEnabled = false
        secondTextField.userInteractionEnabled = false
    }

    // MARK: Table View Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 3 : 2
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Via Image URL" : "Instagram Profile"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0) {
            var cell: TextFieldCell! = tableView.dequeueReusableCellWithIdentifier("textfieldcell") as TextFieldCell
            cell.textField.placeholder = indexPath.section == 0 ? "Instagram URL" : "Username"
            cell.textField.returnKeyType = UIReturnKeyType.Done
            cell.textField.delegate = self;
            
            if (indexPath.section == 0) {
                self.firstTextField = cell.textField
            }
            else {
                self.secondTextField = cell.textField
            }
            
            return cell;
        }
        
        var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("normalcell") as UITableViewCell
        
        if (indexPath.section == 0) {
            if (indexPath.row == 1) {
                if let cat = self.chosenCategory {
                    cell.textLabel?.text = cat.simpleDescription()
                    cell.textLabel?.textColor = UIColor.blackColor()
                }
                else {
                    cell.textLabel?.text = "Choose category"
                    cell.textLabel?.textColor = UIColor.lightGrayColor()
                }
            }
            else {
                cell.textLabel?.text = "Add"
            }
        }
        
        if (indexPath.section == 1) {
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.textLabel?.text = "View Profile"
        }
        
        return cell
    }
    
    // MARK: Table View Delegate
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if (indexPath.row == 0) {
            let cell: TextFieldCell! = tableView.cellForRowAtIndexPath(indexPath) as TextFieldCell
            self.currentTextCell = cell
        }
        
        return indexPath
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == 0) {
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
            let cell: TextFieldCell! = tableView.cellForRowAtIndexPath(indexPath) as TextFieldCell
            cell.textField.userInteractionEnabled = true
            cell.textField.becomeFirstResponder()
        }
        else {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)

            if (indexPath.section == 0) {
                if (indexPath.row == 1) {
                    showCategoryChooser()
                }
                else {
                    if (self.firstTextField.text != "") {
                        if let cat = self.chosenCategory {
                            addImageWithURL(self.firstTextField.text, category: cat)
                        }
                    }
                }
            } else {
                if (self.secondTextField.text != "") {
                    showIGProfileForUser(self.secondTextField.text)
                }
            }
        }
    }
    
    // MARK: Helpers
    
    func showCategoryChooser() {
        let alertController = UIAlertController(title: "Add Image", message: "", preferredStyle: .ActionSheet)
        
        let postActionGirl = UIAlertAction(title: "Girl", style: .Default) { (_) in
            self.chosenCategory = Category(rawValue: 0)
            self.tableView.reloadData()
        }
        
        let postActionGuy = UIAlertAction(title: "Guy", style: .Default) { (_) in
            self.chosenCategory = Category(rawValue: 1)
            self.tableView.reloadData()
        }
        let postActionAnimal = UIAlertAction(title: "Animal", style: .Default) { (_) in
            self.chosenCategory = Category(rawValue: 2)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        
        alertController.addAction(postActionGirl)
        alertController.addAction(postActionGuy)
        alertController.addAction(postActionAnimal)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func addImageWithURL(urlString:String, category:Category)
    {
        SVProgressHUD.showWithStatus("Getting Instagram info...")
        
        let mediaEndpoint: String = "https://api.instagram.com/v1/media/shortcode/"
        let newEndpoint: String = mediaEndpoint + urlString.componentsSeparatedByString("/")[4];
        let clientID = "c16a25899b924b27aaea9a83bf6e3a8f"
        
        Alamofire.request(.GET, newEndpoint, parameters: ["client_id" : clientID])
            .responseJSON { (request, response, data, error) in
                
                if (error == nil) {
                    SVProgressHUD.showWithStatus("Posting pic...")
                    
                    let json = JSON(data!)
                    
                    let username = json["data"]["user"]["username"]
                    let imageURL = json["data"]["images"]["standard_resolution"]["url"]
                    
                    var newPhoto = PFObject(className: "IGPhoto")
                    
                    newPhoto.setObject(imageURL.asString, forKey: "URL")
                    newPhoto.setObject(self.dateString, forKey: "forDate")
                    newPhoto.setObject(username.asString, forKey: "IGUsername")
                    newPhoto.setObject(category.rawValue, forKey: "imageCategory")
                    newPhoto.setObject(PFUser.currentUser().username, forKey: "addedBy")
                    newPhoto.setObject(50, forKey: "PhotoNum")
                    
                    newPhoto.saveInBackgroundWithBlock({ (success:Bool, err:NSError!) -> Void in
                        if let err = err {
                            SVProgressHUD.dismiss()
                            let alertController = UIAlertController(title: "Whoops", message: err.localizedDescription, preferredStyle: .Alert)
                            let cancelAction = UIAlertAction(title: "OK", style: .Cancel) { (_) in }
                            alertController.addAction(cancelAction)
                            self.presentViewController(alertController, animated: true, completion: nil)
                        }
                        else {
                            print("saved photo")
                            SVProgressHUD.showSuccessWithStatus("Posted!")
                        }
                    })
                    
                }
        }
    }
    
    func showIGProfileForUser(username:String) {
        
        SVProgressHUD.showWithStatus("Finding user...")
            Alamofire.request(.GET, getUsernameEndpoint, parameters: ["q":username, "count": 100, "client_id" : clientID])
                .responseJSON { (request, response, jsonString, error) in
                    
                    if (jsonString == nil) { return }
                    
                    let json = JSON(jsonString!)
                    
                    // Check if user with exactly this username exists
                    var mediaID:String?
                    let result = json["data"]
                    println(result)
                    if let userArray = result.asArray {
                        for user in userArray {
                            let thisUsername = user["username"]
                            if let u = thisUsername.asString {
                                if (u == username) {
                                    let idString = user["id"]
                                    mediaID = idString.asString
                                }
                            }
                        }
                    }
                    
                    if let mID = mediaID {
                        SVProgressHUD.dismiss()
                        let sb = UIStoryboard(name: "Home", bundle: NSBundle.mainBundle())
                        let viewController = sb.instantiateViewControllerWithIdentifier("igprofile") as InstagramProfileViewController
                        viewController.userID = mID
                        viewController.username = username
                        viewController.dateString = self.dateString
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                    else {
                        SVProgressHUD.showErrorWithStatus("No User")
                    }
            }
    }
    
    // MARK: Text Field Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.firstTextField.resignFirstResponder()
        self.secondTextField.resignFirstResponder()
        return true
    }
}
