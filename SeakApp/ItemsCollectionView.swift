//
//  ItemsCollectionView.swift
//  SeakApp
//
//  Created by Roman Volkov on 06/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ItemsCollectionViewController: UICollectionViewController {

	fileprivate let reuseIdentifier = "ItemCellIdentifier"
	fileprivate let repository = ItemRepository()
	fileprivate let favoritesRepository = FavoriteRepository()
	fileprivate var category: StoreCategory = .None

	var dataSourceType: ItemsCollectionViewDataSource = .none
	var storeEntity: StoreEntity? = nil

	var items = [ItemEntity]()
	var searchItems = [ItemEntity]()

	var refreshControl: UIRefreshControl!
	weak var navigationVC: UINavigationController? = nil

	override func viewDidLoad() {
		super.viewDidLoad()

		self.collectionView?.backgroundColor = UIColor.colorWithHexString("f5f5f5")

		let nib = UINib(nibName: "ItemCellView", bundle: nil)
		self.collectionView?.register(nib, forCellWithReuseIdentifier: reuseIdentifier)

		self.collectionView?.alwaysBounceVertical = true

		self.refreshControl = UIRefreshControl() // adds refreshing
		self.refreshControl.attributedTitle = NSAttributedString(string: "")
		self.refreshControl.addTarget(self, action: #selector(ItemsCollectionViewController.refresh(_:)), for: UIControlEvents.valueChanged)
		self.collectionView?.addSubview(refreshControl)

		self.loadCollectionViewData()

		self.addObservers()
	}

	deinit {
		self.removeObserver()
	}

	func addObservers() {
		NotificationCenter.default.addObserver(self, selector: #selector(ItemsCollectionViewController.likeNotification(_:)), name: NSNotification.Name(rawValue: LikeItemView.likeItemNotification), object: nil)

		NotificationCenter.default.addObserver(self, selector: #selector(ItemsCollectionViewController.dislikeNotification(_:)), name: NSNotification.Name(rawValue: LikeItemView.dislikeItemNotification), object: nil)

	}

	func removeObserver() {
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: LikeItemView.likeItemNotification), object: nil)
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: LikeItemView.dislikeItemNotification), object: nil)
	}

	func likeNotification(_ notification: Notification) {
		if self.dataSourceType != .favorites {
			return
		}
	}

	func dislikeNotification(_ notification: Notification) {
		if self.dataSourceType != .favorites {
			return
		}

		if let objectID = (notification as NSNotification).userInfo?["itemObjectID"] as? String {
			if let index = self.items.index(where: { $0.objectID == objectID }) {
				self.items.remove(at: index)

				let indexPath = IndexPath(item: index, section: 0)
				self.collectionView?.deleteItems(at: [indexPath])
			}
		}
	}

	func refresh(_ sender: AnyObject) {
		loadCollectionViewData()
		self.refreshControl.endRefreshing()
	}

	func loadCollectionViewData() { // loading cells with data
		self.items.removeAll()
		self.collectionView?.reloadData()

		switch self.dataSourceType {
		case .categories:
			DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.background).async(execute: {
				self.repository.getAllFromCategory(self.category, store: self.storeEntity) { (data) -> Void in
					DispatchQueue.main.async(execute: {
						self.items = data
						print("Successfully retrieved \(data.count) scores.")
						self.refreshControl.endRefreshing()
						self.collectionView?.reloadData()
					})
				}
			})

		case .favorites:
            if FIRAuth.auth()?.currentUser == nil { fatalError("empty current user") }
			
			DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.background).async(execute: {
				self.favoritesRepository.getAllItems({ (data) in
					DispatchQueue.main.async(execute: {
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

	func setCategory(_ type: StoreCategory) {
		self.category = type
	}

	// MARK: UICollectionViewDataSource
	override func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}

	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return items.count
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ItemCellView {
			let item = items[(indexPath as NSIndexPath).row]
			cell.fillCell(item)

			cell.tapExecutionBlock = { (updatedItem) -> Void in
				if let destination = self.storyboard?.instantiateViewController(withIdentifier: StoryboardNames.ItemDetailsView.rawValue) as? ItemDetailsViewConroller {
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
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let screenSize = self.view.bounds
		let widthCell = (screenSize.width - 40) / 2
		let coefficient = widthCell / 250
		return CGSize(width: widthCell, height: 313 * coefficient)
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return CGFloat(8)
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return CGFloat(8)
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
		return CGSize.zero
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		return CGSize.zero
	}

}
