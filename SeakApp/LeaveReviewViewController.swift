//
//  LeaveReviewViewController.swift
//  SeakApp
//
//  Created by Roman Volkov on 07/07/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift

class LeaveReviewViewController: UIViewController, UITextViewDelegate {

	@IBOutlet weak var starsStackView: UIStackView!
	@IBOutlet weak var reviewText: UITextView!

	fileprivate let repository = ReviewRepository()
    fileprivate let itemRepository = ItemRepository()
	fileprivate var placeholderLabel: UILabel!
	fileprivate var bottomConstrainInitValue: CGFloat = 0.0
	var rating: Int = 0
	var item: ItemEntity? = nil
	var submitComletionBlock: () -> Void = { fatalError("Unimplemented block") }

	@IBOutlet weak var textViewBottomConstrain: NSLayoutConstraint!

	override func viewDidLoad() {
		super.viewDidLoad()

		if self.item == nil {
			fatalError ("Empty ItemEntity for LeaveReview view")
		}

        if self.item?.objectID == nil {
            fatalError ("Empty ObjectID of ItemEntity for LeaveReview view")
        }

        
		self.view.layer.cornerRadius = 5
		self.view.layer.masksToBounds = true

		self.reviewText.placeholderText = "Leave a comment..."

		for starView in starsStackView.subviews {
			if let v = starView as? UIImageView {
				let tap = UITapGestureRecognizer(target: self, action: #selector(LeaveReviewViewController.tapStar(_:)))
				tap.numberOfTapsRequired = 1
				v.isUserInteractionEnabled = true
				v.addGestureRecognizer(tap)
			}
		}

		self.addPlaceholderLabelAtTextView()

		// keyboard management
		NotificationCenter.default.addObserver(self, selector: #selector(LeaveReviewViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)

		NotificationCenter.default.addObserver(self, selector: #selector(LeaveReviewViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)

		self.bottomConstrainInitValue = self.textViewBottomConstrain.constant
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}

	func keyboardWillShow(_ n: Notification) {
		let bottomShift: CGFloat = 64
		if let height = ((n as NSNotification).userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
			self.textViewBottomConstrain.constant = self.bottomConstrainInitValue + (height - bottomShift)
		}
	}

	func keyboardWillHide(_ n: Notification) {
		self.textViewBottomConstrain.constant = self.bottomConstrainInitValue
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		IQKeyboardManager.sharedManager().enable = false
	}

	override func viewWillDisappear(_ animated: Bool) {
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
		placeholderLabel.frame.origin = CGPoint(x: 12, y: self.reviewText.font!.pointSize / 2)
		placeholderLabel.textColor = UIColor(white: 0, alpha: 0.3)
		placeholderLabel.isHidden = !self.reviewText.text.isEmpty
	}

	func textViewDidChange(_ textView: UITextView) {
		self.placeholderLabel.isHidden = !self.reviewText.text.isEmpty
	}

	func tapStar(_ sender: AnyObject) {
		self.rating = sender.view.tag
		self.starsStackView.setStars(self.rating)
	}

	@IBAction func submit(_ sender: AnyObject) {
		let text = reviewText.text
		if text?.characters.count == 0 {
			return
		}

		self.repository.saveReview(text!, rating: self.rating, item: self.item!) { (review) in
            
            self.repository.getAll(by: self.item?.objectID, completion: { (reviews) in
                let rating = (reviews.count > 0) ? reviews.reduce(0) { (sum, item) -> Double in
                    return sum + (item.rating ?? 0)
                    } / Double(reviews.count): Double(0)
                
                self.itemRepository.updateReviewScore(self.item!.objectID!,
                    reviewCount: reviews.count, avgRating: rating, completion: {
                    self.dismiss(animated: true, completion: nil)
                    self.submitComletionBlock()
                })
            })
		}
	}

	@IBAction func closeView(_ sender: AnyObject) {
		self.dismiss(animated: true, completion: nil)
	}
}
