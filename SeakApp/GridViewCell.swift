//
//  GridViewCell.swift
//  SeakApp
//
//  Created by Kush Maheshwari on 5/29/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class CollectionViewCell: UICollectionViewCell {
	@IBOutlet var productImageView: PFImageView!// all of the cell attributed(you can take out the ones that arent used anymore)
	@IBOutlet weak var itemNameLabel: UILabel!
	@IBOutlet weak var usedLabel: UILabel!
	@IBOutlet weak var priceLabel: UILabel!
	@IBOutlet weak var distanceLabel: UILabel!
	@IBOutlet weak var sellerImageView: PFImageView!
	@IBOutlet weak var favoriteButton: UIButton!

	override func awakeFromNib() { // cell stuff, change to new front end
		super.awakeFromNib()

		// self.itemNameLabel.text = "hello"
		self.layer.cornerRadius = 3.0
		self.layer.borderColor = UIColor(red: 196 / 255.0, green: 203 / 255.0, blue: 220 / 255.0, alpha: 1).CGColor
		self.layer.borderWidth = 1.0
		self.productImageView.layer.borderWidth = 1.0
		self.productImageView.layer.borderColor = UIColor(red: 196 / 255.0, green: 203 / 255.0, blue: 220 / 255.0, alpha: 1).CGColor

	}

}

