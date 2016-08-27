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
	@IBOutlet weak var imgView: UIImageView!

	var item = ItemEntity()
	var tapExecutionBlock: (updatedItem: ItemEntity) -> Void = { _ in }
    private let storeRepository = StoreRepository()

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