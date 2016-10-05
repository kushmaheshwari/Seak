//
//  ItemRepository.swift
//  SeakApp
//
//  Created by Roman Volkov on 02/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import Firebase

typealias ItemRepositoryComplectionBlock = (_ items: [ItemEntity]) -> Void
typealias ItemRepositoryCompletionBlock = (_ item: ItemEntity) -> Void

class ItemRepository {

	let maxSearchCount = 30
	let maxCountByStatus = 10
	
    static func processItem(_ itemId: String?, object: [String: AnyObject]) -> ItemEntity {
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

    static func processItems(_ data: [String: AnyObject]) -> [ItemEntity]? {
        let resultData = data.map{(key, value) -> ItemEntity in
            return processItem(key, object: value as! [String: AnyObject])
        }
        return resultData
	}

	func getAll(_ completion: @escaping ItemRepositoryComplectionBlock) {
        let itemRef = FIRDatabase.database().reference().child("items")
        itemRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if !snapshot.exists() {
                return
            }
            
            if let snapvalue = snapshot.value as? [String: AnyObject]
            {
                if let items = ItemRepository.processItems(snapvalue)
                {
                    completion(items)
                }
            }
        }) { (error) in print("Error: \(error.localizedDescription)")}
	}

	func getByStatus(_ status: ItemStatus, store: StoreEntity?, completion: @escaping ItemRepositoryComplectionBlock) {
		if status == .None {
			return
		}

        let itemsRef = FIRDatabase.database().reference().child("items")
        itemsRef.queryOrdered(byChild: "status").queryEqual(toValue: status.rawValue).observeSingleEvent(of: .value, with: { (snapshot) in
            
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
                        completion(filteredItems)
                    }
                    else
                    {
                        completion(items)
                    }
                }
            }
        }) { (error) in print("Error: \(error.localizedDescription)")}
	}

	func getAllFromCategory(_ type: StoreCategory, store: StoreEntity?, completion: @escaping ItemRepositoryComplectionBlock) {
		if type == .None {
			return
		}

        let itemsRef = FIRDatabase.database().reference().child("items")
        if store != nil {
            itemsRef.queryOrdered(byChild: "store").queryEqual(toValue: store?.objectID).observeSingleEvent(of: .value, with: { (snapshot) in
                if !snapshot.exists() {
                    return
                }
                
                if let snapvalue = snapshot.value as? [String: AnyObject]
                {
                    if let items = ItemRepository.processItems(snapvalue)
                    {
                        completion(items.filter() { $0.storeCategory == type })
                    }
                }
            }) { (error) in print("Error: \(error.localizedDescription)")}
        }
        else {
            itemsRef.queryOrdered(byChild: "category").queryEqual(toValue: type.rawValue).observeSingleEvent(of: .value, with: {(snapshot) in
                if !snapshot.exists() {
                    return
                }
                
                if let snapvalue = snapshot.value as? [String: AnyObject]
                {
                    if let items = ItemRepository.processItems(snapvalue)
                    {
                        completion(items)
                    }
                }
            }) { (error) in print("Error: \(error.localizedDescription)")}
        }
	}

	func search(_ value: String, store: StoreEntity?, completion: @escaping ItemRepositoryComplectionBlock) {
		let itemRef = FIRDatabase.database().reference().child("items")
        itemRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if !snapshot.exists() {
                return
            }
            
            if let snapvalue = snapshot.value as? [String: AnyObject]
            {
                if let items = ItemRepository.processItems(snapvalue)
                {
                    var filteredItems = items.filter() {
                        (($0.name ?? "" ).lowercased().contains(value.lowercased()) ||
                        ($0.descr ?? "").lowercased().contains(value.lowercased()))
                    }
                
                    if store != nil
                    {
                        guard let storeId = store?.objectID else { fatalError("StoreEntity with empty ObjectID") }
                        filteredItems = filteredItems.filter() { $0.storeId == storeId }
                    }
                    completion(filteredItems)
                }
            }
        }) { (error) in print("Error: \(error.localizedDescription)")}

	}
    
    func getById(_ itemId: String?, completion: @escaping ItemRepositoryCompletionBlock)
    {
        guard let itID = itemId else { fatalError("Store Id is empty") }
        
        let itemRef = FIRDatabase.database().reference().child("items").child(itemId!)
        itemRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.exists() {
                return
            }
            
            if let snapvalue = snapshot.value as? [String: AnyObject]
            {
                let item = ItemRepository.processItem(itID, object: snapvalue)
                completion(item)
            }
        })
    }
    
    func updateReviewScore(_ itemId: String, reviewCount: Int, avgRating:Double, completion: @escaping () -> Void) {
        let itemRef = FIRDatabase.database().reference().child("items").child(itemId)
        itemRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.exists() {
                return
            }

            itemRef.updateChildValues(["avgRating": avgRating])
            itemRef.updateChildValues(["countReview": reviewCount])
            
            completion()
        })
    }

}

