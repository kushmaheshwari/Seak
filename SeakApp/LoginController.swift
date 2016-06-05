//
//  LoginController.swift
//  SeakApp
//
//  Created by Kush Maheshwari on 5/29/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import UIKit
import Parse
import FBSDKLoginKit
import FBSDKCoreKit
import ParseFacebookUtilsV4
import QuartzCore

class ViewController: UIViewController, FBSDKLoginButtonDelegate {

	@IBOutlet var UsernameTF: UITextField!// Email
	@IBOutlet var PasswordTF: UITextField!// Password
	@IBOutlet weak var loginBtn: UIButton!// Normal login
	@IBOutlet weak var registerBtn: UIButton!// FB Login

	@IBOutlet weak var FBLoginButton: FBSDKLoginButton!

    var attrs = [
        NSFontAttributeName : UIFont.boldSystemFontOfSize(13.0),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSUnderlineStyleAttributeName : 1
        
    ]
    
    var attributedString = NSMutableAttributedString(string:"")
    
	override func viewDidLoad() {
		super.viewDidLoad()
		let imageView: UIView = UIView()
		imageView.frame = CGRectMake(100, 20, 7, 26) // adds spacing on text  field
		UsernameTF.leftView = imageView
		UsernameTF.leftViewMode = UITextFieldViewMode.Always

		let imageView2: UIView = UIView()
		imageView2.frame = CGRectMake(20, 0, 7, 26) // adds spacing on text  field
		PasswordTF.leftView = imageView2
		PasswordTF.leftViewMode = UITextFieldViewMode.Always

		loginBtn.titleLabel!.font = UIFont(name: "Roboto-Medium", size: 14) // changing font of button

		FBLoginButton.delegate = self
		FBLoginButton.readPermissions = ["public_profile", "email", "user_friends"] // FBLogin button
        
        let buttonTitleStr = NSMutableAttributedString(string:"Sign Up!", attributes:attrs)
        attributedString.appendAttributedString(buttonTitleStr)
        registerBtn.setAttributedTitle(attributedString, forState: .Normal)
            
		self.hideKeyboardWhenTappedAround()
	}

	override func viewDidLayoutSubviews() {
		let border = CALayer()
		let width = CGFloat(1.0)
		border.borderWidth = width
		border.borderColor = UIColor.whiteColor().CGColor
		border.frame = CGRect(x: 0, y: UsernameTF.frame.size.height - width, width: UsernameTF.frame.size.width, height: UsernameTF.frame.size.height)
		UsernameTF.layer.addSublayer(border)
		UsernameTF.layer.masksToBounds = true
		UsernameTF.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
		UsernameTF.textColor = UIColor.whiteColor() // these 2 blocks of code change textfield to format I want in design

		let Pborder = CALayer()
		Pborder.borderWidth = width
		Pborder.borderColor = UIColor.whiteColor().CGColor
		Pborder.frame = CGRect(x: 0, y: PasswordTF.frame.size.height - width, width: PasswordTF.frame.size.width, height: PasswordTF.frame.size.height)
		PasswordTF.layer.addSublayer(Pborder)
		PasswordTF.layer.masksToBounds = true
		PasswordTF.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
		PasswordTF.textColor = UIColor.whiteColor()
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.navigationBarHidden = true

		if (FBSDKAccessToken.currentAccessToken() != nil || PFUser.currentUser() != nil) { // this code is for if user is already signed in and can bypass this screen
			if (FBSDKAccessToken.currentAccessToken() != nil) {
				let accessToken: FBSDKAccessToken = FBSDKAccessToken.currentAccessToken()

				PFFacebookUtils.logInInBackgroundWithAccessToken(accessToken,
					block: { (user: PFUser?, error: NSError?) -> Void in
						if user != nil {
							print("User logged in through Facebook!")
						} else {
							print("Uh oh. There was an error logging in.")
						}
				})
			}

			let homeview = self.storyboard?.instantiateViewControllerWithIdentifier("HomeView")
			let homeViewNav = UINavigationController (rootViewController: homeview!)
			let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
			appDelegate.window?.rootViewController = homeViewNav

		}
	}

	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		FBLoginButton.delegate = nil
	}

	internal func loginButton(loginButton: FBSDKLoginButton!,
		didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
			print("Here1")
			if (error != nil) {
				print(error.localizedDescription)
				return
			}

			if result.token != nil {
				let homeview = self.storyboard?.instantiateViewControllerWithIdentifier("HomeView")
				let homeViewNav = UINavigationController (rootViewController: homeview!)
				let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
				appDelegate.window?.rootViewController = homeViewNav
			}
	}

	internal func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
		print("user is logged out")
	}

	@IBAction func LoginBtnAction(sender: AnyObject) {
		LogIn()
	}

	func LogIn() { // logs in normally without facebook login
		let user = PFUser()
		user.username = UsernameTF.text
		user.password = PasswordTF.text

		PFUser.logInWithUsernameInBackground(UsernameTF.text!, password: PasswordTF.text!, block: {
			(User: PFUser?, Error: NSError?) -> Void in

			if Error == nil {
				dispatch_async(dispatch_get_main_queue()) {
					// chnage intent: youtube.com/watch?v=XIJLIywoSoA

					let Storyboard = UIStoryboard(name: "Main", bundle: nil)
					let MainVC: UIViewController = Storyboard.instantiateViewControllerWithIdentifier("navigation")
					self.presentViewController(MainVC, animated: true, completion: nil)

				}
			} else {
				// problem
			}

		})

	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}

extension UIViewController {
	func hideKeyboardWhenTappedAround() {
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
		view.addGestureRecognizer(tap)
	}

	func dismissKeyboard() {
		view.endEditing(true)
	}
}

