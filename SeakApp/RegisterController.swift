//
//  RegisterController.swift
//  SeakApp
//
//  Created by Kush Maheshwari on 5/29/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import UIKit
import Parse

class RegisterController: UIViewController { // here

	@IBOutlet var FirstNameTF: UITextField!
	@IBOutlet var LastNameTF: UITextField!
	@IBOutlet var EmailTF: UITextField!
	@IBOutlet var PasswordTF: UITextField!
	@IBOutlet weak var termsOfUseBtn: UIButton!
	@IBOutlet weak var ppBtn: UIButton!

	var attrs = [
		NSFontAttributeName: UIFont.systemFontOfSize(8.0),
		NSForegroundColorAttributeName: UIColor.whiteColor(),
		NSUnderlineStyleAttributeName: 1

	]

	var termsOfUseAttrString = NSMutableAttributedString(string: "")
	var ppAttrString = NSMutableAttributedString(string: "")

	override func viewDidLoad() { // again spacing and textfields
		super.viewDidLoad()

		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)

		let imageView: UIView = UIView()
		imageView.frame = CGRectMake(20, 0, 7, 26)
		FirstNameTF.leftView = imageView
		FirstNameTF.leftViewMode = UITextFieldViewMode.Always

		let imageView2: UIView = UIView()
		imageView2.frame = CGRectMake(20, 0, 7, 26)
		LastNameTF.leftView = imageView2
		LastNameTF.leftViewMode = UITextFieldViewMode.Always

		let imageView3: UIView = UIView()
		imageView3.frame = CGRectMake(20, 0, 7, 26)
		EmailTF.leftView = imageView3
		EmailTF.leftViewMode = UITextFieldViewMode.Always

		let imageView4: UIView = UIView()
		imageView4.frame = CGRectMake(20, 0, 7, 26)
		PasswordTF.leftView = imageView4
		PasswordTF.leftViewMode = UITextFieldViewMode.Always

		self.hideKeyboardWhenTappedAround()
		self.navigationController?.navigationBarHidden = false
		self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
		self.navigationController?.navigationBar.shadowImage = UIImage()
		// Do any additional setup after loading the view.

		let termsOfUseTitleStr = NSMutableAttributedString(string: "TERMS OF USE", attributes: attrs)
		termsOfUseAttrString.appendAttributedString(termsOfUseTitleStr)
		termsOfUseBtn.setAttributedTitle(termsOfUseAttrString, forState: .Normal)

		let ppTitleString = NSMutableAttributedString(string: "PRIVACY POLICY", attributes: attrs)
		ppAttrString.appendAttributedString(ppTitleString)
		ppBtn.setAttributedTitle(ppTitleString, forState: .Normal)
	}

	override func viewDidLayoutSubviews() { // this code deals with all the newly formatted text fields
		super.viewDidLayoutSubviews()

		let border = CALayer()
		let width = CGFloat(1.0)
		border.borderWidth = width
		border.borderColor = UIColor.whiteColor().CGColor
		border.frame = CGRect(x: 0, y: FirstNameTF.frame.size.height - width, width: FirstNameTF.frame.size.width, height: FirstNameTF.frame.size.height)
		FirstNameTF.layer.addSublayer(border)
		FirstNameTF.layer.masksToBounds = true
		FirstNameTF.attributedPlaceholder = NSAttributedString(string: "First Name", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
		FirstNameTF.textColor = UIColor.whiteColor()

		let LNborder = CALayer()
		LNborder.borderWidth = width
		LNborder.borderColor = UIColor.whiteColor().CGColor
		LNborder.frame = CGRect(x: 0, y: LastNameTF.frame.size.height - width, width: LastNameTF.frame.size.width, height: LastNameTF.frame.size.height)
		LastNameTF.layer.addSublayer(LNborder)
		LastNameTF.layer.masksToBounds = true
		LastNameTF.attributedPlaceholder = NSAttributedString(string: "Last Name", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
		LastNameTF.textColor = UIColor.whiteColor()

		let Eborder = CALayer()
		Eborder.borderWidth = width
		Eborder.borderColor = UIColor.whiteColor().CGColor
		Eborder.frame = CGRect(x: 0, y: EmailTF.frame.size.height - width, width: EmailTF.frame.size.width, height: EmailTF.frame.size.height)
		EmailTF.layer.addSublayer(Eborder)
		EmailTF.layer.masksToBounds = true
		EmailTF.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
		EmailTF.textColor = UIColor.whiteColor()

		let Pborder = CALayer()
		Pborder.borderWidth = width
		Pborder.borderColor = UIColor.whiteColor().CGColor
		Pborder.frame = CGRect(x: 0, y: PasswordTF.frame.size.height - width, width: PasswordTF.frame.size.width, height: PasswordTF.frame.size.height)
		PasswordTF.layer.addSublayer(Pborder)
		PasswordTF.layer.masksToBounds = true
		PasswordTF.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
		PasswordTF.textColor = UIColor.whiteColor()
	}

	@IBAction func RegisterBtnAction(sender: AnyObject) { // signs up user with Parse
		if let username = EmailTF.text, password = PasswordTF.text,
			firstname = FirstNameTF.text, lastname = LastNameTF.text {
				UserLogin.signUp(username, email: username, password: password, firstname: firstname, lastname: lastname, view: self)
		}

	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	/*
	 // MARK: - Navigation

	 // In a storyboard-based application, you will often want to do a little preparation before navigation
	 override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
	 // Get the new view controller using segue.destinationViewController.
	 // Pass the selected object to the new view controller.
	 }
	 */

}

