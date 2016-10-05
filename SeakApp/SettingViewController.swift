//
//  SettingViewController.swift
//  SeakApp
//
//  Created by Екатерина Волкова on 02/08/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FBSDKLoginKit
import FirebaseAuth
import SlideMenuControllerSwift

class SettingViewController: UITableViewController
{

    @IBOutlet weak var logoutRow: UITableViewCell!
    
    @IBAction func menuIconPressed(_ sender: AnyObject) {
        self.slideMenuController()?.openLeft()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.view?.backgroundColor = UIColor.lightGray
        
        let emptyView = UIView(frame: CGRect.zero)
        self.tableView.tableFooterView = emptyView
        self.tableView.tableFooterView?.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(logoutTap(_:)))
        tap.numberOfTouchesRequired = 1
        logoutRow.addGestureRecognizer(tap)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func logoutTap(_ gesture: UITapGestureRecognizer)
    {
        if (FIRAuth.auth()?.currentUser != nil) {
            do {
                try FIRAuth.auth()?.signOut()
            }
            catch {
                fatalError("problems on signout")
            }
        }
        
        if (FBSDKAccessToken.current() != nil)
        {
            FBSDKLoginManager().logOut()
        }
        
        UserDataCache.clearCache()
        UserLogin.loginType = .none
        
        let loginview = self.storyboard?.instantiateViewController(withIdentifier: StoryboardNames.Login.rawValue)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = loginview
    }
}
