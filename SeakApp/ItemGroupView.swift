//
//  ItemGroupView.swift
//  SeakApp
//
//  Created by Roman Volkov on 23/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit
import ParseUI

class ItemGroupView: UICollectionViewCell {
	@IBOutlet weak var discountLabel: UILabel!

	@IBOutlet weak var imgView: PFImageView!

	var tapExecutionBlock: () -> Void = { }

	override func awakeFromNib() {
		super.awakeFromNib()
		let tap = UITapGestureRecognizer(target: self, action: #selector(ItemGroupView.openDetails(_:)))

		tap.numberOfTouchesRequired = 1
		self.addGestureRecognizer(tap)
	}

	func openDetails(gesture: UITapGestureRecognizer?) {
		self.tapExecutionBlock()
	}
}