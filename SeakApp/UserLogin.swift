//
//  UserLogin.swift
//  SeakApp
//
//  Created by Roman Volkov on 04/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import Parse
import ParseFacebookUtilsV4
import UIKit
import Firebase

class UserLogin {

	private static let storyboard = UIStoryboard(name: StoryboardNames.MainStoryboard.rawValue, bundle: nil)

	static var loginType: UserLoginType = .None

	static func logIn(username: String, password: String, view: UIViewController) {

		FIRAuth.auth()?.signInWithEmail(username, password: password, completion: { (user, error) in
			if error == nil {
                UserLogin.loginType = .Firebase
                let homeView = self.storyboard.instantiateViewControllerWithIdentifier(StoryboardNames.Main.rawValue)
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.window?.rootViewController = homeView
			} else {
				// problem
				print(error);
				callAlert("Invalid Login")
			}
		})
	}

	static func callAlert(message: String) {

		let alertController: UIAlertController = UIAlertController(title: message, message: "", preferredStyle: UIAlertControllerStyle.Alert)
		alertController.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: { (action: UIAlertAction!) in
			print("Handle Cancel Logic here")
			}))
		UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)

	}

	static func storeFacebookUserPictureBackend() {
		if let user = FIRAuth.auth()?.currentUser {
			let url = FBSDKProfile.currentProfile().imageURLForPictureMode(.Square, size: CGSize(width: 100, height: 100))
			let request = user.profileChangeRequest()
			request.photoURL = url
			request.commitChangesWithCompletion({ (error) in
				if error != nil {
					print(error)
				} else {
					print("Profile picture updated.")
					UserDataCache.saveUserPicture(NSData(contentsOfURL: url))
				}
			})
		}
	}

	static func signUp(username: String, email: String,
		password: String, firstname: String,
		lastname: String, view: UIViewController) {

			FIRAuth.auth()?.createUserWithEmail(email, password: password) { (user, error) in
				if error == nil {
					let LoginVC: UIViewController = storyboard.instantiateViewControllerWithIdentifier(StoryboardNames.Login.rawValue)
					view.presentViewController(LoginVC, animated: true, completion: nil)

					if let request = user?.profileChangeRequest() {
						request.displayName = "\(firstname) \(lastname)"
						request.commitChangesWithCompletion({ (error) in
							if error != nil {
								print(error)
							} else {
								print("Profile updated.")
							}
						})
					}
				} else {
					print(error?.userInfo["error"])
				}
			}

	}
}