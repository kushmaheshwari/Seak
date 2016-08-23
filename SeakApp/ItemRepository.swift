//
//  ItemRepository.swift
//  SeakApp
//
//  Created by Roman Volkov on 02/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import Parse
import Firebase

typealias ItemRepositoryComplectionBlock = (items: [ItemEntity]) -> Void

class ItemRepository {

	let maxSearchCount = 30
	let maxCountByStatus = 10
	
    static func processItem(itemId: String?, object: [String: AnyObject]) -> ItemEntity {
		let item = ItemEntity()
		if let name = object["name"] {
			item.name = name as? String
		}
		if let category = object["category"] {
			item.category = category as? String
		}
        
		item.objectID = itemId!
		if let price = object["price"] {
			item.price = price.doubleValue
		}
		if let picture = object["picture"] {
			item.picture = picture as? String

		}
		if let store = object["store"] {
			item.storeId = store as? String
		}
        
		if let description = object["description"] {
			item.descr = description as? String
		}
        
		if let storeCategory = object["storeCategory"] as? String {
			item.storeCategory = StoreCategory(rawValue: storeCategory)
		}

		return item
	}

    static func processItems(data: [String: AnyObject]) -> [ItemEntity]? {
        let resultData = data.map{(key, value) -> ItemEntity in
            return processItem(key, object: (value as? [String: AnyObject])!)
        }
        return resultData
	}

	func getAll(completion: ItemRepositoryComplectionBlock) {
        let itemRef = FIRDatabase.database().reference().child("items")
        itemRef.observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            if let items = ItemRepository.processItems((snapshot.value as? [String: AnyObject])!)
            {
                completion(items: items)
            }
        })
	}

	func getByStatus(status: ItemStatus, store: StoreEntity?, completion: ItemRepositoryComplectionBlock) {
		if status == .None {
			return
		}

        let itemsRef = FIRDatabase.database().reference().child("items")
        itemsRef.queryOrderedByChild("status").queryEqualToValue(status.rawValue).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if let items =  ItemRepository.processItems((snapshot.value! as? [String: AnyObject])!) //possible crash
            {
                if store != nil {
                   let filteredItems = items.filter()
                        { $0.storeId == store?.objectID }
                    completion(items: filteredItems)
                }
                else
                {
                    completion(items: items)
                }
            }
        })
	}

	func getAllFromCategory(type: StoreCategory, store: StoreEntity?, completion: ItemRepositoryComplectionBlock) {
		if type == .None {
			return
		}

        let itemsRef = FIRDatabase.database().reference().child("items")
        if store != nil {
            itemsRef.queryOrderedByChild("store").queryEqualToValue(store?.objectID).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                if let items = ItemRepository.processItems((snapshot.value! as? [String: AnyObject])!)
                {
                    completion(items: items.filter() { $0.storeCategory == type })
                }
            })
        }
        else {
            itemsRef.queryOrderedByChild("category").queryEqualToValue(type.rawValue).observeSingleEventOfType(.Value, withBlock: {(snapshot) in
                if let items = ItemRepository.processItems((snapshot.value! as? [String: AnyObject])!)
                {
                    completion(items: items)
                }
            })
        }
	}

	func search(value: String, store: StoreEntity?, completion: ItemRepositoryComplectionBlock) {
		let nameQuery = PFQuery(className: ParseClassNames.Item.rawValue)
		nameQuery.whereKey("name", containsString: value)
		let descriptionQuery = PFQuery(className: ParseClassNames.Item.rawValue)
		descriptionQuery.whereKey("description", containsString: value)
		let query = PFQuery.orQueryWithSubqueries([nameQuery, descriptionQuery])
		if store != nil
		{
			guard let storeId = store?.objectID else { fatalError("StoreEntity with empty ObjectID") }
			let storeParseObject = PFObject(outDataWithClassName: ParseClassNames.Store.rawValue, objectId: storeId)
			query.whereKey("Store", equalTo: storeParseObject)
		}
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

