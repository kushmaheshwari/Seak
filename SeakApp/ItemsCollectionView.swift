//
//  ItemsCollectionView.swift
//  SeakApp
//
//  Created by Roman Volkov on 06/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit

class ItemsCollectionViewController: UICollectionViewController {

	private let reuseIdentifier = "ItemCellIdentifier"
	private let repository = ItemRepository()
	private var category: MenuItems = .None

	var items = [ItemEntity]()
	var searchItems = [ItemEntity]()

	override func viewDidLoad() {
		super.viewDidLoad()

		let nib = UINib(nibName: "ItemCellView", bundle: nil)

		collectionView?.registerNib(nib, forCellWithReuseIdentifier: reuseIdentifier)

		loadCollectionViewData()
	}

	func loadCollectionViewData() { // loading cells with data

		repository.getAllFromCategory(category) { (data) -> Void in
			self.items = data
			print("Successfully retrieved \(data.count) scores.")
			self.collectionView?.reloadData()
		}
	}

	func setCategory(type: MenuItems) {
		self.category = type
	}

	// MARK: UICollectionViewDataSource
	override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}

	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//		if self.searchBarActive {
//			return searchItems.count
//		}
//		else {
		return items.count
//		}

	}

	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ItemCellView

		let item = items[indexPath.row]
		let label = UILabel()
		label.text = item.objectID
		cell.addSubview(label)
		cell.bringSubviewToFront(label)
		label.sizeToFit()
//		cell.itemNameLabel.text = item.name
//		if let price = item.price {
//			cell.priceLabel.text = String(format: "%.1f", price)
//		}
//		cell.productImageView.file = item.picture
//		cell.productImageView.loadInBackground()

		return cell
	}

}
