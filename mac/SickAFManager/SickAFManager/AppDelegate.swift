//
//  AppDelegate.swift
//  SickAFManager
//
//  Created by Cody Kolodziejzyk on 9/9/14.
//  Copyright (c) 2014 sick.af. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
                            
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var slider: NSSlider!
    @IBOutlet weak var muteButton: NSButton!
    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application
    }

    @IBAction func pressedMute(sender: AnyObject) {
        slider.intValue = 0
        textField.stringValue = "\(0)"
    }

    @IBAction func takeFloatValueFromTextField(sender: AnyObject) {
        
        if (sender.isKindOfClass(NSSlider)) {
            textField.stringValue = "\(sender.intValue)"
        }
        
        if (sender.isKindOfClass(NSTextField)) {
            slider.intValue = textField.intValue
        }
    }
}

