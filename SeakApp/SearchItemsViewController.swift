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

	fileprivate let repository = ItemRepository()
	fileprivate var items: [ItemEntity] = []
	fileprivate let reuseIdentifier = "ItemCellIdentifier"
    
    var storeObject: StoreEntity? = nil
	var searchFromTyping = false
	var searchController: UISearchController!
	fileprivate var recentSearches: RecentSearchesViewController!

	@IBOutlet weak var searchTitleTextLabel: UILabel!
	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var searchItemsCollectionView: UICollectionView!

	override func viewDidLoad() {
		super.viewDidLoad()

		self.navigationItem.hidesBackButton = false
		self.edgesForExtendedLayout = UIRectEdge()

		self.recentSearches = self.storyboard?.instantiateViewController(withIdentifier: StoryboardNames.RecentSearches.rawValue) as! RecentSearchesViewController
		addSearchbar()
		self.searchItemsCollectionView.delegate = self
		self.searchItemsCollectionView.dataSource = self
		let nib = UINib(nibName: "ItemCellView", bundle: nil)
		self.searchItemsCollectionView?.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
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
		self.searchTitleTextLabel.isHidden = true
		self.containerView.isHidden = true
		// recent controller

		self.recentSearches.selectionCompletionBlock = { (text) in
			self.searchController.searchBar.text = text
			self.searchFromTyping = false
			self.searchBarTextDidEndEditing(self.searchController.searchBar)
			self.recentSearches.view.removeFromSuperview()
		}

		self.recentSearches.reload()
		self.view.addSubview(self.recentSearches.view)
		self.view.sendSubview(toBack: self.recentSearches.view)

	}

	func addPlainHeader(_ searchTextValue: String) {
		let titleImage = UIImage(named: "navBarLogo")
		let imgView = UIImageView(image: titleImage)
		imgView.frame = CGRect(x: 0, y: 0, width: 50, height: 25)
		imgView.contentMode = .scaleAspectFit
		self.title = ""
		self.navigationItem.titleView = imgView
		let rightBarButton = UIBarButtonItem(image: UIImage(named: "searchIcon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(SearchItemsViewController.searchIconTaped(_:)))
		navigationItem.rightBarButtonItem = rightBarButton
		self.searchTitleTextLabel.text = searchTextValue
		self.searchTitleTextLabel.isHidden = false
		self.containerView.isHidden = false
	}

	func searchIconTaped(_ sender: UIButton!) {
		self.addSearchbar()
	}

// MARK: SearchBarDelegate
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

	}

	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		self.searchFromTyping = true
	}
	func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		print("do search")
		self.recentSearches.view.removeFromSuperview()
		items.removeAll()
		self.searchItemsCollectionView.reloadData()
		if let searchTextValue = searchBar.text {
			if searchTextValue.isEmpty {
				return
			}

			addPlainHeader(searchTextValue)
			repository.search(searchTextValue, store: storeObject, completion: { (items) in
				self.items = items
				self.searchItemsCollectionView.reloadData()
				if (self.searchFromTyping) {
					RecentSearches.add(searchTextValue)
				}
			})
		}
	}
	func updateSearchResults(for searchController: UISearchController) {

	}

	// MARK: collectinview
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return items.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ItemCellView {
			let item = items[(indexPath as NSIndexPath).row]
			cell.fillCell(item)

			cell.tapExecutionBlock = { (updatedItem) -> Void in
				if let destination = self.storyboard?.instantiateViewController(withIdentifier: StoryboardNames.ItemDetailsView.rawValue) as? ItemDetailsViewConroller {
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
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let screenSize = self.searchItemsCollectionView.bounds
		let width = screenSize.width - 40
		return CGSize(width: width / 2, height: width / 2 / 0.8)
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

