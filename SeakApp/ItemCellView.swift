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
		self.layoutSubviews()
		self.sizeToFit()
	}

}
