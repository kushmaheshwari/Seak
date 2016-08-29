//
//   ReviewViewController.swift
//  SeakApp
//
//  Created by Екатерина Волкова on 04/07/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit

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
    private let itemRepository = ItemRepository()
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
        
        self.setAvgRating()
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
        self.items.removeAll()
        self.previewTableView.reloadData()
        
		self.repository.getAll(by: self.itemEntity?.objectID) { (reviews) in
			self.items = reviews
			dispatch_async(dispatch_get_main_queue(), {
				self.setAvgRating()
				self.previewTableView.reloadData()
			})
		}
	}

	func setAvgRating() {
		let rating = self.itemEntity?.avgRating
		self.starsStackView.setStars(Int(rating ?? 0))
		self.previewLabel.text = "\((self.itemEntity?.countReview ?? 0)) Reviews"
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
                vc.submitComletionBlock = { () in
                    
                    self.itemRepository.getById(self.itemEntity?.objectID!, completion: { (item) in
                        self.itemEntity?.avgRating = item.avgRating
                        self.itemEntity?.countReview = item.countReview
                        
                        self.loadReviews()
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
            cell.previewAuthorImage.image = nil
            
			let item = self.items[indexPath.section]
			let dateFormater = NSDateFormatter()
			dateFormater.dateFormat = "MMMM dd, yyyy"
			cell.previewDateLabel.text = "Posted " + dateFormater.stringFromDate(item.createdAt!)

			cell.previewAuthorImage.layer.cornerRadius = CGFloat(25)
			cell.previewAuthorImage.clipsToBounds = true
            

			cell.previewMainLabel.text = item.review
			cell.starsStackView.setStars(Int(item.rating!))

			return cell
		}
		return UITableViewCell()
	}
}
