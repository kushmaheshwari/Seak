//
//  ItemRepository.swift
//  SeakApp
//
//  Created by Roman Volkov on 02/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import Parse

typealias ItemRepositoryComplectionBlock = (items: [ItemEntity]) -> Void

class ItemRepository {

	let maxSearchCount = 30
	let maxCountByStatus = 10
	let cacheAge: NSTimeInterval = 60 * 60 // 1 hour

	static func processItem(object: PFObject) -> ItemEntity {
		let item = ItemEntity()
		if let name = object["name"] {
			item.name = name as? String
		}
		if let category = object.objectForKey("category") {
			item.category = category as? String
		}
		item.objectID = object.objectId!
		if let price = object.objectForKey("price") {
			item.price = price.doubleValue
		}
		if let picture = object.objectForKey("picture") {
			item.picture = picture as? PFFile

		}
		if let store = object.objectForKey("Store") {
			item.store = store as? PFObject
		}
		if let description = object.objectForKey("Description") {
			item.descr = description as? String
		}

		return item
	}

	static func processItems(data: [PFObject]?) -> [ItemEntity]? {
		if let data = data as [PFObject]! {
			let result = Array(data.generate()).map() { (iter) -> ItemEntity in
				return ItemRepository.processItem(iter)
			}
			return result
		}
		fatalError("Error on parsing Items from Parse objects")
	}

	func getAll(completion: ItemRepositoryComplectionBlock) {
		let query = PFQuery(className: ParseClassNames.Item.rawValue)
		query.cachePolicy = .CacheThenNetwork
		query.maxCacheAge = cacheAge
		query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
			if error != nil {
				print("Error: \(error!) \(error!.userInfo)")
			} else {
				if let items = ItemRepository.processItems(objects) {
					completion(items: items)
				}
			}
		}
	}

	func getByStatus(status: ItemStatus, store: StoreEntity?, completion: ItemRepositoryComplectionBlock) {
		if status == .None {
			return
		}

		let query = PFQuery(className: ParseClassNames.Item.rawValue)
			.whereKey("Status", containsString: status.rawValue)
		if store != nil {
			let storeObject = PFObject(outDataWithClassName: ParseClassNames.Store.rawValue, objectId: store!.objectID)
			query.whereKey("Store", equalTo: storeObject)
		}
		query.cachePolicy = (store != nil) ? .NetworkOnly : .CacheThenNetwork
		query.maxCacheAge = cacheAge
		query.limit = maxCountByStatus

		query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
			if error != nil {
				print("Error: \(error!) \(error!.userInfo)")
			} else {
				if let items = ItemRepository.processItems(objects) {
					completion(items: items)
				}
			}
		}
	}

	func getAllFromCategory(type: StoreCategory, store: StoreEntity?, completion: ItemRepositoryComplectionBlock) {
		if type == .None {
			return
		}

		let query = PFQuery(className: ParseClassNames.Item.rawValue)
			.whereKey("category", containsString: type.rawValue)
		if store != nil {
			let storeObject = PFObject(outDataWithClassName: ParseClassNames.Store.rawValue, objectId: store!.objectID)
			query.whereKey("Store", equalTo: storeObject)
		}
		query.cachePolicy = (store != nil) ? .NetworkOnly : .CacheThenNetwork
		query.maxCacheAge = cacheAge

		query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
			if error != nil {
				print("Error: \(error!) \(error!.userInfo)")
			} else {
				if let items = ItemRepository.processItems(objects) {
					completion(items: items)
				}
			}
		}
	}

	func search(value: String, completion: ItemRepositoryComplectionBlock) {
		let nameQuery = PFQuery(className: ParseClassNames.Item.rawValue)
		nameQuery.whereKey("name", containsString: value)
		let descriptionQuery = PFQuery(className: ParseClassNames.Item.rawValue)
		descriptionQuery.whereKey("description", containsString: value)
		let query = PFQuery.orQueryWithSubqueries([nameQuery, descriptionQuery])
		query.limit = maxSearchCount

		query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
			if error != nil {
				print("Error: \(error!) \(error!.userInfo)")
			} else {
				if let items = ItemRepository.processItems(objects) {
					completion(items: items)
				}
			}
		}

	}

}

