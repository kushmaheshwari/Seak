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
UISearchBarDelegate, UISearchResultsUpdating {

	var searchController: UISearchController!

	@IBOutlet weak var searchTitleTextLabel: UILabel!
	@IBOutlet weak var containerView: UIView!

	override func viewDidLoad() {
		super.viewDidLoad()

		addSearchbar()
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
		print("canceled")
	}
	func searchBarTextDidEndEditing(searchBar: UISearchBar) {
		print("do search")
		if let searchTextValue = searchBar.text {
			addPlainHeader(searchTextValue)
		}
	}
	func updateSearchResultsForSearchController(searchController: UISearchController) {

	}
}
