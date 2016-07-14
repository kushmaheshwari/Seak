//
//  FavoriteStore.swift
//  SeakApp
//
//  Created by Roman Volkov on 14/07/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import Parse

class FavoriteStore {
	var objectID: String?
	var user: PFUser?
	var store: PFObject?
	var storeEntity: StoreEntity?
	var createdAt: NSDate?
}