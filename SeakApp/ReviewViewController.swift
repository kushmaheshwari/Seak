//
//   ReviewViewController.swift
//  SeakApp
//
//  Created by Екатерина Волкова on 04/07/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit
import ParseUI
import ParseFacebookUtilsV4

class ReviewViewCellController: UITableViewCell
{
	@IBOutlet weak var starsStackView: UIStackView!

	@IBOutlet weak var previewMainLabel: UILabel!
	@IBOutlet weak var previewNameLabel: UILabel!
	@IBOutlet weak var previewDateLabel: UILabel!
	@IBOutlet weak var previewAuthorImage: UIImageView!
}

class LeaveReviewPresentationController: UIPresentationController {
	override func frameOfPresentedViewInContainerView() -> CGRect {
		let height: CGFloat = 230
		let bottomSpacing: CGFloat = 4
		let borderSpacing: CGFloat = 8
		return CGRect(x: borderSpacing, y: UIScreen.mainScreen().bounds.size.height - height - bottomSpacing, width: UIScreen.mainScreen().bounds.size.width - borderSpacing * 2, height: height)
	}
}

class ReviewViewController: UIViewController,
UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate
{
	@IBOutlet weak var previewLabel: UILabel!
	@IBOutlet weak var previewTableView: UITableView!
	@IBOutlet weak var closeWindowButton: UIButton!
	@IBOutlet weak var starsStackView: UIStackView!

	private let repository = ReviewRepository()
	private var items: [ReviewEntity] = []
	var itemEntity: ItemEntity?

	override func viewDidLoad() {
		super.viewDidLoad()

		let titleImage = UIImage(named: "navBarLogo")
		let imgView = UIImageView(image: titleImage)
		imgView.frame = CGRectMake(0, 0, 50, 25)
		imgView.contentMode = .ScaleAspectFit
		self.title = ""
		self.navigationItem.titleView = imgView

		self.previewTableView.separatorColor = UIColor.colorWithHexString("f5f5f5")

		previewTableView.dataSource = self
		previewTableView.delegate = self

		closeWindowButton.addTarget(self, action: #selector(ReviewViewController.closeModalWindow), forControlEvents: UIControlEvents.TouchUpInside)
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		self.items.removeAll()
		self.loadReviews()
	}

	func loadReviews() {
		if self.itemEntity == nil {
			fatalError("Empty ItemEntity")
		}

		self.repository.getAll(by: self.itemEntity!) { (reviews) in
			self.items = reviews
			dispatch_async(dispatch_get_main_queue(), {
				self.setAvgRating()
				self.previewTableView.reloadData()
			})
		}
	}

	func setAvgRating() {
		let rating = self.items.reduce(0) { (sum, item) -> Int in
			return sum + Int(item.rating!)
		} / self.items.count

		self.starsStackView.setStars(rating)
	}

	func closeModalWindow()
	{
		self.dismissViewControllerAnimated(true, completion: nil)
	}

	func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
		return LeaveReviewPresentationController(presentedViewController: presented, presentingViewController: presentingViewController!)
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "goToAddReview" {
			segue.destinationViewController.transitioningDelegate = self
			segue.destinationViewController.modalPresentationStyle = .Custom
			if let vc = segue.destinationViewController as? LeaveReviewViewController {
				vc.item = self.itemEntity

				vc.submitComletionBlock = { review in
					self.items.append(review)
					dispatch_async(dispatch_get_main_queue(), {
						self.setAvgRating()
						self.previewTableView.reloadData()
					})
				}
			} // end cast

		}
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1 // self.items.count
	}

	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return self.items.count
	}

	func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 4
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cellIdentifire = "Cell"
		if let cell = previewTableView.dequeueReusableCellWithIdentifier(cellIdentifire) as? ReviewViewCellController
		{
			let item = self.items[indexPath.section]
			let dateFormater = NSDateFormatter()
			dateFormater.dateFormat = "MMMM dd, yyyy"
			cell.previewDateLabel.text = "Posted " + dateFormater.stringFromDate(item.createdAt!)
			cell.previewNameLabel.text = item.user?.getUserName()
			cell.previewMainLabel.text = item.review
			cell.starsStackView.setStars(Int(item.rating!))

			if item.user != nil {
				if PFFacebookUtils.isLinkedWithUser(item.user!) {
					// TODO set picture

				}
			}

//			cell.layer.borderColor = UIColor.colorWithHexString("f5f5f5").CGColor

			return cell
		}
		return UITableViewCell()
	}
}
