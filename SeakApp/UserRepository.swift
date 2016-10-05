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

typealias UserRepositoryCompletionBlock = (_ user: UserInfoItem) -> Void

class UserRepository {

	private static let cache = NSCache<AnyObject, AnyObject>()

	static func processUser(userId: String?, userObject: [String: AnyObject]) -> UserInfoItem
	{
		let userInfoEntity = UserInfoItem()
		userInfoEntity.userId = userId
		userInfoEntity.username = userObject["username"] as? String
		userInfoEntity.picutre = userObject["picture"] as? String
		return userInfoEntity
	}

	func getById(userId: String?, completion: @escaping UserRepositoryCompletionBlock) {

		guard let uId = userId else { fatalError("User Id is empty") }

		if let obj = UserRepository.cache.object(forKey: userId! as AnyObject) as? UserInfoItem {
			completion(obj)
		}
		else {
			let userRef = FIRDatabase.database().reference().child("users").child(userId!)
			userRef.observeSingleEvent(of: .value, with: { (snapshot) in
				if !snapshot.exists() {
					return
				}

				if let snapvalue = snapshot.value as? [String: AnyObject]
				{
					let user = UserRepository.processUser(userId: uId, userObject: snapvalue)
                    UserRepository.cache.setObject(user, forKey: uId as AnyObject)
					completion(user)
				}
			})
		}
	}

	func saveUser(username: String?, userPic: String?, saveCallback: @escaping () -> Void) {

		let usersRef = FIRDatabase.database().reference().child("users")

		usersRef.observeSingleEvent(of: .value, with: { (snapshot) in
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
