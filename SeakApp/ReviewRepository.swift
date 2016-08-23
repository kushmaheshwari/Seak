//
//  ReviewRepository.swift
//  SeakApp
//
//  Created by Roman Volkov on 04/07/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import Parse
import Firebase

typealias ReviewsRepositoryComplectionBlock = (reviews: [ReviewEntity]) -> Void

class ReviewRepository {

	let cacheAge: NSTimeInterval = 60 * 60 // 1 hour

    func processReviews(itemId: String?, reviewObjects: [String: AnyObject?]) -> [ReviewEntity]? {
		return reviewObjects.map({ (key, value) -> ReviewEntity in
            return ReviewRepository.processReview(key, itemId: itemId, reviewObject: (value as? [String: AnyObject])!)
		})
	}

    static func processReview(reviewId: String?, itemId: String?, reviewObject: [String: AnyObject]) -> ReviewEntity {
		let review = ReviewEntity()
		review.objectID = reviewId
		review.userId = reviewObject["user"] as? String
		review.itemId = itemId
		review.rating = reviewObject["rating"] as? Double
		review.review = reviewObject["text"] as? String
        if let revDate = reviewObject["timestamp"] as? Double
        {
            review.createdAt = NSDate(timeIntervalSinceReferenceDate: revDate)
        }
        return review
	}

	func getAll(by itemId: String?, completion: ReviewsRepositoryComplectionBlock) {
		guard let itemId = itemId else { fatalError("ItemEntity with empty objectID") }
        
        let reviewRef = FIRDatabase.database().reference().child("reviews")
        reviewRef.observeSingleEventOfType(.Value, withBlock: {(snapshot) in
             let revItems = snapshot.value as? [String: AnyObject]
             if let reviews = revItems![itemId]
             {
                if let items = self.processReviews(itemId, reviewObjects: reviews as! [String: AnyObject?])
                {
                    completion(reviews: items)
                }
             }
            }) { (error) in print("Error: \(error.localizedDescription)")}
	}

	func saveReview(text: String, rating: Int, item: ItemEntity, saveCallback: (review: ReviewEntity) -> Void) {
		let itemRef = FIRDatabase.database().reference().child("reviews").child(item.objectID!) // TODO check that item.objectID exists
        let key = itemRef.childByAutoId()
        
        let newItem = ["text": text,
                       "rating": rating]
        key.setValue(newItem)
	}

	func delete(review: ReviewEntity, callback: () -> Void) {
        let reviewRef = FIRDatabase.database().reference().child("reviews").child(review.itemId!).child(review.objectID!)
        reviewRef.removeValue()
	}

}