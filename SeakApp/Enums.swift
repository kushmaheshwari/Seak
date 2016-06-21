//
//  Enums.swift
//  SeakApp
//
//  Created by Roman Volkov on 02/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation

enum ParseClassNames: String {
	case Item = "Item"
}

enum StoryboardNames: String {
	case MainStoryboard = "Main"
	case Login = "Login"
	case Navigation = "navigationID"
	case RecentSearches = "recentSearchesID"
	case Main = "StartPointView"
	case ItemsCollection = "itemsCollectionViewID"
	case StoreNavigation = "storeNavigationID"
}

enum MenuItems: String {
	case None = ""
	case Home = "Home"
	case Clothes = "Clothes"
	case Electronics = "Electronics"
	case Textbooks = "Textbooks"
	case Accessories = "Accessories"
	case Appliances = "Appliances"
	case Miscellaneous = "Miscellaneous"

	static let values = [Home, Clothes, Electronics,
		Textbooks, Accessories, Appliances, Miscellaneous]
}

enum ItemStatus: String {
	case Trending = "Trending"
	case Featured = "Featured"
	case Recent = "Recent"
	case Latest = "Latest"
}