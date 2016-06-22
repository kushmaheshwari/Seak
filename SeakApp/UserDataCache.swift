//
//  UserDataCache.swift
//  SeakApp
//
//  Created by Roman Volkov on 22/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation

class UserDataCache {
	private static let userDefaults = NSUserDefaults.standardUserDefaults()

	static func clearCache() {
		saveUserPicture(nil)
		saveUserName(nil)
	}

	static func saveUserPicture(data: NSData?) {
		userDefaults.setValue(data, forKeyPath: UserDataCacheProperties.UserPicture.rawValue)
	}

	static func getUserPicture() -> NSData? {
		if let data = userDefaults.objectForKey(UserDataCacheProperties.UserPicture.rawValue) as? NSData {
			return data
		}

		return nil
	}

	static func saveUserName(userName: String?) {
		userDefaults.setValue(userName, forKeyPath: UserDataCacheProperties.UserName.rawValue)
	}

	static func getUserName() -> String? {
		if let userName = userDefaults.objectForKey(UserDataCacheProperties.UserName.rawValue) as? String {
			return userName
		}

		return nil
	}

}