//
//  MainPageViewController.swift
//  SeakApp
//
//  Created by Roman Volkov on 17/07/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit
import ACTabScrollView

class MainPageViewController: UIViewController,
ACTabScrollViewDelegate, ACTabScrollViewDataSource
{

	@IBOutlet weak var scrollTabsMenu: ScrollableMenu!
	weak var navigationVC: UINavigationController? = nil

	var views: [UIViewController] = []

	override func viewDidLoad() {
		super.viewDidLoad()

		self.scrollTabsMenu.delegate = self
		self.scrollTabsMenu.dataSource = self

		for item in StoreCategory.startValues {
			if item != .Home {
				if let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardNames.ItemsCollection.rawValue) as? ItemsCollectionViewController {
					vc.dataSourceType = .categories
					vc.setCategory(item)
					vc.navigationVC = self.navigationController
					self.addChildViewController(vc)
					views.append(vc)
				}
			}
			else {
				let st = UIStoryboard(name: StoryboardNames.HomeItemsViewStoryboard.rawValue, bundle: nil)
				if let v = st.instantiateViewController(withIdentifier: StoryboardNames.HomeItemsView.rawValue) as? HomeItemsViewController {
					v.navigationVC = self.navigationVC
					views.append(v)
				}
			}
		}
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		for view in self.views {
			view.removeFromParentViewController()
		}

		self.navigationVC = nil
	}

	// MARK: ACTabScrollViewDelegate
	func tabScrollView(_ tabScrollView: ACTabScrollView, didChangePageTo index: Int) {
		self.scrollTabsMenu.changePageToIndex(index, animated: true)
	}

	func tabScrollView(_ tabScrollView: ACTabScrollView, didScrollPageTo index: Int) {
	}

	// MARK: ACTabScrollViewDataSource
	func numberOfPagesInTabScrollView(_ tabScrollView: ACTabScrollView) -> Int {
		return StoreCategory.startValues.count
	}

	func tabScrollView(_ tabScrollView: ACTabScrollView, tabViewForPageAtIndex index: Int) -> UIView {
		let stackView = UIStackView()
		stackView.axis = .horizontal

		// create a label
		let label = UILabel()
		label.text = StoreCategory.startValues[index].rawValue
		label.textAlignment = .center
		label.textColor = UIColor.white
		label.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightThin)

		label.sizeToFit() // resize the label to the size of content
		label.frame.size = CGSize(
			width: label.frame.size.width + 40,
			height: label.frame.size.height + 5) // add some paddings
		let sep = UILabel()
		sep.textColor = UIColor.white
		sep.text = "|"
		sep.frame.size = CGSize(width: CGFloat(5), height: label.frame.height)

		stackView.addArrangedSubview(label)
		if (index != StoreCategory.startValues.count - 1) {
			stackView.addArrangedSubview(sep)
		}
		stackView.frame.size = CGSize(width: label.frame.width + sep.frame.width, height: label.frame.height)

		return stackView
	}

	func tabScrollView(_ tabScrollView: ACTabScrollView, contentViewForPageAtIndex index: Int) -> UIView {
		return views[index].view
	}
}
