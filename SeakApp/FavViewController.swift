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
    @IBOutlet weak var commonView: UIView!
    let chosenTabColor = UIColor.colorWithHexString("318EC4")
    let defaultTabColor = UIColor.colorWithHexString("266D96")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ItemsButton.backgroundColor = chosenTabColor
        StoreButton.backgroundColor = defaultTabColor
        self.setTitle()
        setViewController(StoryboardNames.ItemsCollection.rawValue)
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
        setViewController(StoryboardNames.ItemsCollection.rawValue)
    }
    
    @IBAction func StorePressed(sender: AnyObject) {
        ItemsButton.backgroundColor = defaultTabColor
        StoreButton.backgroundColor = chosenTabColor
        setViewController("")
    }
    
    
    @IBAction func menuIconPressed(sender: AnyObject) {
        self.slideMenuController()?.openLeft()
    }

    @IBAction func searchIconPressed(sender: AnyObject) {
    }
    
    func setViewController(storyBoardName: String)
    {
        let sv = commonView.subviews
        for view in sv
        {
            if view.tag == 1000
            {
                view.removeFromSuperview()
            }
        }
        
        switch(storyBoardName)
        {
            case "itemsCollectionViewID":
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                    if let vc = self.storyboard?.instantiateViewControllerWithIdentifier(storyBoardName) as? ItemsCollectionViewController {
                        vc.dataSourceType = .Favorites
                        dispatch_async(dispatch_get_main_queue(), {
                            vc.navigationVC = self.navigationController
                            vc.view.frame = self.commonView.bounds
                            vc.view.tag = 1000
                            self.addChildViewController(vc)
                            self.commonView.addSubview(vc.view)
                            self.commonView.bringSubviewToFront(vc.view)
                        })
                    }
                })
                
                break;
            default: break;
        }
    }
  
}