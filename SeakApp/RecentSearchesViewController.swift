//
//  RecentSearchesViewController.swift
//  SeakApp
//
//  Created by Roman Volkov on 10/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit

typealias RecentSearchesSelectedComplectionBlock = (_ text: String) -> Void

class RecentSearchesViewController: UITableViewController {
	fileprivate let reusableIdentifier = "recentSearchCellID"

	fileprivate var items: [String] = []

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

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Recent"
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = self.tableView.dequeueReusableCell(withIdentifier: reusableIdentifier) {
			cell.textLabel?.text = items[(indexPath as NSIndexPath).row]
			return cell
		}

		return UITableViewCell()
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.selectionCompletionBlock(items[(indexPath as NSIndexPath).row])
	}
}
