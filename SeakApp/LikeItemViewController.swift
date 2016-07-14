//
//  LikeItemViewController.swift
//  SeakApp
//
//  Created by Roman Volkov on 14/07/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit

class LikeItemViewController: UIViewController {

	@IBOutlet weak var likeImage: UIImageView!
	private let repository = FavoriteRepository()
	private var favoriteItem: FavoriteItem? = nil

	var item: ItemEntity? = nil

	override func viewDidLoad() {
		super.viewDidLoad()
		guard let _ = self.item else { fatalError("empty Item Entity") }
		repository.getLike(by: self.item!) { (item) in
			self.favoriteItem = item
		}

		let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(LikeItemViewController.tap(_:)))
		self.view.addGestureRecognizer(tapRecognizer)
	}

	func tap(sender: AnyObject?) {
		if self.favoriteItem == nil {
			self.repository.like(self.item!, completion: { (favoriteItem) in
				self.favoriteItem = favoriteItem
				self.setImage()
			})
		} else {
			self.repository.dislike(self.favoriteItem!, successBlock: { (success) in
				if (success) {
					self.favoriteItem = nil
					self.setImage()
				}
			})
		}
	}

	func setImage() {
		if self.favoriteItem == nil {
			self.likeImage.image = UIImage(named: "like")
		} else {
			self.likeImage.image = UIImage(named: "dislike")
		}
	}
}