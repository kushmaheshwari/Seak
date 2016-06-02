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

	func getAll(completion: ItemRepositoryComplectionBlock) {
		let query = PFQuery(className: ParseClassNames.Item.rawValue)
		query.cachePolicy = .CacheThenNetwork
		query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in

			if let objects = objects as [PFObject]! {
				let result = Array(objects.generate()).map() { (iter) -> ItemEntity in
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

					return item
				}

				completion(items: result)
			}

			else {
				print("Error: \(error!) \(error!.userInfo)")
			}
		}
	}
}

