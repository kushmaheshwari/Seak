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
	@IBOutlet weak var stars: UIButton!

	var tapExecutionBlock: (updatedItem: ItemEntity) -> Void = { _ in }

	private var item = ItemEntity()

	override func awakeFromNib() {
		super.awakeFromNib()
	}

	func fillCell(item: ItemEntity) {
		self.backgroundColor = UIColor.whiteColor()
		self.pictureImage?.layer.backgroundColor = UIColor.whiteColor().CGColor

		self.stars.layer.cornerRadius = 5;
		self.stars.layer.masksToBounds = true

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
	}

	func openDetails(gesture: UITapGestureRecognizer?) {

		if let storeObject = item.store {
			storeObject.fetchInBackgroundWithBlock({ (object, error) in
				if error != nil {
					fatalError("Error on parsing store for \(self.item)")
				}
				let store = StoreRepository.processStore(object!)
				self.item.storeEntity = store
				dispatch_async(dispatch_get_main_queue(), {
					self.tapExecutionBlock(updatedItem: self.item)
				})

			})
		}

	}

}
