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
	weak var navigationVC: UINavigationController? = nil
	override func viewDidLoad() {
		super.viewDidLoad()

		self.collectionView?.backgroundColor = UIColor.colorWithHexString("f5f5f5")

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
			let item = items[indexPath.row]
			cell.fillCell(item)

			cell.tapExecutionBlock = { (updatedItem) -> Void in
				if let destination = self.storyboard?.instantiateViewControllerWithIdentifier(StoryboardNames.ItemDetailsView.rawValue) as? ItemDetailsViewConroller {
					destination.itemEntity = updatedItem
					self.navigationVC?.pushViewController(destination, animated: true)
				}
			}

			return cell
		}
		return UICollectionViewCell()
	}

}

extension ItemsCollectionViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		let screenSize = self.view.bounds
		let widthCell = (screenSize.width - 40) / 2
		let coefficient = widthCell / 250
		return CGSize(width: widthCell, height: 313 * coefficient)
	}
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
	}
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
		return CGFloat(8)
	}
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
		return CGFloat(8)
	}
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
		return CGSizeZero
	}
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		return CGSizeZero
	}

}
