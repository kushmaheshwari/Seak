//
//  RadiusViewController.swift
//  SeakApp
//
//  Created by Екатерина Волкова on 03/08/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit

class RadiusViewController: UITableViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view?.backgroundColor = UIColor.lightGrayColor()
        self.navigationItem.title = "Radius"
        
        let emptyView = UIView(frame: CGRectZero)
        self.tableView.tableFooterView = emptyView
        self.tableView.tableFooterView?.hidden = true
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
}
