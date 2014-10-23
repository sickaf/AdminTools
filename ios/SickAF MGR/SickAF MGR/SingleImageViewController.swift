//
//  SingleImageViewController.swift
//  SickAF MGR
//
//  Created by Cody Kolodziejzyk on 10/23/14.
//  Copyright (c) 2014 sickaf. All rights reserved.
//

import UIKit
import Alamofire

class SingleImageViewController: UIViewController {
    
    var imageUrl:String?
    var imageLink:String?
    var dateString:String?
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = self.imageUrl {
            self.imageView.setImageWithURL(NSURL(string: url))
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: "saveImg")
    }

    // MARK: Functions
    
    func saveImg()
    {
        let alertController = UIAlertController(title: "Add Image", message: "", preferredStyle: .ActionSheet)
        
        let postActionGirl = UIAlertAction(title: "Girl", style: .Default) { (_) in
            self.saveImgWithCategory(Category(rawValue: 0)!)
        }
        
        let postActionGuy = UIAlertAction(title: "Guy", style: .Default) { (_) in
            self.saveImgWithCategory(Category(rawValue: 1)!)
        }
        let postActionAnimal = UIAlertAction(title: "Animal", style: .Default) { (_) in
            self.saveImgWithCategory(Category(rawValue: 2)!)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        
        alertController.addAction(postActionGirl)
        alertController.addAction(postActionGuy)
        alertController.addAction(postActionAnimal)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func saveImgWithCategory(category:Category)
    {
        SVProgressHUD.showWithStatus("Getting Instagram info...")
        Alamofire.request(.GET, self.imageLink!) //get instagram stuff
            .responseString { (request, response, string, error) in
                
                if (error == nil) {
                    SVProgressHUD.showWithStatus("Posting pic...")
                    var responseString = string!
                    var testVar : Int
                    var userString = responseString
                    responseString = responseString.componentsSeparatedByString("og:image\" content=\"")[1]
                    responseString = responseString.componentsSeparatedByString("\"")[0]
                    println("url: \(responseString)")
                    
                    userString = userString.componentsSeparatedByString("og:description\" content=\"")[1]
                    userString = userString.componentsSeparatedByString("'")[0]
                    println("username: \(userString)")
                    
                    var newPhoto = PFObject(className: "IGPhoto")
                    
                    newPhoto.setObject(responseString, forKey: "URL")
                    newPhoto.setObject(self.dateString, forKey: "forDate")
                    newPhoto.setObject(userString, forKey: "IGUsername")
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
    
}
