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
	var searchFromTyping = false
	var searchController: UISearchController!
	private var recentSearches: RecentSearchesViewController!

	@IBOutlet weak var searchTitleTextLabel: UILabel!
	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var searchItemsCollectionView: UICollectionView!

	override func viewDidLoad() {
		super.viewDidLoad()

		self.navigationItem.hidesBackButton = false
		self.edgesForExtendedLayout = .None

		self.recentSearches = self.storyboard?.instantiateViewControllerWithIdentifier(StoryboardNames.RecentSearches.rawValue) as! RecentSearchesViewController
		addSearchbar()
		self.searchItemsCollectionView.delegate = self
		self.searchItemsCollectionView.dataSource = self
		let nib = UINib(nibName: "ItemCellView", bundle: nil)
		self.searchItemsCollectionView?.registerNib(nib, forCellWithReuseIdentifier: reuseIdentifier)
		self.searchItemsCollectionView?.alwaysBounceVertical = true
		self.searchItemsCollectionView.backgroundColor = UIColor.colorWithHexString("f5f5f5")

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
		// recent controller

		self.recentSearches.selectionCompletionBlock = { (text) in
			self.searchController.searchBar.text = text
			self.searchFromTyping = false
			self.searchBarTextDidEndEditing(self.searchController.searchBar)
			self.recentSearches.view.removeFromSuperview()
		}

		self.recentSearches.reload()
		self.view.addSubview(self.recentSearches.view)
		self.view.sendSubviewToBack(self.recentSearches.view)

	}

	func addPlainHeader(searchTextValue: String) {
		let titleImage = UIImage(named: "navBarLogo")
		let imgView = UIImageView(image: titleImage)
		imgView.frame = CGRectMake(0, 0, 50, 25)
		imgView.contentMode = .ScaleAspectFit
		self.title = ""
		self.navigationItem.titleView = imgView
		let rightBarButton = UIBarButtonItem(image: UIImage(named: "searchIcon"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SearchItemsViewController.searchIconTaped(_:)))
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

	func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
		self.searchFromTyping = true
	}
	func searchBarTextDidEndEditing(searchBar: UISearchBar) {
		print("do search")
		self.recentSearches.view.removeFromSuperview()
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
				if (self.searchFromTyping) {
					RecentSearches.add(searchTextValue)
				}
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
			let item = items[indexPath.row]
			cell.fillCell(item)

			cell.tapExecutionBlock = { (updatedItem) -> Void in
				if let destination = self.storyboard?.instantiateViewControllerWithIdentifier(StoryboardNames.ItemDetailsView.rawValue) as? ItemDetailsViewConroller {
					destination.itemEntity = updatedItem
					self.navigationController?.pushViewController(destination, animated: true)
				}
			}

			return cell
		}
		return UICollectionViewCell()
	}
}

extension SearchItemsViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		let screenSize = self.searchItemsCollectionView.bounds
		let width = screenSize.width - 40
		return CGSize(width: width / 2, height: width / 2 / 0.8)
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

