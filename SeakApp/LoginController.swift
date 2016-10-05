//
//  LoginController.swift
//  SeakApp
//
//  Created by Kush Maheshwari on 5/29/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import QuartzCore
import Firebase

class ViewController: UIViewController, FBSDKLoginButtonDelegate {

	@IBOutlet var UsernameTF: UITextField!// Email
	@IBOutlet var PasswordTF: UITextField!// Password
	@IBOutlet weak var loginBtn: UIButton!// Normal login
	@IBOutlet weak var registerBtn: UIButton!// FB Login

	@IBOutlet weak var FBLoginButton: FBSDKLoginButton!

	var attrs = [
		NSFontAttributeName: UIFont.boldSystemFont(ofSize: 13.0),
		NSForegroundColorAttributeName: UIColor.white,
		NSUnderlineStyleAttributeName: 1

	] as [String : Any]

	var attributedString = NSMutableAttributedString(string: "")

//	let keyboardManager = KeyboardManager()

	override func viewDidLoad() {
		super.viewDidLoad()

//		keyboardManager.viewController = self

		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

		let imageView: UIView = UIView()
		imageView.frame = CGRect(x: 100, y: 20, width: 7, height: 26) // adds spacing on text  field
		UsernameTF.leftView = imageView
		UsernameTF.leftViewMode = UITextFieldViewMode.always

		let imageView2: UIView = UIView()
		imageView2.frame = CGRect(x: 20, y: 0, width: 7, height: 26) // adds spacing on text  field
		PasswordTF.leftView = imageView2
		PasswordTF.leftViewMode = UITextFieldViewMode.always

		self.FBLoginButton.delegate = self
		self.FBLoginButton.readPermissions = ["public_profile", "email", "user_friends"] // FBLogin button

		let buttonTitleStr = NSMutableAttributedString(string: "Sign Up!", attributes: attrs)
		attributedString.append(buttonTitleStr)
		registerBtn.setAttributedTitle(attributedString, for: UIControlState())

		self.hideKeyboardWhenTappedAround()

	}

	override func viewDidLayoutSubviews() {
		let border = CALayer()
		let width = CGFloat(1.0)
		border.borderWidth = width
		border.borderColor = UIColor.white.cgColor
		border.frame = CGRect(x: 0, y: UsernameTF.frame.size.height - width, width: UsernameTF.frame.size.width, height: UsernameTF.frame.size.height)
		UsernameTF.layer.addSublayer(border)
		UsernameTF.layer.masksToBounds = true
		UsernameTF.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: UIColor.white])
		UsernameTF.textColor = UIColor.white // these 2 blocks of code change textfield to format I want in design

		let Pborder = CALayer()
		Pborder.borderWidth = width
		Pborder.borderColor = UIColor.white.cgColor
		Pborder.frame = CGRect(x: 0, y: PasswordTF.frame.size.height - width, width: PasswordTF.frame.size.width, height: PasswordTF.frame.size.height)
		PasswordTF.layer.addSublayer(Pborder)
		PasswordTF.layer.masksToBounds = true
		PasswordTF.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.white])
		PasswordTF.textColor = UIColor.white
	}

	deinit {
		self.FBLoginButton?.delegate = nil
	}

	internal func loginButton(_ loginButton: FBSDKLoginButton!,
		didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {

			if (error != nil) {
				print(error.localizedDescription)
				return
			}

			let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
			FIRAuth.auth()?.signIn(with: credential, completion: { (user, autherror) in
                UserLogin.loginType = .facebook
				if user != nil {
					let homeView = self.storyboard?.instantiateViewController(withIdentifier: StoryboardNames.Main.rawValue)
					let appDelegate = UIApplication.shared.delegate as! AppDelegate
					appDelegate.window?.rootViewController = homeView
				}
			})
	}

	internal func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
		print("user is logged out")
	}

	@IBAction func LoginBtnAction(_ sender: AnyObject) {
		LogIn()
	}

	func LogIn() { // logs in normally without facebook login
		if let username = UsernameTF.text, let password = PasswordTF.text {
			UserLogin.logIn(username, password: password, view: self)
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}

