//
//  RegisterController.swift
//  SeakApp
//
//  Created by Kush Maheshwari on 5/29/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import UIKit
import Parse

class RegisterController: UIViewController {
    
    @IBOutlet var FirstNameTF: UITextField!
    @IBOutlet var LastNameTF: UITextField!
    @IBOutlet var EmailTF: UITextField!
    @IBOutlet var PasswordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView: UIView = UIView()
        imageView.frame = CGRectMake(20,0,7,26)
        FirstNameTF.leftView = imageView
        FirstNameTF.leftViewMode = UITextFieldViewMode.Always
        
        let imageView2: UIView = UIView()
        imageView2.frame = CGRectMake(20,0,7,26)
        LastNameTF.leftView = imageView2
        LastNameTF.leftViewMode = UITextFieldViewMode.Always
        
        let imageView3: UIView = UIView()
        imageView3.frame = CGRectMake(20,0,7,26)
        EmailTF.leftView = imageView3
        EmailTF.leftViewMode = UITextFieldViewMode.Always
        
        let imageView4: UIView = UIView()
        imageView4.frame = CGRectMake(20,0,7,26)
        PasswordTF.leftView = imageView4
        PasswordTF.leftViewMode = UITextFieldViewMode.Always
        
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderWidth = width
        border.borderColor = UIColor.whiteColor().CGColor
        border.frame = CGRect(x: 0, y: FirstNameTF.frame.size.height - width, width:  FirstNameTF.frame.size.width, height: FirstNameTF.frame.size.height)
        FirstNameTF.layer.addSublayer(border)
        FirstNameTF.layer.masksToBounds = true
        FirstNameTF.attributedPlaceholder = NSAttributedString(string:"First Name",attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        FirstNameTF.textColor = UIColor.whiteColor()
        
        let LNborder = CALayer()
        LNborder.borderWidth = width
        LNborder.borderColor = UIColor.whiteColor().CGColor
        LNborder.frame = CGRect(x: 0, y: LastNameTF.frame.size.height - width, width:  LastNameTF.frame.size.width, height: LastNameTF.frame.size.height)
        LastNameTF.layer.addSublayer(LNborder)
        LastNameTF.layer.masksToBounds = true
        LastNameTF.attributedPlaceholder = NSAttributedString(string:"Last Name",attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        LastNameTF.textColor = UIColor.whiteColor()
        
        let Eborder = CALayer()
        Eborder.borderWidth = width
        Eborder.borderColor = UIColor.whiteColor().CGColor
        Eborder.frame = CGRect(x: 0, y: EmailTF.frame.size.height - width, width:  EmailTF.frame.size.width, height: EmailTF.frame.size.height)
        EmailTF.layer.addSublayer(Eborder)
        EmailTF.layer.masksToBounds = true
        EmailTF.attributedPlaceholder = NSAttributedString(string:"Email",attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        EmailTF.textColor = UIColor.whiteColor()
        
        let Pborder = CALayer()
        Pborder.borderWidth = width
        Pborder.borderColor = UIColor.whiteColor().CGColor
        Pborder.frame = CGRect(x: 0, y: PasswordTF.frame.size.height - width, width:  PasswordTF.frame.size.width, height: PasswordTF.frame.size.height)
        PasswordTF.layer.addSublayer(Pborder)
        PasswordTF.layer.masksToBounds = true
        PasswordTF.attributedPlaceholder = NSAttributedString(string:"Password",attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        PasswordTF.textColor = UIColor.whiteColor()
    }
    
    
    @IBAction func RegisterBtnAction(sender: AnyObject) {
        SignUp()
    }
    
    func SignUp(){
        let user = PFUser()
        user.username=EmailTF.text
        user.email=EmailTF.text
        user.password=PasswordTF.text
        
        user["firstName"]=FirstNameTF.text
        user["lastName"]=LastNameTF.text
        
        
        
        
        
        user.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if error == nil {
                let Storyboard = UIStoryboard(name: "Main",bundle: nil)
                let MainVC : UIViewController = Storyboard.instantiateViewControllerWithIdentifier("Login")
                self.presentViewController(MainVC,animated: true, completion: nil)
            } else {
                
                print(error?.userInfo["error"]!)
                
            }
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

