//
//  ReviewRepository.swift
//  SeakApp
//
//  Created by Roman Volkov on 04/07/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import Parse

typealias ReviewsRepositoryComplectionBlock = (reviews: [ReviewEntity]) -> Void

class ReviewRepository {

	let cacheAge: NSTimeInterval = 60 * 5 // 5 minutes

	func processReviews(reviewObjects: [PFObject]) -> [ReviewEntity]? {
		return reviewObjects.map({ (object) -> ReviewEntity in
			return ReviewRepository.processReview(object)
		})
	}

	static func processReview(reviewObject: PFObject) -> ReviewEntity {
		let review = ReviewEntity()
		review.objectID = reviewObject.objectId
		review.user = reviewObject["ReviewWriter"] as? PFUser
		review.item = reviewObject["Item"] as? PFObject
		review.rating = reviewObject["Rating"] as? Double
		review.review = reviewObject["Review"] as? String
		return review
	}

	func getAll(by item: ItemEntity, completion: ReviewsRepositoryComplectionBlock) {
		guard let itemId = item.objectID else { fatalError("ItemEntity with empty objectID") }
		let itemParseObject = PFObject(outDataWithClassName: ParseClassNames.Item.rawValue, objectId: itemId)
		let query = PFQuery(className: ParseClassNames.Review.rawValue)
		query.whereKey("Item", equalTo: itemParseObject)
		query.cachePolicy = .CacheElseNetwork

		query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
			if error != nil {
				print("Error: \(error!) \(error!.userInfo)")
			} else {
				if let items = self.processReviews(objects!) {
					completion(reviews: items)
				}
			}
		}
	}

	func save(review: ReviewEntity, saveCallback: () -> Void) {
		let object = PFObject(className: ParseClassNames.Review.rawValue)
		object["ReviewWriter"] = PFUser.currentUser()
		if let itemObjectId = review.itemEntity?.objectID {
			object["Item"] = PFObject(outDataWithClassName: ParseClassNames.Item.rawValue, objectId: itemObjectId)
		}
		object["Rating"] = review.rating
		object["Review"] = review.review

		object.saveInBackgroundWithBlock { (success, error) in
			if success {
				saveCallback()
			}
			else {
				fatalError("Error on saving review \(error)")
			}
		}
	}

	func delete(review: ReviewEntity, callback: () -> Void) {
		PFObject(outDataWithClassName: ParseClassNames.Review.rawValue, objectId: review.objectID).deleteInBackgroundWithBlock { (success, error) in
			if success {
				callback()
			}
			else {
				fatalError("Error on deleting review \(error)")
			}
		}
	}

}