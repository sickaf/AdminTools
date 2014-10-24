//
//  InstagramProfileViewController.swift
//  SickAF MGR
//
//  Created by Cody Kolodziejzyk on 10/23/14.
//  Copyright (c) 2014 sickaf. All rights reserved.
//

import UIKit
import Alamofire

class InstagramProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    var username:String?
    let mediaEndpoint: String = "https://api.instagram.com/v1/users/"
    let clientID = "c16a25899b924b27aaea9a83bf6e3a8f"
    var userID:String?
    var dateString:String?
    var data:[JSON] = []
    var nextURL:String?
    var loading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.username!
        if let id = userID {
            getData(id)
        }
    }
    
    // MARK: Helpers
    
    func getData(userID:String) {
        
        if (loading) { return }
        
        loading = true
        
        var newEndpoint:String!
        
        if let newUrl = self.nextURL {
            newEndpoint = newUrl
        }
        else {
            newEndpoint = mediaEndpoint + userID + "/media/recent"
        }
        
        Alamofire.request(.GET, newEndpoint, parameters: ["client_id" : clientID])
            .responseJSON { (request, response, jsonString, error) in
                self.loading = false
                self.loader.stopAnimating()
                let json = JSON(jsonString!)
                
                let tempNext = json["pagination"]["next_url"]
                self.nextURL = tempNext.asString
                
                println(json)
                let data = json["data"]
                if let dataArray = data.asArray {
                    self.data = self.data + dataArray
                    self.collectionView.reloadData()
                }
                else {
                    SVProgressHUD.showErrorWithStatus("Error")
                    self.navigationController?.popViewControllerAnimated(true)
                }
        }
    }
    
    // MARK: Collection View Data Source
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // MARK: Collection View Delegate
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ImageCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as ImageCell
        cell.contentView.backgroundColor = UIColor.whiteColor()
        let urlString = self.data[indexPath.row]["images"]["thumbnail"]["url"]
        if let url = urlString.asString {
            cell.imageView.setImageWithURL(NSURL(string: url))
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let size = (self.view.bounds.size.width - 10) / 3
        return CGSizeMake(size, size)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        
        let urlString = self.data[indexPath.row]["images"]["standard_resolution"]["url"]
        let urlLink = self.data[indexPath.row]["link"]
        let likes = self.data[indexPath.row]["likes"]["count"]
        let comments = self.data[indexPath.row]["comments"]["count"]
        if let url = urlString.asString {
            let sb = UIStoryboard(name: "Home", bundle: NSBundle.mainBundle())
            let viewController = sb.instantiateViewControllerWithIdentifier("single") as SingleImageViewController
            viewController.imageUrl = url
            viewController.imageLink = urlLink.asString
            viewController.dateString = self.dateString
            viewController.likes = likes.asInt
            viewController.comments = comments.asInt
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        let scrollViewHeight = scrollView.frame.size.height
        let scrollContentSizeHeight = scrollView.contentSize.height
        let scrollOffset = scrollView.contentOffset.y
        
        if (scrollOffset + scrollViewHeight >= scrollContentSizeHeight) {
            if let id = userID {
                self.getData(id)
            }
        }
    }
}
