//
//  RecentSearches.swift
//  SeakApp
//
//  Created by Roman Volkov on 10/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation

class RecentSearches {
	private static let prefs = NSUserDefaults.standardUserDefaults()
	private static let keyID = "recentSearches"
	private static let maxCount = 4

	static func getAll() -> [String] {
		if let items = prefs.arrayForKey(keyID) as? [String] {
			return items
		}

		return [String]()
	}

	static func add(value: String) {
		var items = getAll()
		items.insert(value, atIndex: 0)
		while items.count > maxCount {
			items.removeLast()
		}
		prefs.setValue(items, forKey: keyID)
	}
}