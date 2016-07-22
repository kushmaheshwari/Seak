//
//  StoreDetailsMainViewController.swift
//  SeakApp
//
//  Created by Roman Volkov on 21/07/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit

class StoreDetailsMainViewController: UIViewController,
ACTabScrollViewDelegate, ACTabScrollViewDataSource
{

	@IBOutlet weak var scrollableTabs: ScrollableMenu!
	weak var navigationVC: UINavigationController!
	weak var storeEntity: StoreEntity? = nil

	private var views: [UIViewController] = []

	override func viewDidLoad() {
		super.viewDidLoad()
		self.setTitle()

		// Tabs
		self.scrollableTabs.delegate = self
		self.scrollableTabs.dataSource = self
	}

	func initTabs() {
		// add Home view
		let st = UIStoryboard(name: StoryboardNames.HomeItemsViewStoryboard.rawValue, bundle: nil)
		if let vc = st.instantiateViewControllerWithIdentifier(StoryboardNames.HomeItemsView.rawValue) as? HomeItemsViewController {
			vc.navigationVC = self.navigationVC
			vc.storeEntity = self.storeEntity
			views.append(vc)
		}
		// add rest views for each category
		for item in self.storeEntity!.categories {
			if let vc = self.storyboard?.instantiateViewControllerWithIdentifier(StoryboardNames.ItemsCollection.rawValue) as? ItemsCollectionViewController {
				vc.dataSourceType = .Categories
				vc.setCategory(item)
				vc.storeEntity = self.storeEntity
				vc.navigationVC = self.navigationVC
				self.addChildViewController(vc)
				views.append(vc)
			}
		}
	}

	deinit {
		self.navigationVC = nil
		self.storeEntity = nil
		for view in self.views {
			view.removeFromParentViewController()
		}
	}

	func setTitle() {
		guard let titleView = NSBundle.mainBundle().loadNibNamed("StoresNavigationTitle", owner: nil, options: nil)[0] as? StoreNavigationTitleView else { fatalError("Can't init StoresNavigationTitle") }

		titleView.titleView.text = self.storeEntity?.name

		self.navigationItem.title = nil
		self.navigationItem.titleView = titleView

		let rightBarButton = UIBarButtonItem(image: UIImage(named: "searchIcon"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(HomeViewController.addItem(_:)))
		navigationItem.rightBarButtonItem = rightBarButton
		rightBarButton.action = #selector(StoreDetailsMainViewController.search(_:)) // adds search icon
		self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)

	}

	func search(sender: AnyObject?) {
		if let svc = self.storyboard?.instantiateViewControllerWithIdentifier(StoryboardNames.SearchViewController.rawValue) as? SearchItemsViewController {
			svc.storeObject = self.storeEntity
            self.navigationController?.pushViewController(svc, animated: true)
		}
		stackView.frame.size = CGSize(width: label.frame.width + sep.frame.width, height: label.frame.height)

		return stackView
	}

	func tabScrollView(tabScrollView: ACTabScrollView, contentViewForPageAtIndex index: Int) -> UIView {
		return views[index].view
	}

}