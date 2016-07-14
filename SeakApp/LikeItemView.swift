//
//  LikeItemViewController.swift
//  SeakApp
//
//  Created by Roman Volkov on 14/07/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit

class LikeItemView: UIView {

	@IBOutlet weak var likeImage: UIImageView!
	private let repository = FavoriteRepository()
	private var favoriteItem: FavoriteItem? = nil
	private var tapped: Bool = false

	var item: ItemEntity? = nil

	override func awakeFromNib() {
		super.awakeFromNib()
		self.likeImage.hidden = true
		let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(LikeItemView.tap(_:)))
		self.addGestureRecognizer(tapRecognizer)
	}

	func load() {
		guard let _ = self.item else { fatalError("empty Item Entity") }
		repository.getLike(by: self.item!) { (item) in
			self.favoriteItem = item
			self.setImage()
		}
	}

	func tap(sender: AnyObject?) {
		if (self.tapped) {
			return
		}
		self.tapped = true
		if self.favoriteItem == nil { // means neeed to like it and retrieve favoriteItem
			self.repository.like(self.item!, completion: { (favoriteItem) in
				self.favoriteItem = favoriteItem
				self.setImage()
				self.tapped = false
			})
		} else {
			self.repository.dislike(self.favoriteItem!, successBlock: { (success) in
				if (success) {
					self.favoriteItem = nil
					self.setImage()
					self.tapped = false
				}
			})
		}
	}

	func setImage() {
		self.likeImage.hidden = false
		if self.favoriteItem != nil {
			self.likeImage.image = UIImage(named: "like")
		} else {
			self.likeImage.image = UIImage(named: "dislike")
		}
	}
}