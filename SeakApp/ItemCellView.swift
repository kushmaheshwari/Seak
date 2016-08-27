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

	@IBOutlet weak var pictureImage: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var priceLabel: UILabel!
	@IBOutlet weak var starsStackView: UIStackView!
	@IBOutlet weak var likeViewController: UIView!

	var tapExecutionBlock: (updatedItem: ItemEntity) -> Void = { _ in }

	private var item = ItemEntity()
	private var tapped: Bool = false
	private let reviewRepository = ReviewRepository()
    private let storeRepository = StoreRepository()

	override func awakeFromNib() {
		super.awakeFromNib()
	}

	func fillCell(item: ItemEntity) {
		self.backgroundColor = UIColor.whiteColor()
		self.pictureImage?.layer.backgroundColor = UIColor.whiteColor().CGColor

		self.item = item

		self.likeViewController.backgroundColor = UIColor.clearColor()
		if let v = NSBundle.mainBundle().loadNibNamed("LikeItemView", owner: self, options: nil)[0] as? LikeItemView {
			v.item = self.item

			self.likeViewController.addSubview(v)
			self.bringSubviewToFront(self.likeViewController)
			self.likeViewController.bringSubviewToFront(v)
			v.load()
		}

		self.starsStackView.backgroundColor = UIColor.colorWithHexString("21c2f8")

		self.nameLabel.text = item.name

		if let price = item.price {
			self.priceLabel.text = String(format: "$%.1f", price)
		}
		
        if let url = self.item.picture {
            self.pictureImage.downloadWithCache(url)
            self.pictureImage.setNeedsDisplay()
        }
        
        self.starsStackView.setStars(Int(self.item.avgRating ?? 0))
        
		let tap = UITapGestureRecognizer(target: self, action: #selector(ItemCellView.openDetails(_:)))
		tap.numberOfTouchesRequired = 1
		self.addGestureRecognizer(tap)
		self.layoutSubviews()
		self.sizeToFit()

	}

	func openDetails(gesture: UITapGestureRecognizer?) {
		if tapped {
			return
		}
		tapped = true
		if let storeId = item.storeId {
            self.storeRepository.getById(storeId, completion: { (store) in
                self.item.storeEntity = store
                NSOperationQueue.mainQueue().addOperationWithBlock({ 
                    self.tapExecutionBlock(updatedItem: self.item)
                    self.tapped = false
                })
            })
		}

	}

}
