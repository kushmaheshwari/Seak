//
//  StartAppViewController.swift
//  SeakApp
//
//  Created by Roman Volkov on 15/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit

class StartAppViewController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier(StoryboardNames.Login.rawValue)
		let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate

		if (FBSDKAccessToken.currentAccessToken() != nil) {
            let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
            
            FIRAuth.auth()?.signInWithCredential(credential, completion: { (user, autherror) in
                if user != nil {
                    UserLogin.loginType = .Facebook
                    let startView = self.storyboard?.instantiateViewControllerWithIdentifier(StoryboardNames.Main.rawValue)
                    appDelegate?.window?.rootViewController = startView
                } else {
                    print("Uh oh. There was an error logging in.")
                    appDelegate?.window?.rootViewController = loginVC
                }
                
            })
		}
		else
		if FIRAuth.auth()?.currentUser != nil {
			UserLogin.loginType = .Firebase
			let startView = self.storyboard?.instantiateViewControllerWithIdentifier(StoryboardNames.Main.rawValue)
			appDelegate?.window?.rootViewController = startView
		}

		else {
			appDelegate?.window?.rootViewController = loginVC
		}

	}
}