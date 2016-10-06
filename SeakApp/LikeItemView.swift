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
	fileprivate let repository = FavoriteRepository()
	fileprivate var favoriteItem: FavoriteItem? = nil
	fileprivate var tapped: Bool = false

	var item: ItemEntity? = nil

	static let likeItemNotification = String(describing: LikeItemView.self) + "_like"
	static let dislikeItemNotification = String(describing: LikeItemView.self) + "_dislike"

	override func awakeFromNib() {
		super.awakeFromNib()
		self.likeImage.isHidden = true
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

	func tap(_ sender: AnyObject?) {
		if (self.tapped) {
			return
		}
		self.tapped = true
		if self.favoriteItem == nil { // means neeed to like it and retrieve favoriteItem
			self.repository.like(self.item!, completion: { (favoriteItem) in
				self.favoriteItem = favoriteItem
				self.setImage()
				self.tapped = false

				let dict: [AnyHashable: Any]? = ["itemObjectID": self.item!.objectID!]
				NotificationCenter.default.post(name: Notification.Name(rawValue: LikeItemView.likeItemNotification), object: nil, userInfo: dict)

			})
		} else {
			self.repository.dislike(self.favoriteItem!.itemId, successBlock: { (success) in
				if (success) {
					let dict: [AnyHashable: Any]? = ["itemObjectID": self.item!.objectID!]
					NotificationCenter.default.post(name: Notification.Name(rawValue: LikeItemView.dislikeItemNotification), object: nil, userInfo: dict)

					self.favoriteItem = nil
					self.setImage()
					self.tapped = false
				}
			})
		}
	}

	func setImage() {
		self.likeImage.isHidden = false
		if self.favoriteItem != nil {
			self.likeImage.image = UIImage(named: "like")
		} else {
			self.likeImage.image = UIImage(named: "dislike")
		}
	}
}
