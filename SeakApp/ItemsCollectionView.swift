//
//  ItemsCollectionView.swift
//  SeakApp
//
//  Created by Roman Volkov on 06/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import Parse
import UIKit

class ItemsCollectionViewController: UICollectionViewController {

	private let reuseIdentifier = "ItemCellIdentifier"
	private let repository = ItemRepository()
	private let favoritesRepository = FavoriteRepository()
	private var category: StoreCategory = .None

	var dataSourceType: ItemsCollectionViewDataSource = .None
	var storeEntity: StoreEntity? = nil

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

		self.loadCollectionViewData()

		self.addObservers()
	}

	deinit {
		self.removeObserver()
	}

	func addObservers() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ItemsCollectionViewController.likeNotification(_:)), name: LikeItemView.likeItemNotification, object: nil)

		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ItemsCollectionViewController.dislikeNotification(_:)), name: LikeItemView.dislikeItemNotification, object: nil)

	}

	func removeObserver() {
		NSNotificationCenter.defaultCenter().removeObserver(self, name: LikeItemView.likeItemNotification, object: nil)
		NSNotificationCenter.defaultCenter().removeObserver(self, name: LikeItemView.dislikeItemNotification, object: nil)
	}

	func likeNotification(notification: NSNotification) {
		if self.dataSourceType != .Favorites {
			return
		}
	}

	func dislikeNotification(notification: NSNotification) {
		if self.dataSourceType != .Favorites {
			return
		}

		if let objectID = notification.userInfo?["itemObjectID"] as? String {
			if let index = self.items.indexOf({ $0.objectID == objectID }) {
				self.items.removeAtIndex(index)

				let indexPath = NSIndexPath(forItem: index, inSection: 0)
				self.collectionView?.deleteItemsAtIndexPaths([indexPath])
			}
		}
	}

	func refresh(sender: AnyObject) {
		loadCollectionViewData()
		self.refreshControl.endRefreshing()
	}

	func loadCollectionViewData() { // loading cells with data
		self.items.removeAll()
		self.collectionView?.reloadData()

		switch self.dataSourceType {
		case .Categories:
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
				self.repository.getAllFromCategory(self.category, store: self.storeEntity) { (data) -> Void in
					dispatch_async(dispatch_get_main_queue(), {
						self.items = data
						print("Successfully retrieved \(data.count) scores.")
						self.refreshControl.endRefreshing()
						self.collectionView?.reloadData()
					})
				}
			})

		case .Favorites:
			guard let currentUser = PFUser.currentUser() else { fatalError("empty current user") }
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
				self.favoritesRepository.getAllItems(by: currentUser, completion: { (data) in
					dispatch_async(dispatch_get_main_queue(), {
						self.items = data
						print("Successfully retrieved \(data.count) scores.")
						self.refreshControl.endRefreshing()
						self.collectionView?.reloadData()
					})
				})
			})
		default:
			fatalError("uncatched source type")
		}

	}

	func setCategory(type: StoreCategory) {
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
