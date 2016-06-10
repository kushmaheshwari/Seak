//
//  RecentSearchesViewController.swift
//  SeakApp
//
//  Created by Roman Volkov on 10/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit

class RecentSearchesViewController: UITableViewController {
	private let reusableIdentifier = "recentSearchCellID"

	private var items: [String] = []

	override func viewDidLoad() {
		super.viewDidLoad()
		self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension
		self.tableView.estimatedSectionHeaderHeight = 25

		self.items = RecentSearches.getAll()
	}
}