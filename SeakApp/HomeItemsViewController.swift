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

	fileprivate let repository = ItemRepository()
	fileprivate var items: [ItemEntity] = []
	fileprivate let collectionViewReusableIdentifier = "ItemGroupViewID"

	var storeEntity: StoreEntity? = nil

	weak var storyboard: UIStoryboard? = nil
	weak var navigationController: UINavigationController? = nil

	var status: ItemStatus = .None {
		didSet {
			self.groupNameLabel.text? = ItemStatus.StatusGroupNames[status]!
			self.loadItems()
		}
	}
    
    func reset() {
        self.items.removeAll()
        self.loadItems()
    }

	override func awakeFromNib() {
		super.awakeFromNib()
		self.collectionView.dataSource = self
		self.collectionView.delegate = self

		let nib = UINib(nibName: "ItemGroupView", bundle: nil)
		self.collectionView?.register(nib, forCellWithReuseIdentifier: self.collectionViewReusableIdentifier)
	}

	@IBOutlet weak var groupNameLabel: UILabel!
	@IBOutlet weak var collectionView: UICollectionView!

	func loadItems() {
		repository.getByStatus(self.status, store: self.storeEntity) { (items) in
			self.items = items
			DispatchQueue.main.async(execute: {
				self.collectionView.reloadData()
			})
		}
	}

	// collectionView
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.items.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		if let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: self.collectionViewReusableIdentifier, for: indexPath) as? ItemGroupView
		{
            cell.imgView.image = nil
            cell.tapExecutionBlock = { _ in }
            
			cell.discountLabel.isHidden = true
            if let url = self.items[(indexPath as NSIndexPath).row].picture {
                cell.imgView.downloadWithCache(urlString: url)
            }
			
			cell.item = self.items[(indexPath as NSIndexPath).row]
            

			cell.tapExecutionBlock = { (updatedItem) -> Void in
				let storyboard = UIStoryboard(name: "Main", bundle: nil)
				if let destination = storyboard.instantiateViewController(withIdentifier: StoryboardNames.ItemDetailsView.rawValue) as? ItemDetailsViewConroller {
					destination.itemEntity = updatedItem
					self.navigationController?.pushViewController(destination, animated: true)
				}
			}
            
            cell.setNeedsDisplay()
            cell.setNeedsLayout()
			return cell
		}
		return UICollectionViewCell()
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let side = self.collectionView.contentSize.height
		return CGSize(width: side, height: side)
	}
}

class HomeItemsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	fileprivate let bannerCellIdentifier = "imageCellID"
	fileprivate let items = ItemStatus.values

	var storeEntity: StoreEntity? = nil

	weak var navigationVC: UINavigationController? = nil

	@IBOutlet weak var tableView: UITableView!

	override func viewDidLoad() {
		super.viewDidLoad()

		self.tableView.delegate = self
		self.tableView.dataSource = self
	}

	// tableView
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count + 1
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		if (indexPath as NSIndexPath).row == 0 {
			guard let cell = self.tableView.dequeueReusableCell(withIdentifier: self.bannerCellIdentifier) as? BannerCell else { fatalError("error on creating bannerCell") }
			return cell
		}

		guard let cell = self.tableView.dequeueReusableCell(withIdentifier: GroupCell.reusableIdentifier) as? GroupCell else { fatalError("can't dequeue GroupCell") }
        
		cell.navigationController = self.navigationVC
		cell.storeEntity = self.storeEntity
		cell.status = items[(indexPath as NSIndexPath).row - 1]
        cell.reset()
		return cell

	}
}
