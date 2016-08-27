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
typealias ItemRepositoryCompletionBlock = (item: ItemEntity) -> Void

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
        
        item.avgRating = object["avgRating"] as? Double
        item.countReview = object["countReview"] as? Int

		return item
	}

    static func processItems(data: [String: AnyObject]) -> [ItemEntity]? {
        let resultData = data.map{(key, value) -> ItemEntity in
            return processItem(key, object: value as! [String: AnyObject])
        }
        return resultData
	}

	func getAll(completion: ItemRepositoryComplectionBlock) {
        let itemRef = FIRDatabase.database().reference().child("items")
        itemRef.observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            if !snapshot.exists() {
                return
            }
            
            if let snapvalue = snapshot.value as? [String: AnyObject]
            {
                if let items = ItemRepository.processItems(snapvalue)
                {
                    completion(items: items)
                }
            }
        }) { (error) in print("Error: \(error.localizedDescription)")}
	}

	func getByStatus(status: ItemStatus, store: StoreEntity?, completion: ItemRepositoryComplectionBlock) {
		if status == .None {
			return
		}

        let itemsRef = FIRDatabase.database().reference().child("items")
        itemsRef.queryOrderedByChild("status").queryEqualToValue(status.rawValue).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            if (!snapshot.exists()) {
                return
            }
            
            if let snapvalue = snapshot.value as? [String: AnyObject]
            {
                if let items =  ItemRepository.processItems(snapvalue)
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
            }
        }) { (error) in print("Error: \(error.localizedDescription)")}
	}

	func getAllFromCategory(type: StoreCategory, store: StoreEntity?, completion: ItemRepositoryComplectionBlock) {
		if type == .None {
			return
		}

        let itemsRef = FIRDatabase.database().reference().child("items")
        if store != nil {
            itemsRef.queryOrderedByChild("store").queryEqualToValue(store?.objectID).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                if !snapshot.exists() {
                    return
                }
                
                if let snapvalue = snapshot.value as? [String: AnyObject]
                {
                    if let items = ItemRepository.processItems(snapvalue)
                    {
                        completion(items: items.filter() { $0.storeCategory == type })
                    }
                }
            }) { (error) in print("Error: \(error.localizedDescription)")}
        }
        else {
            itemsRef.queryOrderedByChild("category").queryEqualToValue(type.rawValue).observeSingleEventOfType(.Value, withBlock: {(snapshot) in
                if !snapshot.exists() {
                    return
                }
                
                if let snapvalue = snapshot.value as? [String: AnyObject]
                {
                    if let items = ItemRepository.processItems(snapvalue)
                    {
                        completion(items: items)
                    }
                }
            }) { (error) in print("Error: \(error.localizedDescription)")}
        }
	}

	func search(value: String, store: StoreEntity?, completion: ItemRepositoryComplectionBlock) {
		let itemRef = FIRDatabase.database().reference().child("items")
        itemRef.observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            if !snapshot.exists() {
                return
            }
            
            if let snapvalue = snapshot.value as? [String: AnyObject]
            {
                if let items = ItemRepository.processItems(snapvalue)
                {
                    var filteredItems = items.filter() {($0.name?.containsString(value))! || ($0.descr?.containsString(value))!}
                
                    if store != nil
                    {
                        guard let storeId = store?.objectID else { fatalError("StoreEntity with empty ObjectID") }
                        filteredItems = filteredItems.filter() { $0.storeId == storeId }
                    }
                    completion(items: filteredItems)
                }
            }
        }) { (error) in print("Error: \(error.localizedDescription)")}

	}
    
    static func getById(itemId: String?, completion: ItemRepositoryCompletionBlock)
    {
        guard let itID = itemId else { fatalError("Store Id is empty") }
        
        let itemRef = FIRDatabase.database().reference().child("stores").child(itemId!)
        itemRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if !snapshot.exists() {
                return
            }
            
            if let snapvalue = snapshot.value as? [String: AnyObject]
            {
                let item = processItem(itID, object: snapvalue)
                completion(item: item)
            }
        })
    }

}

