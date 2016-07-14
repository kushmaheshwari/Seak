//
//  FavoriteRepository.swift
//  SeakApp
//
//  Created by Roman Volkov on 14/07/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import Parse

class FavoriteRepository {

	static func processFavoriteStore(object: PFObject) -> FavoriteStore {
		let result = FavoriteStore()
		result.objectID = object.objectId
		result.user = object["user"] as? PFUser
		result.createdAt = object.createdAt
		result.store = object["store"] as? PFObject
		if let store = result.store {
            do {
                try store.fetch() }
            catch {
                fatalError("can't fetch favorite store")
            }
			result.storeEntity = StoreRepository.processStore(store)
		}
		return result
	}

	static func processFavoriteStores(objects: [PFObject]) -> [FavoriteStore]? {
		return objects.map({ (object) -> FavoriteStore in
			return FavoriteRepository.processFavoriteStore(object)
		})
	}

	static func processFavoriteItem(object: PFObject) -> FavoriteItem {
		let result = FavoriteItem()
		result.objectID = object.objectId
		result.user = object["user"] as? PFUser
		result.createdAt = object.createdAt
		result.item = object["item"] as? PFObject
		if let item = result.item {
            do {
                try item.fetch() }
            catch {
                fatalError("can't fetch favorite item")
            }
			result.itemEntity = ItemRepository.processItem(item)
		}
		return result
	}

	static func processFavoriteItems(objects: [PFObject]) -> [FavoriteItem]? {
		return objects.map({ (object) -> FavoriteItem in
			return FavoriteRepository.processFavoriteItem(object)
		})
	}

	func getAllStores(by user: PFUser, completion: StoresRepositoryComplectionBlock) {
		guard let _ = user.objectId else { fatalError ("user without objectId") }
		let query = PFQuery(className: ParseClassNames.FavoriteStores.rawValue)
		query.whereKey("user", equalTo: user)
		query.cachePolicy = .CacheThenNetwork

		query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
			if error != nil {
				print("Error: \(error!) \(error!.userInfo)")
			} else {
				if let items = FavoriteRepository.processFavoriteStores(objects!) {
					completion(items: items.map({ (favoriteStore) -> StoreEntity in
						return favoriteStore.storeEntity!
						}))
				}
			}
		}
	}

	func getAllItems(by user: PFUser, completion: ItemRepositoryComplectionBlock) {
		guard let _ = user.objectId else { fatalError ("user without objectId") }
		let query = PFQuery(className: ParseClassNames.FavoriteItems.rawValue)
		query.whereKey("user", equalTo: user)
		query.cachePolicy = .CacheThenNetwork

		query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
			if error != nil {
				print("Error: \(error!) \(error!.userInfo)")
			} else {
				if let items = FavoriteRepository.processFavoriteItems(objects!) {
					completion(items: items.map({ (favoriteItem) -> ItemEntity in
						return favoriteItem.itemEntity!
						}))
				}
			}
		}

	}

}