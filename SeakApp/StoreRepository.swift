//
//  StoreRepository.swift
//  SeakApp
//
//  Created by Roman Volkov on 25/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import Parse

typealias StoresRepositoryComplectionBlock = (items: [StoreEntity]) -> Void
typealias StoreRepositoryComplectionBlock = (store: StoreEntity) -> Void

class StoreRepository {

	let cacheAge: NSTimeInterval = 60 * 5 // 5 minutes

	func getStoreBy(id: String, completion: StoreRepositoryComplectionBlock) {
		let query = PFQuery(className: ParseClassNames.Store.rawValue)
		query.whereKey("objectId", equalTo: id)
		query.cachePolicy = .CacheElseNetwork
		query.maxCacheAge = cacheAge
		query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
			if error != nil {
				print("Error: \(error!) \(error!.userInfo)")
			} else {
				if let item = StoreRepository.processStores(objects)?.first {
					completion(store: item)
				}
			}
		}
	}

	static func processStore(storeObject: PFObject) -> StoreEntity {
		let store = StoreEntity()
		if let name = storeObject["Name"] {
			store.name = name as? String
		}
		store.descr = storeObject.objectForKey("Description") as? String
		store.objectID = storeObject.objectId!

		if let address = storeObject.objectForKey("Address") {
			store.address = address as? String
		}

		if let coordinates = storeObject.objectForKey("AddressLatLong") {
			if let geoPoint = coordinates as? PFGeoPoint {
				store.coordintaes = CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
			}
		}

		return store
	}

	static func processStores(data: [PFObject]?) -> [StoreEntity]? {
		if let data = data as [PFObject]! {
			let result = Array(data.generate()).map() { (iter) -> StoreEntity in
				return processStore(iter)
			}
			return result
		}
		fatalError("Error on parsing Stores from Parse objects")
	}

	func getAll(completion: StoresRepositoryComplectionBlock) {
		let query = PFQuery(className: ParseClassNames.Store.rawValue)
		query.cachePolicy = .CacheThenNetwork
		query.maxCacheAge = cacheAge
		query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
			if error != nil {
				print("Error: \(error!) \(error!.userInfo)")
			} else {
				if let items = StoreRepository.processStores(objects) {
					completion(items: items)
				}
			}
		}
	}
}