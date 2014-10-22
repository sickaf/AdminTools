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
    var startDate: NSDate?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clearColor()
        self.bgView.backgroundColor = UIColor(white: 0, alpha: 0.8)
        self.bgView.alpha = 0
        self.topConstraint.constant -= self.containerView.frame.size.height
        self.view.layoutIfNeeded()
        if let date = self.startDate {
            self.datePicker.date = date
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.topConstraint.constant = -20
        UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.6, options: UIViewAnimationOptions.CurveEaseInOut, animations: ({
            self.view.layoutIfNeeded()
            self.bgView.alpha = 1
        }), completion: nil)
    }
    
    func dismiss() {
        self.delegate?.switchedToDate(self.datePicker.date)
        self.topConstraint.constant -= self.containerView.frame.size.height
        UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.6, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.view.layoutIfNeeded()
            self.bgView.alpha = 0;
        }, completion: {
            (value: Bool) in
            self.testfunc()
        })
    }
    
    func testfunc() {
        self.delegate?.datePickerDismiss()
    }
}

protocol DatePickerDelegate {
    func switchedToDate(date: NSDate)
    func datePickerDismiss()
}
