//
//  MenuViewController.swift
//  SeakApp
//
//  Created by Roman Volkov on 06/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FBSDKLoginKit

class MenuViewController: UITableViewController {

    private let userRepository = UserRepository()
    
	@IBOutlet weak var logoImage: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!

	override func viewDidLoad() {
		super.viewDidLoad()
		logoImage.layer.cornerRadius = CGFloat(50)
		logoImage.layer.borderWidth = 10
		logoImage.clipsToBounds = true
		logoImage.layer.borderColor = UIColor.colorWithHexString("1677a6").cgColor

		nameLabel.text = "USER NAME"

		switch UserLogin.loginType {
		case .facebook:
			setFacebookInfo()
		case .firebase:
			setFirebaseInfo()
		default: break
		}

	}

	func setFirebaseInfo() {
		if let user = FIRAuth.auth()?.currentUser {
			self.nameLabel.text = user.displayName ?? user.email
		}
	}

	func setFacebookInfo() {
        var name:String? = nil
        var link:String? = nil
        
		if let userName = UserDataCache.getUserName() {
			self.nameLabel.text = userName
            name = userName
		}
		else {
			let firstName = FBSDKProfile.current().firstName
			let lastname = FBSDKProfile.current().lastName
			let userName = firstName! + " " + lastname!
			self.nameLabel.text = userName
            name = userName
			UserDataCache.saveUserName(userName)
		}

		if let userPictureData = UserDataCache.getUserPicture() {
			self.logoImage.image = UIImage(data: userPictureData as Data)
		}
		else {
			let url = FBSDKProfile.current().imageURL(for: .square, size: self.logoImage.frame.size)
			if let data = try? Data(contentsOf: url!) {
				self.logoImage.image = UIImage(data: data)
				UserDataCache.saveUserPicture(data)
			}
            link = url?.absoluteString
			UserLogin.storeFacebookUserPictureBackend()
		}
        
        self.userRepository.saveUser(username: name, userPic: link, saveCallback: {})
	}

	override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		if (section == self.tableView.numberOfSections - 1) {
			return UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
		}
		return nil
	}

	override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		if (section == self.tableView.numberOfSections - 1) {
			return 1
		}

		return 0
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// Browse
		if (indexPath as NSIndexPath).row == 1 {
			if let controller = self.storyboard?.instantiateViewController(withIdentifier: StoryboardNames.Navigation.rawValue) {
				self.slideMenuController()?.changeMainViewController(controller, close: true)
			}
		}
		// Stores
		if (indexPath as NSIndexPath).row == 2 {
			guard let controller = self.storyboard?.instantiateViewController(withIdentifier: StoryboardNames.StoreNavigation.rawValue) else { return }
			self.slideMenuController()?.changeMainViewController(controller, close: true)
		}
        
        //Favorites
        if (indexPath as NSIndexPath).row == 3 {
            guard let controller = self.storyboard?.instantiateViewController(withIdentifier: StoryboardNames.FavNavigation.rawValue) else { return }
            self.slideMenuController()?.changeMainViewController(controller, close: true)
        }
        
        if (indexPath as NSIndexPath).row == 4 {
            guard let controller = self.storyboard?.instantiateViewController(withIdentifier: StoryboardNames.NotificationsView.rawValue) else { return }
            self.slideMenuController()?.changeMainViewController(controller, close: true)
        }
        
		// Settings
		if (indexPath as NSIndexPath).row == 5 {
            guard let controller = self.storyboard?.instantiateViewController(withIdentifier: StoryboardNames.SettingNavigation.rawValue) else { return }
            self.slideMenuController()?.changeMainViewController(controller, close: true)

		}
	}

	override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if ((indexPath as NSIndexPath).row > 0 && (indexPath as NSIndexPath).row != self.tableView.numberOfRows(inSection: 0) - 1) {
			let line = UIView(frame: CGRect(x: 0, y: cell.bounds.size.height - 1.5, width: cell.bounds.size.width, height: 1.5))
			line.backgroundColor = UIColor.colorWithHexString("53AECA")
			cell.addSubview(line)
			cell.bringSubview(toFront: line)

		}
		let bgView = UIView()
		bgView.backgroundColor = UIColor.clear
		cell.selectedBackgroundView = bgView
		cell.selectionStyle = .none
	}
}
