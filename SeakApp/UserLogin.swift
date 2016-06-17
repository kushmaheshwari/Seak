//
//  UserLogin.swift
//  SeakApp
//
//  Created by Roman Volkov on 04/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import Parse

class UserLogin {

	private static let storyboard = UIStoryboard(name: StoryboardNames.MainStoryboard.rawValue, bundle: nil)

	static func logIn(username: String, password: String, view: UIViewController) {
		PFUser.logInWithUsernameInBackground(username, password: password, block: {
			(user: PFUser?, error: NSError?) -> Void in

			if error == nil {
				dispatch_async(dispatch_get_main_queue()) {
					let NavigationVC: UIViewController = storyboard.instantiateViewControllerWithIdentifier(StoryboardNames.Main.rawValue)
					view.presentViewController(NavigationVC, animated: true, completion: nil)

				}
			} else {
				// problem
				print(error);
			}

		})

	}

	static func signUp(username: String, email: String,
		password: String, firsname: String,
		lastname: String, view: UIViewController) {
			let user = PFUser()
			user.username = username
			user.email = email
			user.password = password

			user["firstName"] = firsname
			user["lastName"] = lastname

			user.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
				if error == nil {

					let LoginVC: UIViewController = storyboard.instantiateViewControllerWithIdentifier(StoryboardNames.Login.rawValue)
					view.presentViewController(LoginVC, animated: true, completion: nil)
				} else {
					print(error?.userInfo["error"]!)
				}
			}

	}
}