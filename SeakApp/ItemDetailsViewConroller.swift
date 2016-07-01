//
//  ItemDetailsViewConroller.swift
//  SeakApp
//
//  Created by Roman Volkov on 01/07/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit
import ParseUI

class ItemDetailsViewConroller: UIViewController {

	var itemEntity: ItemEntity? = nil

	@IBOutlet weak var itemImage: PFImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var priceLabel: UILabel!
	@IBOutlet weak var reviewsTitle: UILabel!
	@IBOutlet weak var starsStackView: UIStackView!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var addresslabel: UILabel!

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	func setStars(count: Int) {
		for starView in self.starsStackView.arrangedSubviews {
			if let imgView = starView as? UIImageView {
				imgView.image = UIImage(named: "blankStar")
			}
		}

		for i in 0..<count {
			if let imgView = self.starsStackView.arrangedSubviews[i] as? UIImageView {
				imgView.image = UIImage(named: "filledStar")
			}
		}
	}
}