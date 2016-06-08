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

	var refreshControl: UIRefreshControl!

	override func viewDidLoad() {
		super.viewDidLoad()

		let nib = UINib(nibName: "ItemCellView", bundle: nil)
		self.collectionView?.registerNib(nib, forCellWithReuseIdentifier: reuseIdentifier)

		self.collectionView?.alwaysBounceVertical = true

		self.refreshControl = UIRefreshControl() // adds refreshing
		self.refreshControl.attributedTitle = NSAttributedString(string: "")
		self.refreshControl.addTarget(self, action: #selector(ItemsCollectionViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
		self.collectionView?.addSubview(refreshControl)

		loadCollectionViewData()
	}

	func refresh(sender: AnyObject) {
		loadCollectionViewData()
		self.refreshControl.endRefreshing()
	}

	func loadCollectionViewData() { // loading cells with data
		self.items.removeAll()
		self.collectionView?.reloadData()
		repository.getAllFromCategory(category) { (data) -> Void in
			self.items = data
			print("Successfully retrieved \(data.count) scores.")
			self.refreshControl.endRefreshing()
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

		if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as? ItemCellView {

			let item = items[indexPath.row]

//		cell.itemNameLabel.text = item.name
//		if let price = item.price {
//			cell.priceLabel.text = String(format: "%.1f", price)
//		}
//		cell.productImageView.file = item.picture
//		cell.productImageView.loadInBackground()

			return cell
		}
		return UICollectionViewCell()
	}

}
