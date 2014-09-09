//
//  ViewController.swift
//  SickAF MGR
//
//  Created by dtown on 9/9/14.
//  Copyright (c) 2014 sickaf. All rights reserved.
//

import UIKit
import Alamofire


class ViewController: UIViewController {
                            
    @IBOutlet weak var dateView: UIDatePicker!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var consoleLabel: UILabel!
    
    @IBAction func postButton(sender: UIButton) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd 'at' h:mm a"
        
        urlTextField.text = dateFormatter.stringFromDate(dateView.date)
    }
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let detailViewController = segue.destinationViewController.topViewController as? DetailViewController {
            func requestForSegue(segue: UIStoryboardSegue) -> Request? {
                switch segue.identifier {
                case "GET":
                    return Alamofire.request(.GET, "http://httpbin.org/get")
                case "POST":
                    return Alamofire.request(.POST, "http://httpbin.org/post")
                case "PUT":
                    return Alamofire.request(.PUT, "http://httpbin.org/put")
                case "DELETE":
                    return Alamofire.request(.DELETE, "http://httpbin.org/delete")
                default:
                    return nil
                }
            }
            
            if let request = requestForSegue(segue) {
                detailViewController.request = request
            }
        }
    }
*/
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    
    - (IBAction)addInstaButton:(id)sender {
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.instaUrlTextField.text]
    cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
    timeoutInterval:10];
    [request setHTTPMethod: @"GET"];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
    NSString *imageUrl = [[NSString alloc] initWithData:response1 encoding:NSUTF8StringEncoding];
    imageUrl = [imageUrl componentsSeparatedByString:@"og:image\" content=\""][1];
    imageUrl = [imageUrl componentsSeparatedByString:@"\""][0];
    _imageUrl = imageUrl;
    
    NSString *imageUsername = [[NSString alloc] initWithData:response1 encoding:NSUTF8StringEncoding];
    imageUsername = [imageUsername componentsSeparatedByString:@"og:description\" content=\""][1];
    imageUsername = [imageUsername componentsSeparatedByString:@"\'"][0];
    _imageUsername = imageUsername;
    
    self.consoleLabel.text = [NSString stringWithFormat:@"%@\n%@", imageUsername, imageUrl];
}
    
    
    
    - (IBAction)postButton:(id)sender {
    
    NSString *postRequestStr= @"https://api.parse.com/1/classes/IGPhoto";
    NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:postRequestStr]];
    
    [postRequest setHTTPMethod:@"POST"];
    [postRequest addValue:@"p8AF2BKCLQ7fr3oJXPg43fOL6LXAK3mwAb5Ywnke" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [postRequest addValue:@"v8C3jQHw0b8JkoCMy3Vn9QgqLdl3F7TxptAKfSVx" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [postRequest addValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    
    NSDictionary *temp = [[NSDictionary alloc] initWithObjectsAndKeys:
    _imageUrl, @"URL",
    self.dateTextField.text, @"forDate",
    _imageUsername, @"IGUsername",
    nil];
    NSError *postError;
    NSURLResponse *urlPostResponse = nil;
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:temp options:0 error:&postError];
    [postRequest setHTTPBody:postData];
    
    NSData *postResponse = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:&urlPostResponse error:&postError];
    
    NSString *postResponseString = [[NSString alloc] initWithData:postResponse encoding:NSUTF8StringEncoding];
    NSLog(postResponseString);
    
    }
    
    */
    

}

