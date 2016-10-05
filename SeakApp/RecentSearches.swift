//
//  RecentSearches.swift
//  SeakApp
//
//  Created by Roman Volkov on 10/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation

class RecentSearches {
	fileprivate static let prefs = UserDefaults.standard
	fileprivate static let keyID = "recentSearches"
	fileprivate static let maxCount = 4

	static func getAll() -> [String] {
		if let items = prefs.array(forKey: keyID) as? [String] {
			return items
		}

		return [String]()
	}

	static func add(_ value: String) {
		var items = getAll()
		items.insert(value, at: 0)
		while items.count > maxCount {
			items.removeLast()
		}
		prefs.setValue(items, forKey: keyID)
	}
}
