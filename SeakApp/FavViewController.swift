//
//  FavViewController.swift
//  SeakApp
//
//  Created by Екатерина Волкова on 13/07/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import UIKit
import Foundation

class FavViewController: UIViewController
{
    @IBOutlet weak var ItemsButton: UIButton!
    @IBOutlet weak var StoreButton: UIButton!
    let chosenTabColor = UIColor.colorWithHexString("318EC4")
    let defaultTabColor = UIColor.colorWithHexString("266D96")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ItemsButton.backgroundColor = chosenTabColor
        StoreButton.backgroundColor = defaultTabColor
        self.setTitle()
    }
    
    func setTitle() {
        let titleImage = UIImage(named: "navBarLogo")
        let imgView = UIImageView(image: titleImage)
        imgView.frame = CGRectMake(0, 0, 50, 25)
        imgView.contentMode = .ScaleAspectFit
        self.title = ""
        self.navigationItem.titleView = imgView
        self.navigationItem.title = nil
    }
    
    
    @IBAction func ItemsPressed(sender: AnyObject) {
        ItemsButton.backgroundColor = chosenTabColor
        StoreButton.backgroundColor = defaultTabColor
    }
    
    @IBAction func StorePressed(sender: AnyObject) {
        ItemsButton.backgroundColor = defaultTabColor
        StoreButton.backgroundColor = chosenTabColor
    }
    
    
    @IBAction func menuIconPressed(sender: AnyObject) {
        self.slideMenuController()?.openLeft()
    }

    @IBAction func searchIconPressed(sender: AnyObject) {
    }
  
}