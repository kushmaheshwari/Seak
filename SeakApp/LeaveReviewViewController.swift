//
//  LeaveReviewViewController.swift
//  SeakApp
//
//  Created by Roman Volkov on 07/07/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit

class LeaveReviewViewController: UIViewController {

	@IBOutlet weak var starsStackView: UIStackView!
	@IBOutlet weak var reviewText: UITextView!

	private let repository = ReviewRepository()

	var rating: Int = 0
	var item: ItemEntity? = nil
	var submitComletionBlock: (review: ReviewEntity) -> Void = { _ in }

	override func viewDidLoad() {
		super.viewDidLoad()

		if self.item == nil {
			fatalError ("Empty ItemEntity for LeaveReview view")
		}

		self.view.layer.cornerRadius = 5
		self.view.layer.masksToBounds = true

		for starView in starsStackView.subviews {
			if let v = starView as? UIImageView {
				let tap = UITapGestureRecognizer(target: self, action: #selector(LeaveReviewViewController.tapStar(_:)))
				tap.numberOfTapsRequired = 1
				v.userInteractionEnabled = true
				v.addGestureRecognizer(tap)

			}
		}
	}

	func tapStar(sender: AnyObject) {
		self.rating = sender.view.tag
		self.starsStackView.setStars(self.rating)
	}

	@IBAction func submit(sender: AnyObject) {
		let text = reviewText.text

		repository.saveReview(text, rating: self.rating, item: self.item!) { (review) in
			self.submitComletionBlock(review: review)
			self.dismissViewControllerAnimated(true, completion: nil)
		}
	}

	@IBAction func closeView(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
}