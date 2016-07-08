//
//  ItemCellView.swift
//  SeakApp
//
//  Created by Roman Volkov on 06/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit
import ParseUI

class ItemCellView: UICollectionViewCell {
	@IBOutlet weak var likeImage: UIImageView!
	@IBOutlet weak var pictureImage: PFImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var priceLabel: UILabel!
	@IBOutlet weak var starsStackView: UIStackView!

	var tapExecutionBlock: (updatedItem: ItemEntity) -> Void = { _ in }

	private var item = ItemEntity()
	private var tapped: Bool = false
	private let reviewRepository = ReviewRepository()

	override func awakeFromNib() {
		super.awakeFromNib()
	}

	func fillCell(item: ItemEntity) {
		self.backgroundColor = UIColor.whiteColor()
		self.pictureImage?.layer.backgroundColor = UIColor.whiteColor().CGColor

		self.starsStackView.backgroundColor = UIColor.colorWithHexString("21c2f8")

		self.nameLabel.text = item.name

		if let price = item.price {
			self.priceLabel.text = String(format: "$%.1f", price)
		}

		self.pictureImage.file = item.picture
		self.pictureImage.loadInBackground({ (img, error) in
			self.pictureImage.image = img
			self.pictureImage.setNeedsDisplay()
		})

		self.item = item

		let tap = UITapGestureRecognizer(target: self, action: #selector(ItemCellView.openDetails(_:)))

		tap.numberOfTouchesRequired = 1
		self.addGestureRecognizer(tap)
		self.layoutSubviews()
		self.sizeToFit()

		reviewRepository.getAll(by: self.item) { (reviews) in
			let rating = (reviews.count > 0) ? reviews.reduce(0) { (sum, item) -> Int in
				return sum + Int(item.rating!)
			} / reviews.count: 0

			self.starsStackView.setStars(rating)
		}
	}

	func openDetails(gesture: UITapGestureRecognizer?) {
		if tapped {
			return
		}
		tapped = true
		if let storeObject = item.store {
			storeObject.fetchInBackgroundWithBlock({ (object, error) in
				if error != nil {
					fatalError("Error on parsing store for \(self.item)")
				}
				let store = StoreRepository.processStore(object!)
				self.item.storeEntity = store
				dispatch_async(dispatch_get_main_queue(), {
					self.tapExecutionBlock(updatedItem: self.item)
					self.tapped = false
				})

			})
		}

	}

}
