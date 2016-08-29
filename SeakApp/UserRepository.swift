//
//  UserRepository.swift
//  SeakApp
//
//  Created by Екатерина Волкова on 29/08/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import Firebase

// save user

typealias UserRepositoryCompletionBlock = (item: UserInfoItem) -> Void

class UserRepository {
    
    static func processUser(userId: String?, userObject: [String: AnyObject]) -> UserInfoItem
    {
        let userInfoEntity = UserInfoItem()
        userInfoEntity.userId = userId
        
        if let userEmail = userObject["userEmail"] as? String {
            userInfoEntity.userEmail = userEmail
        }
        
        if let userPic = userObject["picture"] as? String {
            userInfoEntity.picutre = userPic
        }
        
        return userInfoEntity
    }
    
    func getById(userId: String?, completion: UserRepositoryCompletionBlock) {
        
        guard let uId = userId else { fatalError("User Id is empty") }
        
        let userRef = FIRDatabase.database().reference().child("users").child(userId!)
        userRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if !snapshot.exists() {
                return
            }
            
            if let snapvalue = snapshot.value as? [String: AnyObject]
            {
                let item = UserRepository.processUser(uId, userObject: snapvalue)
                completion(item: item)
            }
        })
    }
    
    func saveUser(userEmail: String?, userPic: String?, saveCallback: () -> Void) {
        
        let usersRef = FIRDatabase.database().reference().child("users")
        
        usersRef.observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            if !snapshot.exists() {
                return
            }
            
            if (snapshot.value as? [String: AnyObject]) != nil
            {
                var key: FIRDatabaseReference
                
                key = usersRef.childByAutoId()
                let newUser = ["picture": userPic ?? "",
                               "userEmail": userEmail ?? ""]
                key.setValue(newUser)
                
                //TODO recalculate average raiting at Item
                
                saveCallback()
            }
        })
    }
}
