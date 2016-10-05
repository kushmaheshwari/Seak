//
//  ReviewRepository.swift
//  SeakApp
//
//  Created by Roman Volkov on 04/07/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

typealias ReviewsRepositoryComplectionBlock = (_ reviews: [ReviewEntity]) -> Void

class ReviewRepository {

	let cacheAge: TimeInterval = 60 * 60 // 1 hour

    func processReviews(_ itemId: String?, reviewObjects: [String: AnyObject?]) -> [ReviewEntity]? {
		return reviewObjects.map({ (key, value) -> ReviewEntity in
            return ReviewRepository.processReview(key, itemId: itemId, reviewObject: (value as? [String: AnyObject])!)
		})
	}

    static func processReview(_ reviewId: String?, itemId: String?, reviewObject: [String: AnyObject]) -> ReviewEntity {
		let review = ReviewEntity()
		review.objectID = reviewId
		review.userId = reviewObject["user"] as? String
		review.itemId = itemId
		review.rating = reviewObject["rating"] as? Double
		review.review = reviewObject["text"] as? String
        if let revDate = reviewObject["timestamp"] as? Double
        {
            review.createdAt = Date(timeIntervalSince1970: TimeInterval(revDate / 1000))
        }
        return review
	}

	func getAll(by itemId: String?, completion: @escaping ReviewsRepositoryComplectionBlock) {
		guard let itemId = itemId else { fatalError("ItemEntity with empty objectID") }
        
        let reviewRef = FIRDatabase.database().reference().child("reviews").child(itemId)
        reviewRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if !snapshot.exists() {
                return
            }
            
            if let reviewsValue = snapshot.value as? [String: AnyObject]
            {
                if let items = self.processReviews(itemId, reviewObjects: reviewsValue)
                {
                    completion(items.sorted(by: { (r1, r2) -> Bool in
                        if let d1 = r1.createdAt, let d2 = r2.createdAt {
                            return d2.isLessThanDate(d1)
                        }
                        return true
                    })
                    )
                }
            }
            }) { (error) in print("Error: \(error.localizedDescription)")}
	}

	func saveReview(_ text: String, rating: Int, item: ItemEntity, saveCallback: @escaping () -> Void) {
        
		let reviewsRef = FIRDatabase.database().reference().child("reviews")
        
        reviewsRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if !snapshot.exists() {
                return
            }
            
            if let snapvalue = snapshot.value as? [String: AnyObject]
            {
                var key: FIRDatabaseReference
                
                if snapvalue.contains(where: {(key, value) in key == item.objectID!})
                {
                    let itemRef = reviewsRef.child(item.objectID!)
                    key = itemRef.childByAutoId()
                }
                else
                {
                    let createItem = [item.objectID!: true]
                    reviewsRef.updateChildValues(createItem)
                    
                    key = reviewsRef.child(item.objectID!).childByAutoId()
                }
                
                let newItem = ["text": text,
                               "rating": rating,
                               "timestamp": FIRServerValue.timestamp(),
                               "user": FIRAuth.auth()?.currentUser?.uid ?? ""] as [String : Any]
                key.setValue(newItem)
                
                //TODO recalculate average raiting at Item
                
                saveCallback()
            }
        })
    }

	func delete(_ review: ReviewEntity, callback: () -> Void) {
        let reviewRef = FIRDatabase.database().reference().child("reviews").child(review.itemId!).child(review.objectID!)
        reviewRef.removeValue()
	}

}
