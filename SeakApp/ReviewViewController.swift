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

	var overlappingHeight: CGFloat = 0.0

	override func frameOfPresentedViewInContainerView() -> CGRect {
		let topSpacing: CGFloat = 4
		let bottomSpacing: CGFloat = 4
		let borderSpacing: CGFloat = 8
		return CGRect(x: borderSpacing, y: UIScreen.mainScreen().bounds.size.height - self.overlappingHeight - bottomSpacing + topSpacing, width: UIScreen.mainScreen().bounds.size.width - borderSpacing * 2, height: self.overlappingHeight - topSpacing)
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
		self.previewLabel.text = ""
		self.navigationItem.titleView = imgView

		self.previewTableView.separatorColor = UIColor.colorWithHexString("f5f5f5")

		self.previewTableView.dataSource = self
		self.previewTableView.delegate = self

		self.previewTableView.estimatedRowHeight = 135
		self.previewTableView.rowHeight = UITableViewAutomaticDimension
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
		let rating = (self.items.count > 0) ? self.items.reduce(0) { (sum, item) -> Int in
			return sum + Int(item.rating!)
		} / self.items.count: 0

		self.starsStackView.setStars(rating)
		self.previewLabel.text = "\(self.items.count) Reviews"
	}

	@IBAction func closeView(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}

	func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
		let presenter = LeaveReviewPresentationController(presentedViewController: presented, presentingViewController: presentingViewController!)
		presenter.overlappingHeight = self.previewTableView.frame.size.height + 60
		return presenter
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "goToAddReview" {
			segue.destinationViewController.transitioningDelegate = self
			segue.destinationViewController.modalPresentationStyle = .Custom
			if let vc = segue.destinationViewController as? LeaveReviewViewController {
				vc.item = self.itemEntity

				vc.submitComletionBlock = { review in
					if self.items.count == 0 {
						self.items.append(review)
					}
					else {
						self.items.insert(review, atIndex: 0)
					}

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

	func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let headerView = UIView(frame: CGRectMake(0, 0, tableView.bounds.size.width, 4))
		headerView.backgroundColor = UIColor.clearColor()
		return headerView
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cellIdentifire = "Cell"
		if let cell = previewTableView.dequeueReusableCellWithIdentifier(cellIdentifire) as? ReviewViewCellController
		{
			cell.previewNameLabel.text = ""
			let item = self.items[indexPath.section]
			let dateFormater = NSDateFormatter()
			dateFormater.dateFormat = "MMMM dd, yyyy"
			cell.previewDateLabel.text = "Posted " + dateFormater.stringFromDate(item.createdAt!)
			item.user?.fetchInfo({ (firstName, lastName, profilePicture) in
				let name = (firstName != nil) ? firstName! : "" +
					" " + ((lastName != nil) ? lastName! : "")
				cell.previewNameLabel.text = name
				profilePicture?.getDataInBackgroundWithBlock({ (data, error) in
					if error != nil {
						print(error)
					}
					else {
						dispatch_async(dispatch_get_main_queue(), {
							cell.previewAuthorImage.image = UIImage(data: data!)
						})

					}
				})
			})

			cell.previewAuthorImage.layer.cornerRadius = CGFloat(25)
			cell.previewAuthorImage.clipsToBounds = true

			cell.previewMainLabel.text = item.review
			cell.starsStackView.setStars(Int(item.rating!))

			return cell
		}
		return UITableViewCell()
	}
}
