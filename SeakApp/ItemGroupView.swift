//
//  ItemGroupView.swift
//  SeakApp
//
//  Created by Roman Volkov on 23/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit

class ItemGroupView: UICollectionViewCell {
	@IBOutlet weak var discountLabel: UILabel!
	@IBOutlet weak var imgView: UIImageView!

	var item = ItemEntity()
	var tapExecutionBlock: (_ updatedItem: ItemEntity) -> Void = { _ in }
    fileprivate let storeRepository = StoreRepository()

	fileprivate var tapped: Bool = false

	override func awakeFromNib() {
		super.awakeFromNib()
		let tap = UITapGestureRecognizer(target: self, action: #selector(ItemGroupView.openDetails(_:)))

		tap.numberOfTouchesRequired = 1
		self.addGestureRecognizer(tap)
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
