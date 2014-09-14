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
    var objectId: String?
    var photoNum: Int?
    
    init(url: String, username: String, objectId: String, photoNum: Int) {
        self.url = url
        self.username = username
        self.objectId = objectId
        self.photoNum = photoNum
    }
}
