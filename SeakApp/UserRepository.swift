//
//  UserRepository.swift
//  SeakApp
//
//  Created by Екатерина Волкова on 29/08/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

// save user

typealias UserRepositoryCompletionBlock = (user: UserInfoItem) -> Void

class UserRepository {

	private static let cache = NSCache()

	static func processUser(userId: String?, userObject: [String: AnyObject]) -> UserInfoItem
	{
		let userInfoEntity = UserInfoItem()
		userInfoEntity.userId = userId
		userInfoEntity.username = userObject["username"] as? String
		userInfoEntity.picutre = userObject["picture"] as? String
		return userInfoEntity
	}

	func getById(userId: String?, completion: UserRepositoryCompletionBlock) {

		guard let uId = userId else { fatalError("User Id is empty") }

		if let obj = UserRepository.cache.objectForKey(userId!) as? UserInfoItem {
			completion(user: obj)
		}
		else {
			let userRef = FIRDatabase.database().reference().child("users").child(userId!)
			userRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
				if !snapshot.exists() {
					return
				}

				if let snapvalue = snapshot.value as? [String: AnyObject]
				{
					let user = UserRepository.processUser(uId, userObject: snapvalue)
                    UserRepository.cache.setObject(user, forKey: uId)
					completion(user: user)
				}
			})
		}
	}

	func saveUser(username: String?, userPic: String?, saveCallback: () -> Void) {

		let usersRef = FIRDatabase.database().reference().child("users")

		usersRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
			if !snapshot.exists() {
				return
			}

			if (snapshot.value as? [String: AnyObject]) != nil
			{
				guard let userId = FIRAuth.auth()?.currentUser?.uid else { return }
				let key = usersRef.child(userId)
				let newUser = ["picture": userPic ?? "",
					"username": username ?? ""]
				key.setValue(newUser)
				saveCallback()
			}
		})
	}
}
