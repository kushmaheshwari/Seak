//
//  UserDataCache.swift
//  SeakApp
//
//  Created by Roman Volkov on 22/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import MapKit

class UserDataCache {
	private static let userDefaults = NSUserDefaults.standardUserDefaults()

	static func clearCache() {
		saveUserPicture(nil)
		saveUserName(nil)
        saveUserRadius(nil)
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
    
    static func saveUserRadius(radius: Int?) {
        userDefaults.setValue(radius, forKey: UserDataCacheProperties.UserRadius.rawValue)
    }
    
    static func getUserRadius() -> Int? {
        if let userRadius = userDefaults.objectForKey(UserDataCacheProperties.UserRadius.rawValue) as? Int {
            return userRadius
        }
        
        return nil
    }

    static func saveUserLocationLong(long: Double?) {
        userDefaults.setValue(long, forKey: UserDataCacheProperties.UserLocationLong.rawValue)
    }
    
    static func getUserLocationLong() -> Double? {
        if let userLocationLong = userDefaults.objectForKey(UserDataCacheProperties.UserLocationLong.rawValue) as? Double {
            return userLocationLong
        }
        
        return nil
    }
    
    static func saveUserLocationLatt(latt: Double?) {
        userDefaults.setValue(latt, forKey: UserDataCacheProperties.UserLocationLatt.rawValue)
    }
    
    static func getUserLocationLatt() -> Double? {
        if let userLocationLatt = userDefaults.objectForKey(UserDataCacheProperties.UserLocationLatt.rawValue) as? Double {
            return userLocationLatt
        }
        
        return nil
    }
    
    static func getUserLocation() -> CLLocationCoordinate2D? {
        let userLocationLatt = self.getUserLocationLatt() as Double?
        let userLocationLong = self.getUserLocationLong() as Double?
        
        if (userLocationLatt != nil) && (userLocationLong != nil)
            {
                let coordinates = CLLocationCoordinate2D(latitude: userLocationLatt!, longitude: userLocationLong!)
                return coordinates
            }
        
        return nil
    }
    
}