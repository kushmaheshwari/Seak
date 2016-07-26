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
	case StoresCollection = "storesCollectionViewID"
	case StoreNavigation = "storeNavigationID"
	case Store = "storeID"
	case HomeItemsView = "homeItemsViewID"
	case ItemDetailsView = "itemDetailsView"
	case FavNavigation = "favNavigationId"
	case MainPageView = "mainPageViewID"
	case SearchViewController = "SearchViewId"
	case StoreDetails = "storeDetailsViewID"
}

enum StoreCategory: String {
	case None = ""
	case Home = "Home"

	case Accessories = "Accessories"
	case BoardGames = "Board Games"
	case Cards = "Cards"
	case Cases = "Cases"
	case CDs = "CDs"
	case Chargers = "Chargers"
	case Digital = "Digital"
	case Dresses = "Dresses"
	case Drones = "Drones"
	case Games = "Games"
	case Hair = "Hair"
	case Jackets = "Jackets"
	case Magic = "Magic"
	case Makeup = "Makeup"
	case Music = "Music"
	case Nails = "Nails"
	case OuterWear = "OuterWear"
	case Pants = "Pants"
	case Phones = "Phones"
	case Premium = "Premium"
	case Records = "Records"
	case Repairs = "Repairs"
	case Shirts = "Shirts"
	case Shoes = "Shoes"
	case Skincare = "Skincare"
	case Tablets = "Tablets"
	case Tops = "Tops"
	case Textbooks = "Textbooks"
	case Electronics = "Electronics"
	case Clothes = "Clothes"
	case Appliances = "Appliances"
	case Miscellaneous = "Miscellaneous"

	static let startValues = [Home, Clothes, Electronics,
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

enum StoreCollectionViewSource {
	case None
	case All
	case Favorites
}