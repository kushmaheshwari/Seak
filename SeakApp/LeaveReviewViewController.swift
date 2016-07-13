//
//  LeaveReviewViewController.swift
//  SeakApp
//
//  Created by Roman Volkov on 07/07/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit

class LeaveReviewViewController: UIViewController, UITextViewDelegate {

	@IBOutlet weak var starsStackView: UIStackView!
	@IBOutlet weak var reviewText: UITextView!

	private let repository = ReviewRepository()
	private var placeholderLabel: UILabel!
	private var bottomConstrainInitValue: CGFloat = 0.0
	var rating: Int = 0
	var item: ItemEntity? = nil
	var submitComletionBlock: (review: ReviewEntity) -> Void = { _ in }

	@IBOutlet weak var textViewBottomConstrain: NSLayoutConstraint!

	override func viewDidLoad() {
		super.viewDidLoad()

		if self.item == nil {
			fatalError ("Empty ItemEntity for LeaveReview view")
		}

		self.view.layer.cornerRadius = 5
		self.view.layer.masksToBounds = true

		self.reviewText.placeholderText = "Leave a comment..."

		for starView in starsStackView.subviews {
			if let v = starView as? UIImageView {
				let tap = UITapGestureRecognizer(target: self, action: #selector(LeaveReviewViewController.tapStar(_:)))
				tap.numberOfTapsRequired = 1
				v.userInteractionEnabled = true
				v.addGestureRecognizer(tap)
			}
		}

		self.addPlaceholderLabelAtTextView()

		// keyboard management
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LeaveReviewViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: self.view.window)

		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LeaveReviewViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: self.view.window)

		self.bottomConstrainInitValue = self.textViewBottomConstrain.constant
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}

	func keyboardWillShow(n: NSNotification) {
		let bottomShift: CGFloat = 64
		if let height = (n.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue().height {
			self.textViewBottomConstrain.constant = self.bottomConstrainInitValue + (height - bottomShift)
		}
	}

	func keyboardWillHide(n: NSNotification) {
//		if let height = (n.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().height {
		self.textViewBottomConstrain.constant = self.bottomConstrainInitValue
//		}
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		IQKeyboardManager.sharedManager().enable = false
	}

	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		IQKeyboardManager.sharedManager().enable = true
	}

	func addPlaceholderLabelAtTextView() {
		self.reviewText.delegate = self
		self.placeholderLabel = UILabel()
		self.placeholderLabel.text = "Leave a comment..."
		self.placeholderLabel.font = self.reviewText.font
		placeholderLabel.sizeToFit()
		self.reviewText.addSubview(self.placeholderLabel)
		placeholderLabel.frame.origin = CGPointMake(12, self.reviewText.font!.pointSize / 2)
		placeholderLabel.textColor = UIColor(white: 0, alpha: 0.3)
		placeholderLabel.hidden = !self.reviewText.text.isEmpty
	}

	func textViewDidChange(textView: UITextView) {
		self.placeholderLabel.hidden = !self.reviewText.text.isEmpty
	}

	func tapStar(sender: AnyObject) {
		self.rating = sender.view.tag
		self.starsStackView.setStars(self.rating)
	}

	@IBAction func submit(sender: AnyObject) {
		let text = reviewText.text
		if text.characters.count == 0 {
			return
		}

		repository.saveReview(text, rating: self.rating, item: self.item!) { (review) in
			self.submitComletionBlock(review: review)
			self.dismissViewControllerAnimated(true, completion: nil)
		}
	}

	@IBAction func closeView(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
}