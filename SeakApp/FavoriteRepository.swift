//
//  FavoriteRepository.swift
//  SeakApp
//
//  Created by Roman Volkov on 14/07/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import Parse
import Firebase

class FavoriteRepository {

    static func processFavoriteStore(userId: String, object: String) -> FavoriteStore {
		let result = FavoriteStore()
		result.userId = userId
		result.storeId = object
		/*if let store = result.storeId {
			do {
				try store.fetch() }
			catch {
				fatalError("can't fetch favorite store")
			}
            /// TODO replace it
//			result.storeEntity = StoreRepository.processStore(store.objectId, storeObject: store)
		}*/
		return result
	}

    static func processFavoriteStores(userId: String, objects: [String: AnyObject]) -> [FavoriteStore]? {
		return objects.map({ (key, value) -> FavoriteStore in
            return FavoriteRepository.processFavoriteStore(userId, object: key)
		})
	}

    static func processFavoriteItem(userId: String, object: String) -> FavoriteItem {
		let result = FavoriteItem()
		result.userId = userId
		result.itemId = object
		/*if let item = result.item {
			do {
				try item.fetch() }
			catch {
				fatalError("can't fetch favorite item")
			}
            ////TODO replace it
			//result.itemEntity = ItemRepository.processItem(item.objectId, object: item) TO-DO: make migration to Firebase
		}*/
		return result
	}

    static func processFavoriteItems(userId: String, objects: [String: AnyObject]) -> [FavoriteItem]? {
		return objects.map({ (key, value) -> FavoriteItem in
            return FavoriteRepository.processFavoriteItem(userId, object: key)
		})
	}

	func getAllStores(completion: StoresRepositoryComplectionBlock) {
        guard let currentUser = FIRAuth.auth()?.currentUser else { fatalError("No current user") }
        let storesRef = FIRDatabase.database().reference().child("favoriteStoresByUser").child(currentUser.uid)
        storesRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if !snapshot.exists() {
                return
            }
            
            if let snapvalue = snapshot.value as? [String: AnyObject]
            {
                if let items = FavoriteRepository.processFavoriteStores(currentUser.uid, objects: snapvalue)
                {
                    //TODO make a decision what to do here
                    
                    /*completion(items: items.map({ (favoriteStore) -> StoreEntity in
                        return favoriteStore.storeEntity!
                    }))*/
                }
            }
        }) { (error) in print("Error: \(error.localizedDescription)")}
        
	}

	func getAllItems(completion: ItemRepositoryComplectionBlock) {
        guard let currentUser = FIRAuth.auth()?.currentUser else { fatalError("No current user") }
        let itemsRef = FIRDatabase.database().reference().child("favoriteItemsByUser").child(currentUser.uid)

        itemsRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if !snapshot.exists() {
                return
            }
            
            if let snapvalue = snapshot.value as? [String: AnyObject]
            {
                if let items = FavoriteRepository.processFavoriteItems(currentUser.uid, objects: snapvalue)
                {
                    //TODO make a decision what to do here
                    
                    /*completion(items: items.map({ (favoriteItem) -> ItemEntity in
                     return favoriteItem.itemEntity!
                     }))*/
                }
            }
        }) { (error) in print("Error: \(error.localizedDescription)")}
	}

	// Items
	func getLike(by item: ItemEntity, completion: (item: FavoriteItem?) -> Void) {
		var favItemsRef = FIRDatabase.database().reference().child("favoriteItemsByUser")
        let currentUser = FIRAuth.auth()?.currentUser
        if currentUser != nil {
            favItemsRef = favItemsRef.child(currentUser!.uid)
        } else {
            completion(item: nil)
            return
        }
        
        favItemsRef = favItemsRef.child(item.objectID!)
		
        favItemsRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if !snapshot.exists() {
                completion(item: nil)
                return
            }
            
            let item = FavoriteRepository.processFavoriteItem(currentUser!.uid, object: item.objectID!)
            completion(item: item)
        })
	}

    func dislike(itemId: String?, successBlock: (success: Bool) -> Void) {
		if itemId == nil { fatalError("empty itemId for FavoriteItem") }
		
        let currentUser = FIRAuth.auth()?.currentUser
        if currentUser == nil {
            successBlock(success: false)
            fatalError("No current user")
        }
        
        let favItemRef = FIRDatabase.database().reference().child("favoriteItemsByUser").child(currentUser!.uid).child(itemId!)
        favItemRef.removeValue()
        successBlock(success: true)
	}

	func like(item: ItemEntity, completion: (favoriteItem: FavoriteItem) -> Void) {
        if (item.objectID == nil) { fatalError("Empty itemId for FavoriteItem") }
        
        let currentUser = FIRAuth.auth()?.currentUser
        if currentUser == nil { fatalError("No current user for FavoriteItem") }
        
        let favItemsRef = FIRDatabase.database().reference().child("favoriteItemsByUser")
        favItemsRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if !snapshot.exists() {
                return
            }
            
            if let snapvalue = snapshot.value as? [String: AnyObject]
            {
                var key: FIRDatabaseReference
                
                if snapvalue.contains({(key, value) in key == currentUser!.uid}) {
                    key = favItemsRef.child(currentUser!.uid)
                }
                else {
                    favItemsRef.setValue(currentUser!.uid)
                    key = favItemsRef.child(currentUser!.uid)
                }
                
                let newItem = [item.objectID!: true]
                key.setValue(newItem)
                
                let savedRef = favItemsRef.child(currentUser!.uid).child(item.objectID!)
                savedRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    if !snapshot.exists() {
                        fatalError("Error on saving favorite item id: \(item.objectID!)")
                    }
                    
                    let favoriteItem = FavoriteRepository.processFavoriteItem(currentUser!.uid, object: item.objectID!)
                    completion(favoriteItem: favoriteItem)
                })
            }
        } )
	}

	// Store
	func getStatus(by store: StoreEntity, completion: (store: FavoriteStore?) -> Void) {
        var favStoresRef = FIRDatabase.database().reference().child("favoriteStoresByUser")
        let currentUser = FIRAuth.auth()?.currentUser
        if currentUser != nil {
            favStoresRef = favStoresRef.child(currentUser!.uid)
        } else {
            completion(store: nil)
            return
        }
        
        favStoresRef = favStoresRef.child(store.objectID!)
        
        favStoresRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if !snapshot.exists() {
                completion(store: nil)
                return
            }
            
            let item = FavoriteRepository.processFavoriteStore(currentUser!.uid, object: store.objectID!)
            completion(store: item)
        })

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