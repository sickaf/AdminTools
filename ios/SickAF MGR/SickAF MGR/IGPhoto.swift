//
//  IGPhoto.swift
//  SickAF MGR
//
//  Created by Cody Kolodziejzyk on 9/10/14.
//  Copyright (c) 2014 sickaf. All rights reserved.
//

import UIKit

enum Category : Int {
    case Girl = 0
    case Guy = 1
    case Animal = 2
    
    func simpleDescription() -> String {
        switch self {
        case .Girl:
            return "Girls"
        case .Guy:
            return "Guys"
        case .Animal:
            return "Animals"
        default:
            return "No Category"
        }
    }
}

class IGPhoto: NSObject {
    var url: String?
    var username: String?
    var objectId: String?
    var photoNum: Int?
    var category: Category?
    
    init(url: String, username: String, objectId: String, photoNum: Int, category: Category) {
        self.url = url
        self.username = username
        self.objectId = objectId
        self.photoNum = photoNum
        self.category = category
    }
}
