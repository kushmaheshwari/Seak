//
//  ItemCellView.swift
//  SeakApp
//
//  Created by Roman Volkov on 06/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit

class ItemCellView: UICollectionViewCell {

	@IBOutlet weak var pictureImage: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var priceLabel: UILabel!
	@IBOutlet weak var starsStackView: UIStackView!
	@IBOutlet weak var likeViewController: UIView!

	var tapExecutionBlock: (_ updatedItem: ItemEntity) -> Void = { _ in }

	fileprivate var item = ItemEntity()
	fileprivate var tapped: Bool = false
	fileprivate let reviewRepository = ReviewRepository()
    fileprivate let storeRepository = StoreRepository()

	override func awakeFromNib() {
		super.awakeFromNib()
	}

	func fillCell(_ item: ItemEntity) {
		self.backgroundColor = UIColor.white
		self.pictureImage?.layer.backgroundColor = UIColor.white.cgColor

		self.item = item

		self.likeViewController.backgroundColor = UIColor.clear
		if let v = Bundle.main.loadNibNamed("LikeItemView", owner: self, options: nil)?[0] as? LikeItemView {
			v.item = self.item

			self.likeViewController.addSubview(v)
			self.bringSubview(toFront: self.likeViewController)
			self.likeViewController.bringSubview(toFront: v)
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

	func openDetails(_ gesture: UITapGestureRecognizer?) {
		if tapped {
			return
		}
		tapped = true
		if let storeId = item.storeId {
            self.storeRepository.getById(storeId, completion: { (store) in
                self.item.storeEntity = store
                OperationQueue.main.addOperation({ 
                    self.tapExecutionBlock(self.item)
                    self.tapped = false
                })
            })
		}

	}

}
