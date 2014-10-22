//
//  LoginViewController.swift
//  SickAF MGR
//
//  Created by Cody Kolodziejzyk on 10/22/14.
//  Copyright (c) 2014 sickaf. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == usernameField) {
            self.passwordField.becomeFirstResponder()
        }
        else {
            self.loginUser()
        }
        return true
    }
    
    func loginUser()
    {
        let applicationID = "p8AF2BKCLQ7fr3oJXPg43fOL6LXAK3mwAb5Ywnke"
        let restApiKey = "v8C3jQHw0b8JkoCMy3Vn9QgqLdl3F7TxptAKfSVx"
        
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders?.updateValue(applicationID, forKey: "X-Parse-Application-Id")
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders?.updateValue(restApiKey, forKey: "X-Parse-REST-API-Key")
        
        PFUser.logInWithUsernameInBackground(self.usernameField.text, password: self.passwordField.text) { (user: PFUser!, err: NSError!) -> Void in
            if let user = user {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            else {
                let alertController = UIAlertController(title: "Error", message: "Wrong credentials dumbass.", preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
                    // ...
                }
                alertController.addAction(cancelAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
}
