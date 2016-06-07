//
//  ItemsCollectionView.swift
//  SeakApp
//
//  Created by Roman Volkov on 06/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit

class ItemsCollectionView: UIView,
UICollectionViewDelegate, UICollectionViewDataSource {

	private let reuseIdentifier = "ItemCellIdentifier"
	private let repository = ItemRepository()

	var items = [ItemEntity]()
	var searchItems = [ItemEntity]()

	@IBOutlet weak var collectionView: UICollectionView!

	override func awakeFromNib() {
		super.awakeFromNib()

		self.collectionView.delegate = self
		self.collectionView.dataSource = self

		loadCollectionViewData()
	}

	func loadCollectionViewData() { // loading cells with data

		repository.getAll() { (data) -> Void in
			self.items = data
			print("Successfully retrieved \(data.count) scores.")
			self.collectionView.reloadData()
		}
	}

	// MARK: UICollectionViewDataSource
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}

	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//		if self.searchBarActive {
//			return searchItems.count
//		}
//		else {
		return items.count
//		}

	}

	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CollectionViewCell

		let item = items[indexPath.row]
		cell.itemNameLabel.text = item.name
		if let price = item.price {
			cell.priceLabel.text = String(format: "%.1f", price)
		}
		cell.productImageView.file = item.picture
		cell.productImageView.loadInBackground()

		return cell
	}

}
