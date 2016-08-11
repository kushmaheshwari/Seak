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
        
        let backgroundSelectedCell: UIView = UIView()
        backgroundSelectedCell.backgroundColor = UIColor(red: 33 / 256.0, green: 194 / 256.0, blue: 248 / 256.0, alpha: 0.5)
        for section in 0..<self.tableView.numberOfSections {
            for row in 0..<self.tableView.numberOfRowsInSection(section) {
                let cellPath: NSIndexPath = NSIndexPath(forRow: row, inSection: section)
                let cell: UITableViewCell = self.tableView.cellForRowAtIndexPath(cellPath)!
                cell.selectedBackgroundView = backgroundSelectedCell
            }
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let userRadius = UserDataCache.getUserRadius()
        {
            switch userRadius {
            case 10:
                let cellPath: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
                self.tableView.selectRowAtIndexPath(cellPath, animated: false, scrollPosition: .None)
            case 25:
                let cellPath: NSIndexPath = NSIndexPath(forRow: 0, inSection: 1)
                self.tableView.selectRowAtIndexPath(cellPath, animated: false, scrollPosition: .None)
            case 50:
                let cellPath: NSIndexPath = NSIndexPath(forRow: 0, inSection: 2)
                self.tableView.selectRowAtIndexPath(cellPath, animated: false, scrollPosition: .None)
            default:
                return
            }
        }
        else {
            //All stores
            let cellPath: NSIndexPath = NSIndexPath(forRow: 0, inSection: 3)
            self.tableView.selectRowAtIndexPath(cellPath, animated: false, scrollPosition: .None)
        }

    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = indexPath.section
        switch(section)
        {
            case 0: UserDataCache.saveUserRadius(10)
            case 1: UserDataCache.saveUserRadius(25)
            case 2: UserDataCache.saveUserRadius(50)
            case 3: UserDataCache.saveUserRadius(nil)
            default: return
        }
    }
    
    
}
