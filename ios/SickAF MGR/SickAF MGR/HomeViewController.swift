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
    var date = NSDate()
    var refreshControl:UIRefreshControl!
    var loading = false
//    var leftButton = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: "pressedEdit:")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.allowsMultipleSelectionDuringEditing = false
        
//        self.navigationItem.leftBarButtonItem = leftButton
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        changeToDate(NSDate())
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "pulledToRefresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    // MARK: Methods
    
    func pulledToRefresh() {
        if (loading) { return }
        refresh()
    }
    
    func refresh() {
        changeToDate(self.date)
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
        
        for (index, element) in enumerate(photoArray) {
            element.photoNum = index
            for obj in self.parseObjects {
                if (obj.objectId == element.objectId) {
                    obj["PhotoNum"] = element.photoNum
                }
            }
            PFObject.saveAllInBackground(self.parseObjects)
        }
        
        self.data[key] = photoArray
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == UITableViewCellEditingStyle.Delete
        {
//            var objId = self.data[indexPath.row].objectId
//            var query = PFQuery(className: "IGPhoto")
//            query.whereKey("objectId", equalTo: objId)
//            query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
//                
//                //  delete image with the specified objectId
//                if (error == nil) // TODO: handle bad data better
//                {
//                    for object in objects
//                    {
//                        let currentObject = object as PFObject
//                        var myStrUser = currentObject["IGUsername"] as String
//                        var myStrUrl = currentObject["URL"] as String
//                        println("deleting current obj posted by: \(myStrUser) at \(myStrUrl)")
//                        currentObject.deleteInBackgroundWithBlock({ (success: Bool, error: NSError!) -> Void in
//                            if (success)
//                            {
//                                self.data.removeAtIndex(indexPath.row);
//                                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//                            }
//                        })
//                    }
//                    self.tableView.reloadData()
//                }
//            }
        }
    }
    
    // For no crashing when loading
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if (loading) { return nil }
        return indexPath
    }

    // MARK: Helpers
    
    func getDataForDate(date: String) {
        
        loading = true
        
        // Setup query for Instagram pics
        var query = PFQuery(className: "IGPhoto")
        query.whereKey("forDate", equalTo: date)
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            
            // Remove everything from tableview
            self.data.removeAll(keepCapacity: false)
            self.parseObjects.removeAll(keepCapacity: false)
            self.loading = false
            
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
                    let category = Category(rawValue: retrievedCategory)!
                    let photo = IGPhoto( url: retrievedUrl, username: retrievedUsername, objectId: retrievedObjectId, photoNum: retrievedPhotoNum, category: category)
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
                self.tableView.reloadData()
            }
            self.refreshControl.endRefreshing()
        }
    }
    
    func changeToDate(date: NSDate)
    {
        self.date = date
        self.dateString = dateFormatter.stringFromDate(date)
        
        var titleButton:UIButton = UIButton()
        titleButton.setTitle(self.dateString, forState: .Normal)
        titleButton.addTarget(self, action: "tappedTitle:", forControlEvents: .TouchUpInside)
        titleButton.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        
        self.navigationItem.titleView = titleButton
        getDataForDate(self.dateString)
    }
    
    // MARK: Date Picker Delegate
    
    func datePicked(date: NSDate)
    {
        changeToDate(date)
        self.dismissViewControllerAnimated(true, nil)
    }
    
    // MARK: Actions
    
    @IBAction func pressedAdd(sender: AnyObject)
    {
        let st: UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        var vc: ViewController = st.instantiateInitialViewController() as ViewController
        vc.chosenDate = dateString
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func pressedEdit(sender: AnyObject)
    {
//        self.navigationItem.leftBarButtonItem.
        self.tableView.setEditing(!self.tableView.editing, animated: true)
    }
    
    func tappedTitle(sender: AnyObject)
    {
        let sb = UIStoryboard(name: "Home", bundle: NSBundle.mainBundle())
        let navController = sb.instantiateViewControllerWithIdentifier("dateNav") as UINavigationController
        let viewController = navController.topViewController as DatePickerViewController
        viewController.delegate = self
        self.presentViewController(navController, animated: true, completion: nil)
    }
}
