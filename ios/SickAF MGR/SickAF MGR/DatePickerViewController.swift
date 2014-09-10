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
    let dateFormatter = NSDateFormatter()
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressedDone(sender: UIDatePicker) {
        let dateString = dateFormatter.stringFromDate(datePicker.date)
        delegate?.datePicked(dateString)
    }
}

protocol DatePickerDelegate {
    func datePicked(date: String)
}
