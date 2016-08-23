//
//  ReviewEntity.swift
//  SeakApp
//
//  Created by Roman Volkov on 04/07/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import Parse
import Firebase

class ReviewEntity {
	var objectID: String?
	//var user: PFUser?
    var userId: String?
    var itemId: String?
	//var itemEntity: ItemEntity?
	var rating: Double?
	var review: String?
	var createdAt: NSDate?

}