//
//  StoresViewController.swift
//  SeakApp
//
//  Created by Roman Volkov on 21/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit

class StoresViewCellController: UICollectionViewCell
{
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
}

class StoresViewController: UIViewController, UICollectionViewDataSource {

	@IBOutlet weak var collectionView: UICollectionView!
	var storeArray: [StoreEntity] = []
	private let repository = StoreRepository()
	private let collectionCellId = "StoreCellID"
	var refreshControl: UIRefreshControl!

	override func viewDidLoad() {
		super.viewDidLoad()

		self.refreshControl = UIRefreshControl()
		self.refreshControl.attributedTitle = NSAttributedString(string: "")
		self.refreshControl.addTarget(self, action: #selector(ItemsCollectionViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
		self.collectionView?.addSubview(refreshControl)

		collectionView.dataSource = self
		loadCollectionViewDataCell()
	}

	func refresh(sender: AnyObject)
	{
		loadCollectionViewDataCell()
		self.refreshControl.endRefreshing()
	}

	func loadCollectionViewDataCell()
	{
		repository.getAll { (items) in

			self.storeArray = items
			self.collectionView.reloadData()
		}
	}

	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return storeArray.count
	}

	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(collectionCellId, forIndexPath: indexPath) as? StoresViewCellController
		{
			cell.titleLabel.text = storeArray[indexPath.row].name
			cell.descriptionLabel.text = storeArray[indexPath.row].description
			return cell
		}
		return UICollectionViewCell()
	}

	@IBAction func menuIceonPressed(sender: AnyObject) {
		self.slideMenuController()?.openLeft()
	}
	@IBAction func searchIconPressed(sender: AnyObject) {
	}
}