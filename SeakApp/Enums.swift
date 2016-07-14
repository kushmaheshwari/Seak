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
	case Store = "Store"
	case Review = "Reviews"
	case FavoriteItems = "FavoriteItems"
	case FavoriteStores = "FavoriteStores"
	case User = "User"
}

enum StoryboardNames: String {
	case MainStoryboard = "Main"
	case HomeItemsViewStoryboard = "HomeItemsView"
	case Login = "Login"
	case Navigation = "navigationID"
	case RecentSearches = "recentSearchesID"
	case Main = "StartPointView"
	case ItemsCollection = "itemsCollectionViewID"
	case StoreNavigation = "storeNavigationID"
	case HomeItemsView = "homeItemsViewID"
	case ItemDetailsView = "itemDetailsView"
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
	case None = ""
	case Trending = "Trending"
	case Featured = "Featured"
	case Recent = "Recent"
	case Latest = "Latest"

	static let values = [Featured, Latest, Trending, Recent]
	static let StatusGroupNames = [Trending: "Trending", Featured: "Featured Items", Recent: "Recent Items", Latest: "Latest Deals"]
}

enum UserLoginType {
	case None
	case Parse
	case Facebook
}

enum UserDataCacheProperties: String {
	case UserPicture = "userpicture"
	case UserName = "username"
}

enum ItemsCollectionViewDataSource {
	case None
	case Categories
	case Favorites
}