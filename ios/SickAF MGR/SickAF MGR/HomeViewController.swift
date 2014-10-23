//
//  HomeViewController.swift
//  SickAF MGR
//
//  Created by Cody Kolodziejzyk on 9/10/14.
//  Copyright (c) 2014 sickaf. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DatePickerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var data = [Category:[IGPhoto]]()
    var parseObjects = [PFObject]()
    var grin = []
    var dateString: String = ""
    let dateFormatter = NSDateFormatter()
    var date:NSDate!
    var refreshControl:UIRefreshControl!
    var leftButton: UIBarButtonItem!
    var loading = false
    var hasChanged = false
    var datePicker:DatePickerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.allowsMultipleSelectionDuringEditing = false
        self.leftButton = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: "pressedEdit:")
        self.navigationItem.leftBarButtonItem = self.leftButton
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "pulledToRefresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let user = PFUser.currentUser() {
            self.changeToDate(NSDate(), clearTable: true)
        }
        else {
            let sb = UIStoryboard(name: "Home", bundle: NSBundle.mainBundle())
            let viewController = sb.instantiateViewControllerWithIdentifier("login") as LoginViewController
            self.presentViewController(viewController, animated: false, completion: nil)
        }
    }
    
    // MARK: Methods
    
    func pulledToRefresh() {
        if (loading) { return }
        changeToDate(self.date, clearTable: false)
    }
    
    // MARK: Table View Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return data.keys.array.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let category = data.keys.array[section]
        return category.simpleDescription()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = data.keys.array[section]
        let picArray:[IGPhoto] = data[key]!
        return picArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let key = data.keys.array[indexPath.section]
        let photoArray = data[key]!
        let photo: IGPhoto = photoArray[indexPath.row]
        
        var cell: ImagePreviewTableViewCell! = tableView.dequeueReusableCellWithIdentifier("Cell") as ImagePreviewTableViewCell
        cell.showsReorderControl = true
        cell!.usernameLabel.text = photo.username!
        let adminString = photo.addedBy
        cell!.addedByLabel.text = "Added by: " + adminString!
        cell!.iconImageView.setImageWithURL(NSURL(string: photo.url!))
        
        return cell
    }
    
    func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
            return sourceIndexPath;
        }
        
        return proposedDestinationIndexPath
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
        let key = data.keys.array[sourceIndexPath.section]
        var photoArray = data[key]!
    
        let photo1 = photoArray[sourceIndexPath.row]
        photoArray.removeAtIndex(sourceIndexPath.row)
        photoArray.insert(photo1, atIndex: destinationIndexPath.row)
        
        self.data[key] = photoArray
        
        self.hasChanged = true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == UITableViewCellEditingStyle.Delete
        {
            let key = data.keys.array[indexPath.section]
            var photoArray = data[key]!
            let photo = photoArray[indexPath.row]
            
            for (ind, pPhoto) in enumerate(self.parseObjects) {
                if (pPhoto.objectId == photo.objectId) {
                    pPhoto.deleteInBackground();
                    self.parseObjects.removeAtIndex(ind)
                    photoArray.removeAtIndex(indexPath.row)
                    self.data[key] = photoArray
                    self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let key = data.keys.array[indexPath.section]
        var photoArray = data[key]!
        let photo = photoArray[indexPath.row]
        showInstagramSctionSheetForPhoto(photo)
    }
    
    // For no crashing when loading
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if (loading) { return nil }
        return indexPath
    }

    // MARK: Helpers
    
    func startLoading() {
        self.loading = true
    }
    
    func stopLoading() {
        self.loading = false
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    func getDataForDate(date: String, clearTable: Bool) {
        
        startLoading()
        if (clearTable) {
            self.data.removeAll(keepCapacity: false)
            self.tableView.reloadData()
        }
        
        // Setup query for Instagram pics
        var query = PFQuery(className: "IGPhoto")
        query.whereKey("forDate", equalTo: date)
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            
            // Remove everything from tableview
            self.data.removeAll(keepCapacity: false)
            self.parseObjects.removeAll(keepCapacity: false)
            
            // Add images to array and refresh tableview
            if (error == nil) {
                for object in objects {
                    let currentObject = object as PFObject
                    self.parseObjects.append(currentObject)
                    let retrievedUrl = currentObject["URL"] as String
                    let retrievedUsername = currentObject["IGUsername"] as String
                    let retrievedObjectId = currentObject.objectId
                    let retrievedPhotoNum = currentObject["PhotoNum"] as Int
                    let retrievedCategory = currentObject["imageCategory"] as Int
                    let retrievedAdmin = currentObject["addedBy"] as String
                    let category = Category(rawValue: retrievedCategory)!
                    let photo = IGPhoto( url: retrievedUrl, username: retrievedUsername, objectId: retrievedObjectId, photoNum: retrievedPhotoNum, category: category, addedBy : retrievedAdmin)
                    if var thisArray = self.data[category] {
                        thisArray.append(photo)
                        thisArray.sort({ $0.photoNum < $1.photoNum })
                        self.data[category] = thisArray
                    }
                    else {
                        var newArray = [photo]
                        self.data[category] = newArray
                    }
                }
            }
            self.stopLoading()
        }
    }
    
    func changeToDate(date: NSDate, clearTable: Bool)
    {
        self.date = date
        self.dateString = dateFormatter.stringFromDate(date)
        
        var titleButton:UIButton = UIButton()
        titleButton.setTitle(self.dateString, forState: .Normal)
        titleButton.addTarget(self, action: "tappedTitle:", forControlEvents: .TouchUpInside)
        titleButton.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        
        self.navigationItem.titleView = titleButton
        getDataForDate(self.dateString, clearTable: clearTable)
    }
    
    func saveAllObjectsWithNewIndexes()
    {
        for (cat, photos) in self.data {
            for (ind, photo) in enumerate(photos) {
                for obj in self.parseObjects {
                    if (obj.objectId == photo.objectId) {
                        obj["PhotoNum"] = ind
                    }
                }
            }
        }
        
        PFObject.saveAllInBackground(self.parseObjects)
    }
    
    func showInstagramSctionSheetForPhoto(photo:IGPhoto)
    {
        let alertController = UIAlertController(title: photo.username, message: "", preferredStyle: .ActionSheet)
        
        let igAction = UIAlertAction(title: "Instagram Profile", style: .Default) { (_) in
            
            let url = "instagram://user?username=" + photo.username!
            let igURL = NSURL(string: url)
            UIApplication.sharedApplication().openURL(igURL!)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        
        alertController.addAction(igAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: Date Picker Delegate
    
    func datePickerDismiss()
    {
        self.datePicker.view.removeFromSuperview()
        self.datePicker.willMoveToParentViewController(nil)
        self.datePicker.removeFromParentViewController()
        self.datePicker = nil
    }
    
    func switchedToDate(date: NSDate) {
        if let currentDate = self.date {
            if (dateFormatter.stringFromDate(currentDate) == dateFormatter.stringFromDate(date)) { return }
        }
        changeToDate(date, clearTable: true)
    }
    
    // MARK: Actions
    
    @IBAction func pressedAdd(sender: AnyObject)
    {        
        let sb = UIStoryboard(name: "Home", bundle: NSBundle.mainBundle())
        let viewController = sb.instantiateViewControllerWithIdentifier("addImage") as AddImageViewController
        viewController.dateString = self.dateFormatter.stringFromDate(self.date)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func pressedEdit(sender: AnyObject)
    {
        if (self.loading) { return }
        if (self.tableView.editing) {
            self.leftButton.title = "Edit";
            if (self.hasChanged) {
                // save new indexes if something has changed
                saveAllObjectsWithNewIndexes()
                self.hasChanged = false
            }
        }
        else {
            self.leftButton.title = "Done";
        }
        
        self.tableView.setEditing(!self.tableView.editing, animated: true)
    }
    
    func tappedTitle(sender: AnyObject)
    {
        if (self.datePicker == nil) {
            let sb = UIStoryboard(name: "Home", bundle: NSBundle.mainBundle())
            let viewController = sb.instantiateViewControllerWithIdentifier("date") as DatePickerViewController
            viewController.delegate = self
            if let date = self.date {
                viewController.startDate = date
            }
            viewController.view.frame = self.view.bounds
            self.addChildViewController(viewController)
            self.view.addSubview(viewController.view)
            viewController.didMoveToParentViewController(self)
            self.datePicker = viewController
        }
        else {
            self.datePicker.dismiss()
        }
    }
}
