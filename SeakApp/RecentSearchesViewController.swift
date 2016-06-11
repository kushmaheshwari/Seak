//
//  RecentSearchesViewController.swift
//  SeakApp
//
//  Created by Roman Volkov on 10/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit

typealias RecentSearchesSelectedComplectionBlock = (text: String) -> Void

class RecentSearchesViewController: UITableViewController {
	private let reusableIdentifier = "recentSearchCellID"

	private var items: [String] = []

	var selectionCompletionBlock: RecentSearchesSelectedComplectionBlock = { (_) in }

	func reload() {
		self.items = RecentSearches.getAll()
		self.tableView.reloadData()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.items = RecentSearches.getAll()
		self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension
		self.tableView.estimatedSectionHeaderHeight = 25
	}

	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Recent"
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if let cell = self.tableView.dequeueReusableCellWithIdentifier(reusableIdentifier) {
			cell.textLabel?.text = items[indexPath.row]
			return cell
		}

		return UITableViewCell()
	}

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		self.selectionCompletionBlock(text: items[indexPath.row])
	}
}