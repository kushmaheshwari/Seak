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
        
        self.view?.backgroundColor = UIColor.lightGray
        self.navigationItem.title = "Radius"
        
        let emptyView = UIView(frame: CGRect.zero)
        self.tableView.tableFooterView = emptyView
        self.tableView.tableFooterView?.isHidden = true
        
        let backgroundSelectedCell: UIView = UIView()
        backgroundSelectedCell.backgroundColor = UIColor(red: 33 / 256.0, green: 194 / 256.0, blue: 248 / 256.0, alpha: 0.5)
        for section in 0..<self.tableView.numberOfSections {
            for row in 0..<self.tableView.numberOfRows(inSection: section) {
                let cellPath: IndexPath = IndexPath(row: row, section: section)
                let cell: UITableViewCell = self.tableView.cellForRow(at: cellPath)!
                cell.selectedBackgroundView = backgroundSelectedCell
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let userRadius = UserDataCache.getUserRadius()
        {
            switch userRadius {
            case 10:
                let cellPath: IndexPath = IndexPath(row: 0, section: 0)
                self.tableView.selectRow(at: cellPath, animated: false, scrollPosition: .none)
            case 25:
                let cellPath: IndexPath = IndexPath(row: 0, section: 1)
                self.tableView.selectRow(at: cellPath, animated: false, scrollPosition: .none)
            case 50:
                let cellPath: IndexPath = IndexPath(row: 0, section: 2)
                self.tableView.selectRow(at: cellPath, animated: false, scrollPosition: .none)
            default:
                return
            }
        }
        else {
            //All stores
            let cellPath: IndexPath = IndexPath(row: 0, section: 3)
            self.tableView.selectRow(at: cellPath, animated: false, scrollPosition: .none)
        }

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = (indexPath as NSIndexPath).section
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
