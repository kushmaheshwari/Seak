//
//  ItemEntity.swift
//  SeakApp
//
//  Created by Roman Volkov on 02/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import Parse

class ItemEntity {
	var objectID: String?
	var category: String?
	var name: String?
	var price: Double?
	var status: String? = "Brand new"
	var picture: PFFile?
	var descr: String?
	var store: PFObject?
	var storeEntity: StoreEntity?
	var reviewCount: Double?

}