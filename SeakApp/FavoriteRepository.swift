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
		//result.objectID = object.objectId
		result.user = object["user"] as? PFUser
		//result.createdAt = object.createdAt
		result.store = object["store"] as? PFObject
		if let store = result.store {
			do {
				try store.fetch() }
			catch {
				fatalError("can't fetch favorite store")
			}
            /// TODO replace it
//			result.storeEntity = StoreRepository.processStore(store.objectId, storeObject: store)
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
			//result.itemEntity = ItemRepository.processItem(item.objectId, object: item) TO-DO: make migration to Firebase
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

	// Items
	func getLike(by item: ItemEntity, completion: (item: FavoriteItem?) -> Void) {
		let query = PFQuery(className: ParseClassNames.FavoriteItems.rawValue)
        if let currentUser = PFUser.currentUser() {
            query.whereKey("user", equalTo: currentUser)
        }
		query.whereKey("item", equalTo: PFObject(outDataWithClassName: ParseClassNames.Item.rawValue, objectId: item.objectID!))
		query.cachePolicy = .IgnoreCache

		query.findObjectsInBackgroundWithBlock { (objects, error) in
			if objects?.count > 0 {
				if let object = objects?.first {
					let item = FavoriteRepository.processFavoriteItem(object)
					completion(item: item)
				}
			} else {
				completion(item: nil)
			}
		}
	}

	func dislike(item: FavoriteItem, successBlock: (success: Bool) -> Void) {
		guard let _ = item.objectID else { fatalError("empty objectId for FavoriteItem") }
		let parseObject = PFObject(outDataWithClassName: ParseClassNames.FavoriteItems.rawValue, objectId: item.objectID!)
		parseObject.deleteInBackgroundWithBlock { (flag, error) in
			if (error != nil) {
				print(error)

			}
			successBlock(success: flag)
		}
	}

	func like(item: ItemEntity, completion: (favoriteItem: FavoriteItem) -> Void) {
		let object = PFObject(className: ParseClassNames.FavoriteItems.rawValue)
		object["user"] = PFUser.currentUser()
		if let itemObjectId = item.objectID {
			object["item"] = PFObject(outDataWithClassName: ParseClassNames.Item.rawValue, objectId: itemObjectId)
		}

		object.saveInBackgroundWithBlock { (success, error) in
			if success {
				object.fetchInBackgroundWithBlock({ (obj, error) in
					if error != nil {
						print(error)
					}
					else {
						let favoriteItem = FavoriteRepository.processFavoriteItem(obj!)
						completion(favoriteItem: favoriteItem)
					}
				})

			}
			else {
				fatalError("Error on saving favorite item \(error)")
			}
		}
	}

	// Store
	func getStatus(by store: StoreEntity, completion: (store: FavoriteStore?) -> Void) {
		let query = PFQuery(className: ParseClassNames.FavoriteStores.rawValue)
        if let currentuser = PFUser.currentUser() {
            query.whereKey("user", equalTo: currentuser)
        }
		query.whereKey("store", equalTo: PFObject(outDataWithClassName: ParseClassNames.Store.rawValue, objectId: store.objectID!))
		query.cachePolicy = .IgnoreCache

		query.findObjectsInBackgroundWithBlock { (objects, error) in
			if objects?.count > 0 {
				if let object = objects?.first {
					let item = FavoriteRepository.processFavoriteStore(object)
					completion(store: item)
				}
			} else {
				completion(store: nil)
			}
		}
	}

	func remove(store: FavoriteStore, successBlock: (success: Bool) -> Void) {
		guard let _ = store.objectID else { fatalError("empty objectId for FavoriteStore") }
		let parseObject = PFObject(outDataWithClassName: ParseClassNames.FavoriteStores.rawValue, objectId: store.objectID!)
		parseObject.deleteInBackgroundWithBlock { (flag, error) in
			if (error != nil) {
				print(error)

			}
			successBlock(success: flag)
		}
	}

	func add(store: StoreEntity, completion: (favoriteStore: FavoriteStore) -> Void) {
		let object = PFObject(className: ParseClassNames.FavoriteStores.rawValue)
		object["user"] = PFUser.currentUser()
		if let itemObjectId = store.objectID {
			object["store"] = PFObject(outDataWithClassName: ParseClassNames.Store.rawValue, objectId: itemObjectId)
		}

		object.saveInBackgroundWithBlock { (success, error) in
			if success {
				object.fetchInBackgroundWithBlock({ (obj, error) in
					if error != nil {
						print(error)
					}
					else {
						let favoriteStore = FavoriteRepository.processFavoriteStore(obj!)
						completion(favoriteStore: favoriteStore)
					}
				})

			}
			else {
				fatalError("Error on saving favorite store \(error)")
			}
		}
	}
}