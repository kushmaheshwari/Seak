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
				let NavigationVC: UIViewController = storyboard.instantiateViewControllerWithIdentifier(StoryboardNames.Main.rawValue)
				view.presentViewController(NavigationVC, animated: true, completion: nil)

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

	static func storeFacebookInfobackend() {
		if let user = FIRAuth.auth()?.currentUser {
			let url = FBSDKProfile.currentProfile().imageURLForPictureMode(.Square, size: CGSize(width: 100, height: 100))
			if let data = NSData(contentsOfURL: url) {
				// TODO store Facebook Profile image
//				let img = PFFile(name: "\(user.objectId!)", data: data)
//				img?.saveInBackgroundWithBlock({ (success, error) in
//					if success {
//						user["userPicture"] = img
//						user["firstName"] = FBSDKProfile.currentProfile().firstName
//						user["lastName"] = FBSDKProfile.currentProfile().lastName
//						user.saveInBackground()
//					} else {
//						print (error)
//					}
//				})
			}
		}
	}

	static func signUp(username: String, email: String,
		password: String, firsname: String,
		lastname: String, view: UIViewController) {
        
			// TODO store lastname and firstname in DB
			FIRAuth.auth()?.createUserWithEmail(email, password: password) { (user, error) in
				if error == nil {
					let LoginVC: UIViewController = storyboard.instantiateViewControllerWithIdentifier(StoryboardNames.Login.rawValue)
					view.presentViewController(LoginVC, animated: true, completion: nil)
				} else {
					print(error?.userInfo["error"])
//                    callAlert(<#T##message: String##String#>)
				}
			}

	}
}