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
    
    var data: [IGPhoto] = []
    var dateString: String = ""
    let dateFormatter = NSDateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        changeToDate(NSDate())
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    // MARK: Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: ImagePreviewTableViewCell! = tableView.dequeueReusableCellWithIdentifier("Cell") as ImagePreviewTableViewCell
        let photo: IGPhoto = data[indexPath.row]
        cell!.usernameLabel.text = photo.username!
        cell!.iconImageView.setImageWithURL(NSURL.URLWithString(photo.url!))
        return cell
    }
    
    // MARK: Helpers
    
    func getDataForDate(date: String) {
        
        // Remove everything from tableview
        self.data.removeAll(keepCapacity: false)
        self.tableView.reloadData()
        
        // Setup query for Instagram pics
        var query = PFQuery(className: "IGPhoto")
        query.whereKey("forDate", equalTo: date)
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            
            // Add images to array and refresh tableview
            if (error == nil) {
                for object in objects {
                    let currentObject = object as PFObject
                    let retrievedUrl = currentObject["URL"] as String
                    let retrievedUsername = currentObject["IGUsername"] as String
                    let photo = IGPhoto(url: retrievedUrl, username: retrievedUsername)
                    self.data.append(photo)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func changeToDate(date: NSDate) {
        self.dateString = dateFormatter.stringFromDate(date)
        self.title = self.dateString
        getDataForDate(self.dateString)
    }
    
    // MARK: Date Picker Delegate
    
    func datePicked(date: NSDate) {
        changeToDate(date)
        self.dismissViewControllerAnimated(true, nil)
    }
    
    // MARK: Actions
    
    @IBAction func pressedAdd(sender: AnyObject) {
        let st: UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let vc: UIViewController = st.instantiateInitialViewController() as UIViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navController = segue.destinationViewController as UINavigationController
        let viewController = navController.topViewController as DatePickerViewController
        viewController.delegate = self
    }

}
