//
//  MenuViewController.swift
//  SeakApp
//
//  Created by Roman Volkov on 06/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit
import Parse
import ParseFacebookUtilsV4

class MenuViewController: UITableViewController {

	@IBOutlet weak var logoImage: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!

	override func viewDidLoad() {
		super.viewDidLoad()
		logoImage.layer.cornerRadius = CGFloat(50)
		logoImage.layer.borderWidth = 10
		logoImage.clipsToBounds = true
		logoImage.layer.borderColor = UIColor.colorWithHexString("1677a6").CGColor

		nameLabel.text = "USER NAME"

		switch UserLogin.loginType {
		case .Facebook:
			setFacebookInfo()
		case .Parse:
			setParseInfo()
		default: break
		}

	}

	func setParseInfo() {
		self.nameLabel.text = PFUser.currentUser()?.username
	}

	func setFacebookInfo() {
		if let userName = UserDataCache.getUserName() {
			self.nameLabel.text = userName
		}
		else {
			let firstName = FBSDKProfile.currentProfile().firstName
			let lastname = FBSDKProfile.currentProfile().lastName
			let userName = firstName + " " + lastname
			self.nameLabel.text = userName
			UserDataCache.saveUserName(userName)
		}

		if let userPictureData = UserDataCache.getUserPicture() {
			self.logoImage.image = UIImage(data: userPictureData)
		}
		else {
			let url = FBSDKProfile.currentProfile().imageURLForPictureMode(.Square, size: self.logoImage.frame.size)
			if let data = NSData(contentsOfURL: url) {
				self.logoImage.image = UIImage(data: data)
				UserDataCache.saveUserPicture(data)
			}
		}
	}

	override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		if (section == self.tableView.numberOfSections - 1) {
			return UIView(frame: CGRectMake(0, 0, 1, 1))
		}
		return nil
	}

	override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		if (section == self.tableView.numberOfSections - 1) {
			return 1
		}

		return 0
	}

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		// Browse
		if indexPath.row == 1 {
			if let controller = self.storyboard?.instantiateViewControllerWithIdentifier(StoryboardNames.Navigation.rawValue) {
				self.slideMenuController()?.changeMainViewController(controller, close: true)
			}
		}
		// Stores
		if indexPath.row == 2 {
			guard let controller = self.storyboard?.instantiateViewControllerWithIdentifier(StoryboardNames.StoreNavigation.rawValue) else { return }
			self.slideMenuController()?.changeMainViewController(controller, close: true)
		}

		// Settings
		if indexPath.row == 5 {
			print("LOGOUT")
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

	override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		if (indexPath.row > 0 && indexPath.row != self.tableView.numberOfRowsInSection(0) - 1) {
			let line = UIView(frame: CGRectMake(0, cell.bounds.size.height - 1.5, cell.bounds.size.width, 1.5))
			line.backgroundColor = UIColor.colorWithHexString("53AECA")
			cell.addSubview(line)
			cell.bringSubviewToFront(line)

		}
		let bgView = UIView()
		bgView.backgroundColor = UIColor.clearColor()
		cell.selectedBackgroundView = bgView
		cell.selectionStyle = .None
	}
}