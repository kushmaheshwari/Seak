//
//  NotificationsViewController.swift
//  SeakApp
//
//  Created by Екатерина Волкова on 07/10/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit

class NotificationViewCellController: UITableViewCell
{
    @IBOutlet weak var notifyImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
}

class NotificationsViewController: UITableViewController {
    
    @IBOutlet var notificationsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.notificationsTableView.dataSource = self
        self.notificationsTableView.delegate = self
        
        self.notificationsTableView.separatorColor = UIColor.colorWithHexString("f5f5f5")
        
        
    }
    
    @IBAction func menuIconPressed(_ sender: AnyObject) {
     self.slideMenuController()?.openLeft()   
    }
    
//    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 4))
//        headerView.backgroundColor = UIColor.clear
//        return headerView
//    }
//    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 15
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifire = "Cell"
        if let cell = notificationsTableView.dequeueReusableCell(withIdentifier: cellIdentifire) as? NotificationViewCellController
        {
            cell.backgroundColor = UIColor.colorWithHexString("f5f5f5")
            cell.timeLabel.text = "15 years ago"
            cell.descriptionLabel.text = "What a great news we have for you! You received an excellent discount in your favourite shop!"
            return cell
        }
        return UITableViewCell()
    }
}
