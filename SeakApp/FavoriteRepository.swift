//
//  FavoriteRepository.swift
//  SeakApp
//
//  Created by Roman Volkov on 14/07/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class FavoriteRepository {

    fileprivate let storeRepository = StoreRepository()
    fileprivate let itemRepository = ItemRepository()
    
    //TODO check root path for favoriteStoresByUser and the same for items
    
    static func processFavoriteStore(_ userId: String, object: String) -> FavoriteStore {
		let result = FavoriteStore()
		result.userId = userId
		result.storeId = object
		return result
	}

    static func processFavoriteStores(_ userId: String, objects: [String: AnyObject]) -> [FavoriteStore]? {
		return objects.map({ (key, value) -> FavoriteStore in
            return FavoriteRepository.processFavoriteStore(userId, object: key)
		})
	}

    static func processFavoriteItem(_ userId: String, object: String) -> FavoriteItem {
		let result = FavoriteItem()
		result.userId = userId
		result.itemId = object
		return result
	}

    static func processFavoriteItems(_ userId: String, objects: [String: AnyObject]) -> [FavoriteItem]? {
		return objects.map({ (key, value) -> FavoriteItem in
            return FavoriteRepository.processFavoriteItem(userId, object: key)
		})
	}

    func getAllStores(_ completion: @escaping StoresRepositoryComplectionBlock) {
    
        guard let currentUser = FIRAuth.auth()?.currentUser else { fatalError("No current user") }
        let storesRef = FIRDatabase.database().reference().child("favoriteStoresByUser").child(currentUser.uid)
        
        storesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.exists() {
                return
            }
            
            if let snapvalue = snapshot.value as? [String: AnyObject]
            {
                if let items = FavoriteRepository.processFavoriteStores(currentUser.uid, objects: snapvalue)
                {
                    let downloadGroup = DispatchGroup()
                    var stores = [StoreEntity]()
                    for item in items {
                        downloadGroup.enter()
                        self.storeRepository.getById(item.storeId!, completion: { (result) in
                            stores.append(result)
                            downloadGroup.leave();
                        })
                    }
                    
                    downloadGroup.notify(queue: DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.background), execute: {
                        completion(stores)
                    })
                }
            }
        }) { (error) in print("Error: \(error.localizedDescription)")}
        
	}

	func getAllItems(_ completion: @escaping ItemRepositoryComplectionBlock) {
        guard let currentUser = FIRAuth.auth()?.currentUser else { fatalError("No current user") }
        let itemsRef = FIRDatabase.database().reference().child("favoriteItemsByUser").child(currentUser.uid)

        itemsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.exists() {
                return
            }
            
            if let snapvalue = snapshot.value as? [String: AnyObject]
            {
                if let items = FavoriteRepository.processFavoriteItems(currentUser.uid, objects: snapvalue)
                {
                    let downloadGroup = DispatchGroup()
                    var itemEntities = [ItemEntity]()
                    for item in items {
                        downloadGroup.enter()
                        self.itemRepository.getById(item.itemId, completion: { (result) in
                            itemEntities.append(result)
                            downloadGroup.leave();
                        })
                    }
                    
                    downloadGroup.notify(queue: DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.background), execute: {
                        completion(itemEntities)
                    })
                }
            }
        }) { (error) in print("Error: \(error.localizedDescription)")}
	}

	// Items
	func getLike(by item: ItemEntity, completion: @escaping (_ item: FavoriteItem?) -> Void) {
		var favItemsRef = FIRDatabase.database().reference().child("favoriteItemsByUser")
        let currentUser = FIRAuth.auth()?.currentUser
        if currentUser != nil {
            favItemsRef = favItemsRef.child(currentUser!.uid)
        } else {
            completion(nil)
            return
        }
        
        favItemsRef = favItemsRef.child(item.objectID!)
		
        favItemsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.exists() {
                completion(nil)
                return
            }
            
            let item = FavoriteRepository.processFavoriteItem(currentUser!.uid, object: item.objectID!)
            completion(item)
        })
	}

    func dislike(_ itemId: String?, successBlock: (_ success: Bool) -> Void) {
		if itemId == nil { fatalError("empty itemId for FavoriteItem") }
		
        let currentUser = FIRAuth.auth()?.currentUser
        if currentUser == nil {
            successBlock(false)
            fatalError("No current user")
        }
        
        let favItemRef = FIRDatabase.database().reference().child("favoriteItemsByUser").child(currentUser!.uid).child(itemId!)
        favItemRef.removeValue()
        successBlock(true)
	}

	func like(_ item: ItemEntity, completion: @escaping (_ favoriteItem: FavoriteItem) -> Void) {
        if (item.objectID == nil) { fatalError("Empty itemId for FavoriteItem") }
        
        let currentUser = FIRAuth.auth()?.currentUser
        if currentUser == nil { fatalError("No current user for FavoriteItem") }
        
        let favItemsRef = FIRDatabase.database().reference().child("favoriteItemsByUser")
        favItemsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.exists() {
                return
            }
            
            if let snapvalue = snapshot.value as? [String: AnyObject]
            {
                var key: FIRDatabaseReference
                
                if snapvalue.contains(where: {(key, value) in key == currentUser!.uid}) {
                    key = favItemsRef.child(currentUser!.uid)
                }
                else {
                    let newUserItem = [currentUser!.uid: true]
                    favItemsRef.updateChildValues(newUserItem)
                    key = favItemsRef.child(currentUser!.uid)
                }
                
                let newItem = [item.objectID!: true]
                key.updateChildValues(newItem)
                
                let savedRef = favItemsRef.child(currentUser!.uid).child(item.objectID!)
                savedRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    if !snapshot.exists() {
                        fatalError("Error on saving favorite item id: \(item.objectID!)")
                    }
                    
                    let favoriteItem = FavoriteRepository.processFavoriteItem(currentUser!.uid, object: item.objectID!)
                    completion(favoriteItem)
                })
            }
        } )
	}

	// Store
	func getStatus(by store: StoreEntity, completion: @escaping (_ store: FavoriteStore?) -> Void) {
        var favStoresRef = FIRDatabase.database().reference().child("favoriteStoresByUser")
        let currentUser = FIRAuth.auth()?.currentUser
        if currentUser != nil {
            favStoresRef = favStoresRef.child(currentUser!.uid)
        } else {
            completion(nil)
            return
        }
        
        favStoresRef = favStoresRef.child(store.objectID!)
        
        favStoresRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.exists() {
                completion(nil)
                return
            }
            
            let item = FavoriteRepository.processFavoriteStore(currentUser!.uid, object: store.objectID!)
            completion(item)
        })

	}

	func remove(_ storeId: String?, successBlock: (_ success: Bool) -> Void) {
        if storeId == nil { fatalError("empty storeId for FavoriteStore") }
        
        let currentUser = FIRAuth.auth()?.currentUser
        if currentUser == nil {
            successBlock(false)
            fatalError("No current user")
        }
        
        let favStoreRef = FIRDatabase.database().reference().child("favoriteStoresByUser").child(currentUser!.uid).child(storeId!)
        favStoreRef.removeValue()
        successBlock(true)
	}

	func add(_ store: StoreEntity, completion: @escaping (_ favoriteStore: FavoriteStore) -> Void) {
        if (store.objectID == nil) { fatalError("Empty storeId for FavoriteStore") }
        
        let currentUser = FIRAuth.auth()?.currentUser
        if currentUser == nil { fatalError("No current user for FavoriteStore") }
        
        let favStoresRef = FIRDatabase.database().reference().child("favoriteStoresByUser")
        favStoresRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.exists() {
                return
            }
            
            if let snapvalue = snapshot.value as? [String: AnyObject]
            {
                var key: FIRDatabaseReference
                
                if snapvalue.contains(where: {(key, value) in key == currentUser!.uid}) {
                    key = favStoresRef.child(currentUser!.uid)
                }
                else {
                    let newUserItem = [currentUser!.uid: true]
                    favStoresRef.updateChildValues(newUserItem)
                    key = favStoresRef.child(currentUser!.uid)
                }
                
                let newStore = [store.objectID!: true]
                key.updateChildValues(newStore)
                
                let savedRef = favStoresRef.child(currentUser!.uid).child(store.objectID!)
                savedRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    if !snapshot.exists() {
                        fatalError("Error on saving favorite item id: \(store.objectID!)")
                    }
                    
                    let favoriteStore = FavoriteRepository.processFavoriteStore(currentUser!.uid, object: store.objectID!)
                    completion(favoriteStore)
                })
            }
        } )

	}
}
