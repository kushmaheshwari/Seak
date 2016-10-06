//
//  UserLogin.swift
//  SeakApp
//
//  Created by Roman Volkov on 04/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit

class UserLogin: UIViewController {

	fileprivate static let storyboard = UIStoryboard(name: StoryboardNames.MainStoryboard.rawValue, bundle: nil)
    
	static var loginType: UserLoginType = .none

	static func logIn(_ username: String, password: String, view: UIViewController) {

		FIRAuth.auth()?.signIn(withEmail: username, password: password, completion: { (user, error) in
			if error == nil {
                UserLogin.loginType = .firebase
                let homeView = self.storyboard.instantiateViewController(withIdentifier: StoryboardNames.Main.rawValue)
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = homeView
                
                UserRepository().saveUser(username: FIRAuth.auth()?.currentUser?.displayName, userPic: nil, saveCallback: {})
			} else {
				// problem
				print(error);
				callAlert("Invalid Login")
			}
		})
	}

	static func callAlert(_ message: String) {

		let alertController: UIAlertController = UIAlertController(title: message, message: "", preferredStyle: UIAlertControllerStyle.alert)
		alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action: UIAlertAction!) in
			print("Handle Cancel Logic here")
			}))
		UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)

	}

	static func storeFacebookUserPictureBackend() {
		if let user = FIRAuth.auth()?.currentUser {
			let url = FBSDKProfile.current().imageURL(for: .square, size: CGSize(width: 100, height: 100))
			let request = user.profileChangeRequest()
			request.photoURL = url
			request.commitChanges(completion: { (error) in
				if error != nil {
					print(error)
				} else {
					print("Profile picture updated.")
					UserDataCache.saveUserPicture(try? Data(contentsOf: url!))
				}
			})
		}
	}

	static func signUp(_ username: String, email: String,
		password: String, firstname: String,
		lastname: String, view: UIViewController) {

			FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
				if error == nil {
					let LoginVC: UIViewController = storyboard.instantiateViewController(withIdentifier: StoryboardNames.Login.rawValue)
					view.present(LoginVC, animated: true, completion: nil)

					if let request = user?.profileChangeRequest() {
						request.displayName = "\(firstname) \(lastname)"
						request.commitChanges(completion: { (error) in
							if error != nil {
								print(error)
							} else {
								print("Profile updated.")
							}
						})
					}
				} else {
                    //let alert = UIAlertController(title: "Register failed", message: error?.localizedDescription, preferredStyle: .alert)
                    //alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.callAlert((error?.localizedDescription)!)
				}
			}

	}
}
