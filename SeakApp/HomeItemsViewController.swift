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

	static let reusableIdentifier = "groupCellID"

	private let repository = ItemRepository()
	private var items: [ItemEntity] = []
	private let collectionViewReusableIdentifier = "ItemGroupViewID"

	var status: ItemStatus = .None {
		didSet {
			self.groupNameLabel.text? = ItemStatus.StatusGroupNames[status]!
			self.loadItems()
		}
	}

	override func awakeFromNib() {
		super.awakeFromNib()
		self.collectionView.dataSource = self
		self.collectionView.delegate = self

		let nib = UINib(nibName: "ItemGroupView", bundle: nil)
		self.collectionView?.registerNib(nib, forCellWithReuseIdentifier: self.collectionViewReusableIdentifier)
	}

	@IBOutlet weak var groupNameLabel: UILabel!
	@IBOutlet weak var collectionView: UICollectionView!

	func loadItems() {
		repository.getByStatus(self.status) { (items) in
			self.items = items
			dispatch_async(dispatch_get_main_queue(), {
				self.collectionView.reloadData()
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

		if let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier(self.collectionViewReusableIdentifier, forIndexPath: indexPath) as? ItemGroupView
		{
			cell.discountLabel.hidden = true
			cell.imgView.file = self.items[indexPath.row].picture
			cell.imgView.loadInBackground()
			return cell
		}
		return UICollectionViewCell()
	}

	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		let side = self.collectionView.contentSize.height
		return CGSize(width: side, height: side)
	}
}

class HomeItemsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
			guard let cell = self.tableView.dequeueReusableCellWithIdentifier(self.bannerCellIdentifier) as? BannerCell else { fatalError("error on creating bannerCell") }
			return cell
		}

		guard let cell = self.tableView.dequeueReusableCellWithIdentifier(GroupCell.reusableIdentifier) as? GroupCell else { fatalError("can't dequeue GroupCell") }
		cell.status = items[indexPath.row - 1]
		return cell

	}
}