//
//  AddStoreView.swift
//  SeakApp
//
//  Created by Roman Volkov on 15/07/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit

class AddStoreView: UIView {

	@IBOutlet weak var addImg: UIImageView!

	private let repository = FavoriteRepository()
	private var favoriteStore: FavoriteStore? = nil
	private var tapped: Bool = false

	var store: StoreEntity? = nil
	static let addStoreNotification = String(self) + "_add"
	static let removeStoreNotification = String(self) + "_remove"

	override func awakeFromNib() {
		super.awakeFromNib()
		self.addImg.hidden = true
		let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddStoreView.tap(_:)))
		tapRecognizer.numberOfTapsRequired = 1
		self.userInteractionEnabled = true
		self.addGestureRecognizer(tapRecognizer)
	}

	func load() {
		guard let _ = self.store else { fatalError("empty Store Entity") }
		repository.getStatus(by: self.store!) { (item) in
			self.favoriteStore = item
			self.setImage()
		}
	}

	func tap(sender: AnyObject?) {
		if (self.tapped) {
			return
		}
		self.tapped = true
		if self.favoriteStore == nil { // means neeed to like it and retrieve favoriteStore
			self.repository.add(self.store!, completion: { (favoriteStore) in
				self.favoriteStore = favoriteStore
				self.setImage()
				self.tapped = false
				let dict: [NSObject: AnyObject]? = ["storeObjectID": self.store!.objectID!]
				NSNotificationCenter.defaultCenter().postNotificationName(AddStoreView.addStoreNotification, object: nil, userInfo: dict)
			})
		} else {
			self.repository.remove(self.favoriteStore!, successBlock: { (success) in
				if (success) {
					let dict: [NSObject: AnyObject]? = ["storeObjectID": self.store!.objectID!]
					NSNotificationCenter.defaultCenter().postNotificationName(AddStoreView.removeStoreNotification, object: nil, userInfo: dict)
					self.favoriteStore = nil
					self.setImage()
					self.tapped = false
				}
			})
		}
	}

	func setImage() {
		self.addImg.hidden = false
		if self.favoriteStore != nil {
			self.addImg.image = UIImage(named: "checkmarksvg")
		} else {
			self.addImg.image = UIImage(named: "plussignsvg")
		}
	}
}