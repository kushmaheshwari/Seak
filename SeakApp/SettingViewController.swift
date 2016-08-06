//
//  SettingViewController.swift
//  SeakApp
//
//  Created by Екатерина Волкова on 02/08/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit
import Parse
import ParseFacebookUtilsV4

class SettingViewController: UITableViewController
{

    @IBOutlet weak var logoutRow: UITableViewCell!
    
    @IBAction func menuIconPressed(sender: AnyObject) {
        self.slideMenuController()?.openLeft()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        self.view?.backgroundColor = UIColor.lightGrayColor()
        
        let emptyView = UIView(frame: CGRectZero)
        self.tableView.tableFooterView = emptyView
        self.tableView.tableFooterView?.hidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(logoutTap(_:)))
        tap.numberOfTouchesRequired = 1
        logoutRow.addGestureRecognizer(tap)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func logoutTap(gesture: UITapGestureRecognizer)
    {
        if (PFUser.currentUser() != nil) {
            PFUser.logOut()
            UserDataCache.clearCache()
        } else {
            FBSDKLoginManager().logOut()
            UserDataCache.clearCache()
        }
        
        let loginview = self.storyboard?.instantiateViewControllerWithIdentifier(StoryboardNames.Login.rawValue)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = loginview
    }
}
