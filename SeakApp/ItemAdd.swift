//
//  ItemViewController.swift
//  Seak
//
//  Created by Kush Maheshwari on 5/20/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import UIKit


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
    
    @IBAction func takePhotoAction(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func choosePhotoAction(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        ProductImage1.image = image
        ProductImage1.contentMode = UIViewContentMode.scaleAspectFit
        self.dismiss(animated: true, completion: nil);
    }
    
    
    
    @IBAction func submitBtnAction(_ sender: AnyObject) {
        
//        let user = PFUser.currentUser()
//        if(user == nil){
//            print("NILL")
//        }
//        let userID = PFUser.currentUser()?.objectId ?? ""
//        print(userID)
//        
//        if ProductImage1.image == nil {
//            let alert = UIAlertController(title: "Error", message: "Please attach at least one Image", preferredStyle: UIAlertControllerStyle.Alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//            self.presentViewController(alert, animated: true, completion: nil)
//        }else {
//            let user = PFUser.currentUser()
//            let userID = user!["objectId"]
//            let newItem = PFObject(className: "Item")
//            newItem["name"] = ProductName.text
//            newItem["sellerID"] = userID
//            newItem["category"] = Category.text
//            newItem["Description"] = ProductDescription.text
//            let imageData = UIImagePNGRepresentation(self.ProductImage1.image!)
//            let imageFile = PFFile(name:"item", data:imageData!)
//            newItem["picture"] = imageFile
//            newItem.saveInBackgroundWithBlock({
//                (success: Bool, error: NSError?) ->Void in
//                if error == nil {
//                    print("SUCCESS")
//                } else {
//                    print("ERROR")
//                }
//            })
//            
//        }
    }
}
