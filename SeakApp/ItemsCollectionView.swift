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

		self.collectionView?.backgroundColor = UIColor.whiteColor()

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
		return items.count
	}

	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

		if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as? ItemCellView {

			let backColor = (indexPath.row % 4 == 0 || indexPath.row % 4 == 3) ? UIColor.lightGrayColor() : UIColor.whiteColor()
			cell.backgroundColor = backColor
			cell.pictureImage?.layer.backgroundColor = backColor.CGColor

			let item = items[indexPath.row]
			cell.nameLabel.text = item.name
			cell.storeLabel.text = item.store

			if let price = item.price {
				cell.priceLabel.text = String(format: "%.1f$", price)
			}

			cell.pictureImage.file = item.picture
			cell.pictureImage.loadInBackground({ (img, error) in
				cell.pictureImage.image = img
				cell.pictureImage.setNeedsDisplay()
			})
			cell.layoutSubviews()
			cell.sizeToFit()
			return cell
		}
		return UICollectionViewCell()
	}

}

extension ItemsCollectionViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		let screenSize = self.view.bounds
		return CGSize(width: screenSize.width / 2, height: screenSize.width / 2 / 0.8)
	}
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
		return UIEdgeInsetsZero
	}
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
		return CGFloat(0)
	}
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
		return CGFloat(0)
	}
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
		return CGSizeZero
	}
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		return CGSizeZero
	}

}
