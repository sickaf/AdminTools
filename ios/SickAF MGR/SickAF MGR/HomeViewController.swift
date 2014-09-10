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
    var date: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: ImagePreviewTableViewCell! = tableView.dequeueReusableCellWithIdentifier("Cell") as ImagePreviewTableViewCell
        let photo: IGPhoto = data[indexPath.row]
        cell!.usernameLabel.text = photo.username
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let viewController:DatePickerViewController = segue.destinationViewController as DatePickerViewController
        viewController.delegate = self
    }
    
    // MARK: Helpers
    
    func getDataForDate(date: String) {
        println(date)
        var query = PFQuery(className: "IGPhoto")
        query.whereKey("forDate", equalTo: date)
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            
            self.data.removeAll(keepCapacity: false)
            
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
    
    // MARK: Date Picker Delegate
    
    func datePicked(date: String) {
        self.date = date
        getDataForDate(self.date)
        self.dismissViewControllerAnimated(true, nil)
    }

}
