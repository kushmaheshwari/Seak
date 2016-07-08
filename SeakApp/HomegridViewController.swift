//
//  HomegridViewController.swift
//  SeakApp
//
//  Created by Kush Maheshwari on 5/29/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import UIKit
import Parse
import FBSDKLoginKit

class HomeViewController: UIViewController,
ACTabScrollViewDelegate, ACTabScrollViewDataSource
{
	var views: [UIViewController] = []

	@IBOutlet weak var scrollingMenu: ACTabScrollView!

	override func viewDidLoad() {
		super.viewDidLoad()

		self.scrollingMenu.delegate = self
		self.scrollingMenu.dataSource = self
		self.navigationItem.backBarButtonItem = nil
//            UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)

		let titleImage = UIImage(named: "navBarLogo")
		let imgView = UIImageView(image: titleImage)
		imgView.frame = CGRectMake(0, 0, 50, 25)
		imgView.contentMode = .ScaleAspectFit
		self.title = ""
		self.navigationItem.titleView = imgView

		let rightBarButton = UIBarButtonItem(image: UIImage(named: "searchIcon"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(HomeViewController.addItem(_:)))
		navigationItem.rightBarButtonItem = rightBarButton
		rightBarButton.action = #selector(HomeViewController.addItem(_:)) // adds search icon

		let leftBarButton = UIBarButtonItem(image: UIImage(named: "menuIcon"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(HomeViewController.openMenu))

		navigationItem.leftBarButtonItem = leftBarButton// adds sidebar-menu icon
		self.navigationItem.hidesBackButton = true

		for item in MenuItems.values {
			if item != .Home {
				if let vc = self.storyboard?.instantiateViewControllerWithIdentifier(StoryboardNames.ItemsCollection.rawValue) as? ItemsCollectionViewController {
					vc.setCategory(item)
					vc.navigationVC = self.navigationController
					self.addChildViewController(vc)
					views.append(vc)
				}
			}
			else {
				let st = UIStoryboard(name: StoryboardNames.HomeItemsViewStoryboard.rawValue, bundle: nil)
				if let v = st.instantiateViewControllerWithIdentifier(StoryboardNames.HomeItemsView.rawValue) as? HomeItemsViewController {
					v.navigationVC = self.navigationController
					views.append(v)
				}
			}
		}

	}

	func openMenu() {
		self.slideMenuController()?.openLeft()
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
	}

	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		for view in self.views {
			view.removeFromParentViewController()
		}
	}

	func addItem(sender: UIButton!)
	{
		self.performSegueWithIdentifier("searchViewSegue", sender: nil)
	}

	func leftButtonTap() { // right now the left menu side bar is actually a button for logout. when you make sidebar can u just make one of the tabs in there to do this
		print("Left button tapped!")

	}

	// MARK: ACTabScrollViewDelegate
	func tabScrollView(tabScrollView: ACTabScrollView, didChangePageTo index: Int) {
		scrollingMenu.changePageToIndex(index, animated: true)
	}

	func tabScrollView(tabScrollView: ACTabScrollView, didScrollPageTo index: Int) {
	}

	// MARK: ACTabScrollViewDataSource
	func numberOfPagesInTabScrollView(tabScrollView: ACTabScrollView) -> Int {
		return MenuItems.values.count
	}

	func tabScrollView(tabScrollView: ACTabScrollView, tabViewForPageAtIndex index: Int) -> UIView {
		let stackView = UIStackView()
		stackView.axis = .Horizontal

		// create a label
		let label = UILabel()
		label.text = MenuItems.values[index].rawValue
		label.textAlignment = .Center
		label.textColor = UIColor.whiteColor()
		label.font = UIFont.systemFontOfSize(17, weight: UIFontWeightThin)

		label.sizeToFit() // resize the label to the size of content
		label.frame.size = CGSize(
			width: label.frame.size.width + 40,
			height: label.frame.size.height + 5) // add some paddings
		let sep = UILabel()
		sep.textColor = UIColor.whiteColor()
		sep.text = "|"
		sep.frame.size = CGSize(width: CGFloat(5), height: label.frame.height)

		stackView.addArrangedSubview(label)
		if (index != MenuItems.values.count - 1) {
			stackView.addArrangedSubview(sep)
		}
		stackView.frame.size = CGSize(width: label.frame.width + sep.frame.width, height: label.frame.height)

		return stackView
	}

	func tabScrollView(tabScrollView: ACTabScrollView, contentViewForPageAtIndex index: Int) -> UIView {
		return views[index].view
	}

}