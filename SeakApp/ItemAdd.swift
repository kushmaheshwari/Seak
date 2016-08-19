//
//  ItemViewController.swift
//  Seak
//
//  Created by Kush Maheshwari on 5/20/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import UIKit
import Parse

class ItemAdd: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var ProductImage1: UIImageView!
    @IBOutlet weak var ProductName: UITextField!
    @IBOutlet weak var ProductDescription: UITextView!
    @IBOutlet weak var Price: UITextField!
    @IBOutlet weak var Category: UITextField!
    @IBOutlet weak var SubmitBtn: UIButton!
    @IBOutlet weak var TakePhoto: UIButton!
    @IBOutlet weak var ChoosePhoto: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func takePhotoAction(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func choosePhotoAction(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        ProductImage1.image = image
        ProductImage1.contentMode = UIViewContentMode.ScaleAspectFit
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    
    
    @IBAction func submitBtnAction(sender: AnyObject) {
        
        let user = PFUser.currentUser()
        if(user == nil){
            print("NILL")
        }
        let userID = PFUser.currentUser()?.objectId ?? ""
        print(userID)
        
        if ProductImage1.image == nil {
            let alert = UIAlertController(title: "Error", message: "Please attach at least one Image", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }else {
            let user = PFUser.currentUser()
            let userID = user!["objectId"]
            let newItem = PFObject(className: "Item")
            newItem["name"] = ProductName.text
            newItem["sellerID"] = userID
            newItem["category"] = Category.text
            newItem["Description"] = ProductDescription.text
            let imageData = UIImagePNGRepresentation(self.ProductImage1.image!)
            let imageFile = PFFile(name:"item", data:imageData!)
            newItem["picture"] = imageFile
            newItem.saveInBackgroundWithBlock({
                (success: Bool, error: NSError?) ->Void in
                if error == nil {
                    print("SUCCESS")
                } else {
                    print("ERROR")
                }
            })
            
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
