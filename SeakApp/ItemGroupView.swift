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

	var item = ItemEntity()

	var tapExecutionBlock: (updatedItem: ItemEntity) -> Void = { _ in }

	private var tapped: Bool = false

	override func awakeFromNib() {
		super.awakeFromNib()
		let tap = UITapGestureRecognizer(target: self, action: #selector(ItemGroupView.openDetails(_:)))

		tap.numberOfTouchesRequired = 1
		self.addGestureRecognizer(tap)
	}

	func openDetails(gesture: UITapGestureRecognizer?) {
		if tapped {
			return
		}
		tapped = true
		if let storeObject = item.store {
			storeObject.fetchInBackgroundWithBlock({ (object, error) in
				if error != nil {
					fatalError("Error on parsing store for \(self.item)")
				}
				let store = StoreRepository.processStore(object!)
				self.item.storeEntity = store
				dispatch_async(dispatch_get_main_queue(), {
					self.tapExecutionBlock(updatedItem: self.item)
					self.tapped = false
				})

			})
		}
	}
}