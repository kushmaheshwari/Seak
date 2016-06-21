//
//  HomeItemsViewController.swift
//  SeakApp
//
//  Created by Roman Volkov on 21/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit

class GroupCell: UITableViewCell, UICollectionViewDelegate,
UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

	private let repository = ItemRepository()
	private var items: [ItemEntity] = []

	var status: ItemStatus = .None

	@IBOutlet weak var groupNameLabel: UILabel!
	@IBOutlet weak var collectionView: UICollectionView!

	override func awakeFromNib() {
		super.awakeFromNib()
		self.collectionView.dataSource = self
		self.collectionView.delegate = self
	}

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

		return UICollectionViewCell()
	}
}

class HomeItemsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	private let reusableIdentifier = "groupCellID"

	private let items = ItemStatus.values

	@IBOutlet weak var tableView: UITableView!

	override func viewDidLoad() {
		super.viewDidLoad()

		self.tableView.delegate = self
		self.tableView.dataSource = self
	}

	// tableView
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 0
	}
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		return UITableViewCell()
	}
}