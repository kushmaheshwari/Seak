//
//  StartAppViewController.swift
//  SeakApp
//
//  Created by Roman Volkov on 15/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit
import ParseFacebookUtilsV4

class StartAppViewController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier(StoryboardNames.Login.rawValue)
		let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate

		if (FBSDKAccessToken.currentAccessToken() != nil || PFUser.currentUser() != nil) {
			if PFUser.currentUser() != nil {
				let startView = self.storyboard?.instantiateViewControllerWithIdentifier(StoryboardNames.Main.rawValue)
				appDelegate?.window?.rootViewController = startView
			}
			else

			if (FBSDKAccessToken.currentAccessToken() != nil) {
				let accessToken: FBSDKAccessToken = FBSDKAccessToken.currentAccessToken()

				PFFacebookUtils.logInInBackgroundWithAccessToken(accessToken,
					block: { (user: PFUser?, error: NSError?) -> Void in
						if user != nil {
							print("User logged in through Facebook!")
							let startView = self.storyboard?.instantiateViewControllerWithIdentifier(StoryboardNames.Main.rawValue)
							appDelegate?.window?.rootViewController = startView
						} else {
							print("Uh oh. There was an error logging in.")
							appDelegate?.window?.rootViewController = loginVC
						}
				})
			}
			else {
				appDelegate?.window?.rootViewController = loginVC
			}

		}
		else {
			appDelegate?.window?.rootViewController = loginVC
		}
	}
}