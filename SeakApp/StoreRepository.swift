//
//  StoreRepository.swift
//  SeakApp
//
//  Created by Roman Volkov on 25/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation

typealias StoresRepositoryComplectionBlock = (_ items: [StoreEntity]) -> Void
typealias StoreRepositoryCompletionBlock = (_ item: StoreEntity) -> Void

class StoreRepository {

	let cacheAge: TimeInterval = 60 * 60 // 1 hour

    static func processStore(_ storeId: String?, storeObject: [String: AnyObject]) -> StoreEntity {
		let store = StoreEntity()
		if let name = storeObject["name"] {
			store.name = name as? String
		}
		store.descr = storeObject["description"] as? String
		store.objectID = storeId

		if let address = storeObject["address"] {
			store.address = address as? String
		}
        
        let addresslat = storeObject["latitude"] as? Double
        let addresslong = storeObject["longitude"] as? Double
        
		if addresslat != nil && addresslong != nil {
			store.coordintaes = CLLocationCoordinate2D(latitude: addresslat!, longitude: addresslong!)
		}

        if let categories = storeObject["categories"] as? [String : AnyObject] {
			store.categories = categories.map({ (key, _) in StoreCategory(rawValue: key)! })
		}

		return store
	}

    static func processStores(_ data: [String: AnyObject]) -> [StoreEntity]? {
        let resultArray = data.map { (key, value) -> StoreEntity in
            return processStore(key, storeObject: (value as? [String: AnyObject])!)
        }

        return resultArray
	}

	func getAll(_ completion: @escaping StoresRepositoryComplectionBlock) {
		let storesRef = FIRDatabase.database().reference().child("stores")
        storesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.exists() {
                return
            }
            
            if let snapvalue = snapshot.value as? [String: AnyObject]
            {
                if let items = StoreRepository.processStores(snapvalue)
                {
                    completion(items)
                }
            }
        }) { (error) in print("Error: \(error.localizedDescription)")}
	}
    
    func getById(_ storeId: String?, completion: @escaping StoreRepositoryCompletionBlock)
    {
        guard let sID = storeId else { fatalError("Store Id is empty") }
        
        let storeRef = FIRDatabase.database().reference().child("stores").child(storeId!)
        storeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.exists() {
                return
            }
            
            if let snapvalue = snapshot.value as? [String: AnyObject]
            {
                let item = StoreRepository.processStore(sID, storeObject: snapvalue)
                completion(item)
            }
        })
    }
}
