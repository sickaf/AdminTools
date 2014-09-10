//
//  DatePickerViewController.swift
//  SickAF MGR
//
//  Created by Cody Kolodziejzyk on 9/10/14.
//  Copyright (c) 2014 sickaf. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {
    
    var delegate: DatePickerDelegate?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressedDone(sender: UIDatePicker) {
        delegate?.datePicked(datePicker.date)
    }
    
    @IBAction func pressedX(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

protocol DatePickerDelegate {
    func datePicked(date: NSDate)
}
