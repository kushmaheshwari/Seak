//
//  StoreDetailsMainViewController.swift
//  SeakApp
//
//  Created by Roman Volkov on 21/07/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit

class StoreDetailsMainViewController: UIViewController {

	@IBOutlet weak var scrollableTabs: ScrollableMenu!
	weak var navigationVC: UINavigationController!
	weak var storeEntity: StoreEntity? = nil

	private var views: [UIViewController] = []

	override func viewDidLoad() {
		super.viewDidLoad()
		self.setTitle()
	}

	deinit {
		self.navigationVC = nil
		self.storeEntity = nil
	}

	func setTitle() {
		guard let titleView = NSBundle.mainBundle().loadNibNamed("StoresNavigationTitle", owner: nil, options: nil)[0] as? StoreNavigationTitleView else { fatalError("Can't init StoresNavigationTitle") }

		titleView.titleView.text = self.storeEntity?.name

		self.navigationItem.title = nil
		self.navigationItem.titleView = titleView

		let rightBarButton = UIBarButtonItem(image: UIImage(named: "searchIcon"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(HomeViewController.addItem(_:)))
		navigationItem.rightBarButtonItem = rightBarButton
		rightBarButton.action = #selector(StoreDetailsMainViewController.search(_:)) // adds search icon

	}

	func search(sender: AnyObject?) {
		if let svc = self.storyboard?.instantiateViewControllerWithIdentifier(StoryboardNames.SearchViewController.rawValue) as? SearchItemsViewController {
			svc.storeObject = self.storeEntity
            self.navigationController?.pushViewController(svc, animated: true)
		}
	}
}