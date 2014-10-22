//
//  AppDelegate.swift
//  SickAF MGR
//
//  Created by dtown on 9/9/14.
//  Copyright (c) 2014 sickaf. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?
    var sessionToken = "lol"

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        Parse.setApplicationId("p8AF2BKCLQ7fr3oJXPg43fOL6LXAK3mwAb5Ywnke", clientKey: "1XJhUPLe2s8FFDiNHG7izpTxnU173WsGA4MRGmdh")
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        self.loginUser()
        return true
    }
    
    func loginUser()
    {
        let applicationID = "p8AF2BKCLQ7fr3oJXPg43fOL6LXAK3mwAb5Ywnke"
        let restApiKey = "v8C3jQHw0b8JkoCMy3Vn9QgqLdl3F7TxptAKfSVx"
        
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders?.updateValue(applicationID, forKey: "X-Parse-Application-Id")
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders?.updateValue(restApiKey, forKey: "X-Parse-REST-API-Key")

        let userParameters : [ String : AnyObject] = [
            "username": "admin",
            "password": "meat69spin",
        ]
        
        Alamofire.request(.GET, "https://api.parse.com/1/login", parameters: userParameters, encoding: Alamofire.ParameterEncoding.URL)
            .responseJSON
            { (request, response, JSON, error) in
                println("response is \(JSON)")
                
                if let json = JSON as? Dictionary<String, AnyObject>
                {
                    if let token = json["sessionToken"] as AnyObject? as? String
                    {
                        println("retrieved token is \(token)")
                        self.sessionToken = token
                    }
                }
                
                
        }
    }    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

