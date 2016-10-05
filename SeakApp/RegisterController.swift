//
//  RegisterController.swift
//  SeakApp
//
//  Created by Kush Maheshwari on 5/29/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import UIKit

class RegisterController: UIViewController { // here

	@IBOutlet var FirstNameTF: UITextField!
	@IBOutlet var LastNameTF: UITextField!
	@IBOutlet var EmailTF: UITextField!
	@IBOutlet var PasswordTF: UITextField!
	@IBOutlet weak var termsOfUseBtn: UIButton!
	@IBOutlet weak var ppBtn: UIButton!

	var attrs = [
		NSFontAttributeName: UIFont.systemFont(ofSize: 8.0),
		NSForegroundColorAttributeName: UIColor.white,
		NSUnderlineStyleAttributeName: 1

	] as [String : Any]

	var termsOfUseAttrString = NSMutableAttributedString(string: "")
	var ppAttrString = NSMutableAttributedString(string: "")

	override func viewDidLoad() { // again spacing and textfields
		super.viewDidLoad()

		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)

		let imageView: UIView = UIView()
		imageView.frame = CGRect(x: 20, y: 0, width: 7, height: 26)
		FirstNameTF.leftView = imageView
		FirstNameTF.leftViewMode = UITextFieldViewMode.always

		let imageView2: UIView = UIView()
		imageView2.frame = CGRect(x: 20, y: 0, width: 7, height: 26)
		LastNameTF.leftView = imageView2
		LastNameTF.leftViewMode = UITextFieldViewMode.always

		let imageView3: UIView = UIView()
		imageView3.frame = CGRect(x: 20, y: 0, width: 7, height: 26)
		EmailTF.leftView = imageView3
		EmailTF.leftViewMode = UITextFieldViewMode.always

		let imageView4: UIView = UIView()
		imageView4.frame = CGRect(x: 20, y: 0, width: 7, height: 26)
		PasswordTF.leftView = imageView4
		PasswordTF.leftViewMode = UITextFieldViewMode.always

		self.hideKeyboardWhenTappedAround()
		self.navigationController?.isNavigationBarHidden = false
		self.navigationController?.navigationBar.tintColor = UIColor.white
		self.navigationController?.navigationBar.shadowImage = UIImage()
		// Do any additional setup after loading the view.

		let termsOfUseTitleStr = NSMutableAttributedString(string: "TERMS OF USE", attributes: attrs)
		termsOfUseAttrString.append(termsOfUseTitleStr)
		termsOfUseBtn.setAttributedTitle(termsOfUseAttrString, for: UIControlState())

		let ppTitleString = NSMutableAttributedString(string: "PRIVACY POLICY", attributes: attrs)
		ppAttrString.append(ppTitleString)
		ppBtn.setAttributedTitle(ppTitleString, for: UIControlState())
	}

	override func viewDidLayoutSubviews() { // this code deals with all the newly formatted text fields
		super.viewDidLayoutSubviews()

		let border = CALayer()
		let width = CGFloat(1.0)
		border.borderWidth = width
		border.borderColor = UIColor.white.cgColor
		border.frame = CGRect(x: 0, y: FirstNameTF.frame.size.height - width, width: FirstNameTF.frame.size.width, height: FirstNameTF.frame.size.height)
		FirstNameTF.layer.addSublayer(border)
		FirstNameTF.layer.masksToBounds = true
		FirstNameTF.attributedPlaceholder = NSAttributedString(string: "First Name", attributes: [NSForegroundColorAttributeName: UIColor.white])
		FirstNameTF.textColor = UIColor.white

		let LNborder = CALayer()
		LNborder.borderWidth = width
		LNborder.borderColor = UIColor.white.cgColor
		LNborder.frame = CGRect(x: 0, y: LastNameTF.frame.size.height - width, width: LastNameTF.frame.size.width, height: LastNameTF.frame.size.height)
		LastNameTF.layer.addSublayer(LNborder)
		LastNameTF.layer.masksToBounds = true
		LastNameTF.attributedPlaceholder = NSAttributedString(string: "Last Name", attributes: [NSForegroundColorAttributeName: UIColor.white])
		LastNameTF.textColor = UIColor.white

		let Eborder = CALayer()
		Eborder.borderWidth = width
		Eborder.borderColor = UIColor.white.cgColor
		Eborder.frame = CGRect(x: 0, y: EmailTF.frame.size.height - width, width: EmailTF.frame.size.width, height: EmailTF.frame.size.height)
		EmailTF.layer.addSublayer(Eborder)
		EmailTF.layer.masksToBounds = true
		EmailTF.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: UIColor.white])
		EmailTF.textColor = UIColor.white

		let Pborder = CALayer()
		Pborder.borderWidth = width
		Pborder.borderColor = UIColor.white.cgColor
		Pborder.frame = CGRect(x: 0, y: PasswordTF.frame.size.height - width, width: PasswordTF.frame.size.width, height: PasswordTF.frame.size.height)
		PasswordTF.layer.addSublayer(Pborder)
		PasswordTF.layer.masksToBounds = true
		PasswordTF.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.white])
		PasswordTF.textColor = UIColor.white
	}

	@IBAction func RegisterBtnAction(_ sender: AnyObject) { // signs up user with Parse
		if let username = EmailTF.text, let password = PasswordTF.text,
			let firstname = FirstNameTF.text, let lastname = LastNameTF.text {
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

