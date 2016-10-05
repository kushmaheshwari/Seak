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
		let loginVC = self.storyboard?.instantiateViewController(withIdentifier: StoryboardNames.Login.rawValue)
		let appDelegate = UIApplication.shared.delegate as? AppDelegate

		if (FBSDKAccessToken.current() != nil) {
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            
            FIRAuth.auth()?.signIn(with: credential, completion: { (user, autherror) in
                if user != nil {
                    UserLogin.loginType = .facebook
                    let startView = self.storyboard?.instantiateViewController(withIdentifier: StoryboardNames.Main.rawValue)
                    appDelegate?.window?.rootViewController = startView
                } else {
                    print("Uh oh. There was an error logging in.")
                    appDelegate?.window?.rootViewController = loginVC
                }
                
            })
		}
		else
		if FIRAuth.auth()?.currentUser != nil {
			UserLogin.loginType = .firebase
			let startView = self.storyboard?.instantiateViewController(withIdentifier: StoryboardNames.Main.rawValue)
			appDelegate?.window?.rootViewController = startView
		}

		else {
			appDelegate?.window?.rootViewController = loginVC
		}

	}
}
