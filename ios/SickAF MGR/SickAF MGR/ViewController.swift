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
    
    @IBAction func postButton(sender: UIButton) {

        
        Alamofire.request(.GET, urlTextField.text)
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
                Alamofire.Manager.sharedInstance.defaultHeaders.updateValue("p8AF2BKCLQ7fr3oJXPg43fOL6LXAK3mwAb5Ywnke", forKey: "X-Parse-Application-Id")
                Alamofire.Manager.sharedInstance.defaultHeaders.updateValue("v8C3jQHw0b8JkoCMy3Vn9QgqLdl3F7TxptAKfSVx", forKey: "X-Parse-REST-API-Key")
                
                let parameters : [ String : AnyObject] = [
                    "URL": self.photoUrl,
                    "forDate": self.chosenDate,
                    "IGUsername": self.username,
                    "imageCategory": self.categoryPickerView.selectedRowInComponent(0),
                    "addedBy": self.categoryPickerView.selectedRowInComponent(1).description,
                    "PhotoNum": 0
                ]
                
                Alamofire.request(.POST, "https://api.parse.com/1/classes/IGPhoto", parameters: parameters, encoding: .JSON)
                    .responseJSON { (request, response, JSON, error) in
                        println("Parse response: \(JSON)")
                        Alamofire.Manager.sharedInstance.defaultHeaders.removeValueForKey("X-Parse-Application-Id")
                        Alamofire.Manager.sharedInstance.defaultHeaders.removeValueForKey("X-Parse-REST-API-Key")
                }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.categoryPickerView.delegate = self
        self.urlTextField.becomeFirstResponder()
    
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func tapGesture(sender: AnyObject) {
        println("im gay")
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int {
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

