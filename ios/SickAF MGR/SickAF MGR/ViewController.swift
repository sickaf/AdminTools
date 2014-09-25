//
//  ViewController.swift
//  SickAF MGR
//
//  Created by dtown on 9/9/14.
//  Copyright (c) 2014 sickaf. All rights reserved.
//

import UIKit
import Alamofire
import Foundation



class ViewController: UIViewController, UIPickerViewDelegate {
    var chosenDate: NSString! = ""
                            
    @IBOutlet var categoryPickerView: UIPickerView!
    @IBOutlet weak var urlTextField: UITextField!
    var photoUrl = ""
    var username = ""
    
    @IBAction func postButton(sender: UIButton)
    {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let sessionToken = appDelegate.sessionToken
        Alamofire.Manager.sharedInstance.defaultHeaders.updateValue(sessionToken, forKey: "X-Parse-Session-Token")


            Alamofire.request(.GET, self.urlTextField.text) //get instagram stuff
                .responseString { (request, response, string, error) in
                var responseString = string!
                var testVar : Int
                var userString = responseString
                responseString = responseString.componentsSeparatedByString("og:image\" content=\"")[1]
                responseString = responseString.componentsSeparatedByString("\"")[0]
                println("url: \(responseString)")
                self.photoUrl = responseString
                
                userString = userString.componentsSeparatedByString("og:description\" content=\"")[1]
                userString = userString.componentsSeparatedByString("'")[0]
                println("username: \(userString)")
                self.username = userString
                
                let parameters : [ String : AnyObject] = [
                    "URL": self.photoUrl,
                    "forDate": self.chosenDate,
                    "IGUsername": self.username,
                    "imageCategory": self.categoryPickerView.selectedRowInComponent(0),
                    "addedBy": self.categoryPickerView.selectedRowInComponent(1).description,
                    "PhotoNum": Int(self.categoryPickerView.selectedRowInComponent(2))
                ]
                
                Alamofire.request(.POST, "https://api.parse.com/1/classes/IGPhoto", parameters: parameters, encoding: .JSON) //put photo in parse
                    .responseJSON { (request, response, JSON, error) in
                        println("Parse response: \(JSON)")
                }
            }
        }
        
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.categoryPickerView.delegate = self
        self.urlTextField.becomeFirstResponder()
    
    }
        
    @IBAction func tapGesture(sender: AnyObject) {
        println("im gay")
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int {
        return 3
    }
    
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int
    {
        if(component == 2) //is photoNum
        {
            return 5
        }
        return 3
    }
    
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String
    {
        switch component {
        case 0 :
            switch row {
            case 0 : return "girls"
            case 1 : return "guys"
            case 2 : return "animals"
            default : return "error"
            }
        case 1 :
            switch row {
            case 0 : return "devon"
            case 1 : return "cody"
            case 2 : return "nick"
            default : return "error"
            }
        case 2 :
            switch row {
            case 0 : return "0"
            case 1 : return "1"
            case 2 : return "2"
            case 3 : return "3"
            case 4 : return "4"
            default : return "error"
            }
        default : return "error"
        }
    }

    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

