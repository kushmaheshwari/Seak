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
import FirebaseAuth

class FavoriteRepository {

    private let storeRepository = StoreRepository()
    private let itemRepository = ItemRepository()
    
    //TODO check root path for favoriteStoresByUser and the same for items
    
    static func processFavoriteStore(userId: String, object: String) -> FavoriteStore {
		let result = FavoriteStore()
		result.userId = userId
		result.storeId = object
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
                    let downloadGroup = dispatch_group_create()
                    var stores = [StoreEntity]()
                    for item in items {
                        dispatch_group_enter(downloadGroup)
                        self.storeRepository.getById(item.storeId!, completion: { (result) in
                            stores.append(result)
                            dispatch_group_leave(downloadGroup);
                        })
                    }
                    
                    dispatch_group_notify(downloadGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                        completion(items: stores)
                    })
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
                    let downloadGroup = dispatch_group_create()
                    var itemEntities = [ItemEntity]()
                    for item in items {
                        dispatch_group_enter(downloadGroup)
                        self.itemRepository.getById(item.itemId, completion: { (result) in
                            itemEntities.append(result)
                            dispatch_group_leave(downloadGroup);
                        })
                    }
                    
                    dispatch_group_notify(downloadGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                        completion(items: itemEntities)
                    })
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

	func remove(storeId: String?, successBlock: (success: Bool) -> Void) {
        if storeId == nil { fatalError("empty storeId for FavoriteStore") }
        
        let currentUser = FIRAuth.auth()?.currentUser
        if currentUser == nil {
            successBlock(success: false)
            fatalError("No current user")
        }
        
        let favStoreRef = FIRDatabase.database().reference().child("favoriteStoresByUser").child(currentUser!.uid).child(storeId!)
        favStoreRef.removeValue()
        successBlock(success: true)
	}

	func add(store: StoreEntity, completion: (favoriteStore: FavoriteStore) -> Void) {
        if (store.objectID == nil) { fatalError("Empty storeId for FavoriteStore") }
        
        let currentUser = FIRAuth.auth()?.currentUser
        if currentUser == nil { fatalError("No current user for FavoriteStore") }
        
        let favStoresRef = FIRDatabase.database().reference().child("favoriteStoresByUser")
        favStoresRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if !snapshot.exists() {
                return
            }
            
            if let snapvalue = snapshot.value as? [String: AnyObject]
            {
                var key: FIRDatabaseReference
                
                if snapvalue.contains({(key, value) in key == currentUser!.uid}) {
                    key = favStoresRef.child(currentUser!.uid)
                }
                else {
                    favStoresRef.setValue(currentUser!.uid)
                    key = favStoresRef.child(currentUser!.uid)
                }
                
                let newStore = [store.objectID!: true]
                key.setValue(newStore)
                
                let savedRef = favStoresRef.child(currentUser!.uid).child(store.objectID!)
                savedRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    if !snapshot.exists() {
                        fatalError("Error on saving favorite item id: \(store.objectID!)")
                    }
                    
                    let favoriteStore = FavoriteRepository.processFavoriteStore(currentUser!.uid, object: store.objectID!)
                    completion(favoriteStore: favoriteStore)
                })
            }
        } )

	}
}