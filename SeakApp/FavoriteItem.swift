//
//  FavoriteItem.swift
//  SeakApp
//
//  Created by Roman Volkov on 14/07/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import Parse

class FavoriteItem {
	var objectID: String?
	var user: PFUser?
	var item: PFObject?
	var itemEntity: ItemEntity?
	var createdAt: NSDate?
}