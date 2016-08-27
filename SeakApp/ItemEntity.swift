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
	var picture: String?
	var descr: String?
	var storeId: String?
	var storeEntity: StoreEntity?
	var avgRating: Double?
    var countReview: Int?
	var storeCategory: StoreCategory?

}