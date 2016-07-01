//
//  StoreRepository.swift
//  SeakApp
//
//  Created by Roman Volkov on 25/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import Parse

typealias StoreRepositoryComplectionBlock = (items: [StoreEntity]) -> Void

class StoreRepository {

	private static let cache = [String: StoreEntity]()

	static func getStoreBy(id: String) -> StoreEntity? {
		return nil
	}

	let cacheAge: NSTimeInterval = 60 * 5 // 5 minutes

	func processStores(data: [PFObject]?) -> [StoreEntity]? {
		if let data = data as [PFObject]! {
			let result = Array(data.generate()).map() { (iter) -> StoreEntity in

				let store = StoreEntity()
				if let name = iter["Name"] {
					store.name = name as? String
				}
				store.descr = iter.objectForKey("Description") as? String
				store.objectID = iter.objectId!

				if let address = iter.objectForKey("Address") {
					store.address = address as? String
				}

				return store
			}
			return result
		}
		fatalError("Error on parsing Stores from Parse objects")
	}

	func getAll(completion: StoreRepositoryComplectionBlock) {
		let query = PFQuery(className: ParseClassNames.Store.rawValue)
		query.cachePolicy = .CacheThenNetwork
		query.maxCacheAge = cacheAge
		query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
			if error != nil {
				print("Error: \(error!) \(error!.userInfo)")
			} else {
				if let items = self.processStores(objects) {
					completion(items: items)
				}
			}
		}
	}
}