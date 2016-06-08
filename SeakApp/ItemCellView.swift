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

	override func awakeFromNib() {
		super.awakeFromNib()
		self.pictureImage?.layer.borderColor = UIColor.colorWithHexString("1982b1").CGColor
		self.pictureImage?.layer.borderWidth = 2
	}

}
