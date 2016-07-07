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
import MapKit

class ReviewViewCellController: UITableViewCell
{
	@IBOutlet weak var starsStackView: UIStackView!

    @IBOutlet weak var previewMainLabel: UILabel!
    @IBOutlet weak var previewNameLabel: UILabel!
    @IBOutlet weak var previewDateLabel: UILabel!
	@IBOutlet weak var previewAuthorImage: UIImageView!
}

class ReviewViewController: UIViewController,
UITableViewDataSource, UITableViewDelegate
{
	@IBOutlet weak var previewLabel: UILabel!
	@IBOutlet weak var previewTableView: UITableView!
	@IBOutlet weak var closeWindowButton: UIButton!

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

		previewTableView.dataSource = self
		previewTableView.delegate = self

		closeWindowButton.addTarget(self, action: #selector(ReviewViewController.closeModalWindow), forControlEvents: UIControlEvents.TouchUpInside)

		self.loadReviews()
	}

	func loadReviews() {
		if self.itemEntity == nil {
			fatalError("Empty ItemEntity")
		}

		self.repository.getAll(by: self.itemEntity!) { (reviews) in
			self.items = reviews
			dispatch_async(dispatch_get_main_queue(), {
				self.previewTableView.reloadData()
			})
		}
	}

	func closeModalWindow()
	{
		self.dismissViewControllerAnimated(true, completion: nil)
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.items.count
	}

	func setStars(stackView: UIStackView, count: Int) {
		for starView in stackView.arrangedSubviews {
			if let imgView = starView as? UIImageView {
				imgView.image = UIImage(named: "blankStar")
			}
		}

		for i in 0..<count {
			if let imgView = stackView.arrangedSubviews[i] as? UIImageView {
				imgView.image = UIImage(named: "filledStar")
			}
		}
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cellIdentifire = "Cell"
		if let cell = previewTableView.dequeueReusableCellWithIdentifier(cellIdentifire) as? ReviewViewCellController
		{
			let item = self.items[indexPath.row]
			cell.previewDateLabel.text = item.createdAt?.description
			cell.previewNameLabel.text = item.user?.getUserName()
			cell.previewMainLabel.text = item.review
			setStars(cell.starsStackView, count: Int(item.rating!))

			cell.contentView.backgroundColor = UIColor.lightGrayColor()
			let whiteRoundedView: UIView = UIView(frame: CGRectMake(8, 4, self.previewTableView.frame.size.width - 16, 127))
			whiteRoundedView.layer.backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [216, 216, 216, 100])
			whiteRoundedView.layer.masksToBounds = false
			whiteRoundedView.layer.cornerRadius = 5.0
			whiteRoundedView.layer.shadowOffset = CGSizeMake(-1, 1)
			whiteRoundedView.layer.shadowOpacity = 0.2

			cell.contentView.addSubview(whiteRoundedView)
			cell.contentView.sendSubviewToBack(whiteRoundedView)

			return cell
		}
		return UITableViewCell()
	}

	func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

		cell.contentView.backgroundColor = UIColor.clearColor()

		let whiteRoundedView: UIView = UIView(frame: CGRectMake(10, 10, self.view.frame.size.width, 130))

		whiteRoundedView.layer.backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [1.0, 1.0, 1.0, 1.0])
		whiteRoundedView.layer.masksToBounds = true
		whiteRoundedView.layer.cornerRadius = 5.0
		whiteRoundedView.layer.shadowOffset = CGSizeMake(-1, 1)
		whiteRoundedView.layer.shadowOpacity = 0.2

		cell.contentView.addSubview(whiteRoundedView)
		cell.contentView.sendSubviewToBack(whiteRoundedView)
	}
}
