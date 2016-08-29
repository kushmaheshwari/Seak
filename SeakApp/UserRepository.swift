//
//  UserRepository.swift
//  SeakApp
//
//  Created by Екатерина Волкова on 29/08/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import Firebase

//method parse
//method by user id
// save user

class UserRepository {
    
    static func processUser(userId: String?, userObject: [String: AnyObject]) -> UserInfoItem
    {
        let userInfoEntity = UserInfoItem()
        userInfoEntity.userId = userId
        
        if let userEmail = userObject["userEmail"] as? String {
            userInfoEntity.userEmail = userEmail
        }
        
        if let userPic = userObject["picutre"] as? String {
            userInfoEntity.picutre = userPic
        }
        
        return userInfoEntity
    }
}
