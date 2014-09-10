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



class ViewController: UIViewController {
                            
    @IBOutlet weak var dateView: UIDatePicker!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var consoleLabel: UILabel!
    let dateFormatter = NSDateFormatter()
    var photoUrl = ""
    var username = ""
    var forDate = "2015-01-01"
    
    @IBAction func postButton(sender: UIButton) {
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        forDate = dateFormatter.stringFromDate(dateView.date)
        consoleLabel.text = forDate
        Alamofire.request(.GET, urlTextField.text )
            .responseString { (request, response, string, error) in
                var responseString = string!
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
                Alamofire.Manager.sharedInstance.defaultHeaders.updateValue("application/json", forKey: "Content-Type")
                
                let parameters : [ String : AnyObject] = [
                    "URL": self.photoUrl,
                    "forDate": self.forDate,
                    "IGUsername": self.username
                ]
                
                Alamofire.request(.POST, "https://api.parse.com/1/classes/IGPhoto", parameters: parameters, encoding: .JSON)
                    .responseJSON { (request, response, JSON, error) in
                        println("Parse response: \(JSON)")
                }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

