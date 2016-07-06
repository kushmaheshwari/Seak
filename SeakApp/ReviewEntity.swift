//
//  ReviewEntity.swift
//  SeakApp
//
//  Created by Roman Volkov on 04/07/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import Parse

class ReviewEntity {
	var objectID: String?
	var user: PFUser?
	var item: PFObject?
	var itemEntity: ItemEntity?
	var rating: Double?
	var review: String?
	var createdAt: NSDate?

}