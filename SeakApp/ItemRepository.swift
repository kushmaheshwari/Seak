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
	let cacheAge: NSTimeInterval = 60 * 5 // 5 minutes

	func processItems(data: [PFObject]?) -> [ItemEntity]? {
		if let data = data as [PFObject]! {
			let result = Array(data.generate()).map() { (iter) -> ItemEntity in

				let item = ItemEntity()
				if let name = iter["name"] {
					item.name = name as? String
				}
				if let category = iter.objectForKey("category") {
					item.category = category as? String
				}
				item.objectID = iter.objectId!
				if let price = iter.objectForKey("price") {
					item.price = price.doubleValue
				}
				if let picture = iter.objectForKey("picture") {
					item.picture = picture as? PFFile

				}
				if let store = iter.objectForKey("Store") {
					item.store = store as? String
				}
				item.description = iter.description

				return item
			}
			return result
		}
		print("Error on parsing Items from Parse objects")
		return nil
	}

	func getAll(completion: ItemRepositoryComplectionBlock) {
		let query = PFQuery(className: ParseClassNames.Item.rawValue)
		query.cachePolicy = .CacheThenNetwork
		query.maxCacheAge = cacheAge
		query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
			if error != nil {
				print("Error: \(error!) \(error!.userInfo)")
			} else {
				if let items = self.processItems(objects) {
					completion(items: items)
				}
			}
		}
	}

	func getAllFromCategory(type: MenuItems, completion: ItemRepositoryComplectionBlock) {
		let query = PFQuery(className: ParseClassNames.Item.rawValue)
			.whereKey("category", containsString: type.rawValue)
		query.cachePolicy = .CacheThenNetwork
		query.maxCacheAge = cacheAge

		query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
			if error != nil {
				print("Error: \(error!) \(error!.userInfo)")
			} else {
				if let items = self.processItems(objects) {
					completion(items: items)
				}
			}
		}
	}

	func search(value: String, completion: ItemRepositoryComplectionBlock) {
		let query = PFQuery(className: ParseClassNames.Item.rawValue)
			.whereKey("name", containsString: value)
			.whereKey("description", containsString: value)
		query.limit = maxSearchCount
		query.cachePolicy = .CacheThenNetwork
		query.maxCacheAge = cacheAge

		query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
			if error != nil {
				print("Error: \(error!) \(error!.userInfo)")
			} else {
				if let items = self.processItems(objects) {
					completion(items: items)
				}
			}
		}

	}

}

