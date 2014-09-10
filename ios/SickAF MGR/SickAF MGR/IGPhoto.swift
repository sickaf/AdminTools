//
//  IGPhoto.swift
//  SickAF MGR
//
//  Created by Cody Kolodziejzyk on 9/10/14.
//  Copyright (c) 2014 sickaf. All rights reserved.
//

import UIKit

class IGPhoto: NSObject {
    var url: String?
    var username: String?
    
    init(url: String, username: String) {
        self.url = url
        self.username = username
    }
}
