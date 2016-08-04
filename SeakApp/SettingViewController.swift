//
//  SettingViewController.swift
//  SeakApp
//
//  Created by Екатерина Волкова on 02/08/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit

class SettingViewController: UITableViewController
{

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
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
}
