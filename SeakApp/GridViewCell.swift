//
//  GridViewCell.swift
//  SeakApp
//
//  Created by Kush Maheshwari on 5/29/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet var productImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var usedLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var sellerImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //    self.itemNameLabel.text = "hello"
        self.layer.cornerRadius = 3.0
        self.layer.borderColor = UIColor(red: 196/255.0, green: 203/255.0, blue: 220/255.0, alpha: 1).CGColor
        self.layer.borderWidth = 1.0
        self.productImageView.layer.borderWidth = 1.0
        self.productImageView.layer.borderColor = UIColor(red: 196/255.0, green: 203/255.0, blue: 220/255.0, alpha: 1).CGColor
        favoriteButton.addTarget(self, action: "addToFavorites:", forControlEvents: UIControlEvents.TouchUpInside)
        
        /*    let singleTap = UITapGestureRecognizer(target: self, action:"tapDetected:")
         singleTap.numberOfTapsRequired = 1
         sellerImageView.userInteractionEnabled = true
         sellerImageView.addGestureRecognizer(singleTap)*/
        
        
        
        /*   let image = UIImage(named: "favorite.png")
         favoriteButton.setImage(image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: .Normal)
         favoriteButton.tintColor = UIColor.blackColor()*/
    }
    
    func addToFavorites(sender:UIButton!)
    {
        print("Button Clicked")
        sender.setImage(UIImage(named: "heart2.png"), forState: UIControlState.Normal)
    }
    /*  func tapDetected(){
     let Storyboard = UIStoryboard(name: "Main",bundle: nil)
     let MainVC : UIViewController = Storyboard.instantiateViewControllerWithIdentifier("Profile")
     self.performSegueWithIdentifier("someID", sender: nil)
     }*/
}

