//
//  SearchItemsViewController.swift
//  SeakApp
//
//  Created by Roman Volkov on 10/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit

class SearchItemsViewController: UIViewController,
UISearchBarDelegate, UISearchResultsUpdating,
UICollectionViewDelegate, UICollectionViewDataSource
{

	private let repository = ItemRepository()
	private var items: [ItemEntity] = []
	private let reuseIdentifier = "ItemCellIdentifier"

	var searchController: UISearchController!

	@IBOutlet weak var searchTitleTextLabel: UILabel!
	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var searchItemsCollectionView: UICollectionView!

	override func viewDidLoad() {
		super.viewDidLoad()

		addSearchbar()
		self.searchItemsCollectionView.delegate = self
		self.searchItemsCollectionView.dataSource = self
		let nib = UINib(nibName: "ItemCellView", bundle: nil)
		self.searchItemsCollectionView?.registerNib(nib, forCellWithReuseIdentifier: reuseIdentifier)
		self.searchItemsCollectionView?.alwaysBounceVertical = true
		self.searchItemsCollectionView.backgroundColor = UIColor.whiteColor()

	}

	func addSearchbar() {
		self.searchController = UISearchController(searchResultsController: nil)
		self.searchController.dimsBackgroundDuringPresentation = false
		self.searchController.searchBar.delegate = self
		self.searchController.searchBar.showsCancelButton = true
		self.searchController.searchResultsUpdater = self
		self.searchController.hidesNavigationBarDuringPresentation = false
		self.definesPresentationContext = true
		self.navigationItem.titleView = self.searchController.searchBar
		self.navigationItem.rightBarButtonItem = nil
		self.searchTitleTextLabel.hidden = true
		self.containerView.hidden = true
		self.searchController.searchBar.becomeFirstResponder()
	}

	func addPlainHeader(searchTextValue: String) {
		self.navigationItem.titleView = nil
		self.navigationItem.title = "SEAK"
		let rightBarButton = UIBarButtonItem(image: UIImage(named: "search"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SearchItemsViewController.searchIconTaped(_:)))
		navigationItem.rightBarButtonItem = rightBarButton
		self.searchTitleTextLabel.text = searchTextValue
		self.searchTitleTextLabel.hidden = false
		self.containerView.hidden = false
	}

	func searchIconTaped(sender: UIButton!) {
		self.addSearchbar()
	}

// MARK: SearchBarDelegate
	func searchBarCancelButtonClicked(searchBar: UISearchBar) {

	}
	func searchBarTextDidEndEditing(searchBar: UISearchBar) {
		print("do search")
		items.removeAll()
		self.searchItemsCollectionView.reloadData()
		if let searchTextValue = searchBar.text {
			if searchTextValue.isEmpty {
				return
			}

			addPlainHeader(searchTextValue)
			repository.search(searchTextValue, completion: { (items) in
				self.items = items
				self.searchItemsCollectionView.reloadData()
			})
		}
	}
	func updateSearchResultsForSearchController(searchController: UISearchController) {

	}

	// MARK: collectinview
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}

	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return items.count
	}

	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

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

extension SearchItemsViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		let screenSize = self.searchItemsCollectionView.bounds.size
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

