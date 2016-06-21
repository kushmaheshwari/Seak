//
//  HomeItemsViewController.swift
//  SeakApp
//
//  Created by Roman Volkov on 21/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit

class BannerCell: UITableViewCell {

	@IBOutlet weak var imgVIew: UIView!
}

class GroupCell: UITableViewCell, UICollectionViewDelegate,
UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

	private let repository = ItemRepository()
	private var items: [ItemEntity] = []

	var status: ItemStatus = .None {
		didSet {
//			self.collectionView.dataSource = self
//			self.collectionView.delegate = self
			self.loadItems()
		}
	}

	@IBOutlet weak var groupNameLabel: UILabel!
	@IBOutlet weak var collectionView: UICollectionView!

	func loadItems() {
		repository.getByStatus(self.status) { (items) in
			self.items = items
			dispatch_async(dispatch_get_main_queue(), {
//				self.collectionView.reloadData()
			})
		}
	}

	// collectionView
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}

	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.items.count
	}

	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

		return UICollectionViewCell()
	}
}

class HomeItemsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	private let reusableIdentifier = "groupCellID"
	private let bannerCellIdentifier = "imageCellID"

	private let items = ItemStatus.values

	@IBOutlet weak var tableView: UITableView!

	override func viewDidLoad() {
		super.viewDidLoad()

		self.tableView.delegate = self
		self.tableView.dataSource = self
	}

	// tableView
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count + 1
	}
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

		if indexPath.row == 0 {
			guard let cell = self.tableView.dequeueReusableCellWithIdentifier(bannerCellIdentifier) as? BannerCell else { fatalError("error on creating bannerCell") }
			return cell
		}

		guard let cell = self.tableView.dequeueReusableCellWithIdentifier(reusableIdentifier) as? GroupCell else { fatalError("can't dequeue GroupCell") }
		cell.status = items[indexPath.row - 1]
		return cell

	}
}