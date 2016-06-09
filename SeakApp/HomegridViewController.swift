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

	var searchBar: UISearchBar?
	var searchBarActive: Bool = false
	var searchBarBoundsY: CGFloat?

	var views: [UIViewController] = []
	var menuLabels: [UILabel] = []

	@IBOutlet weak var scrollingMenu: ACTabScrollView!

	override func viewDidLoad() {
		super.viewDidLoad()

		self.scrollingMenu.delegate = self
		self.scrollingMenu.dataSource = self

		self.title = "SEAK"
		let rightBarButton = UIBarButtonItem(image: UIImage(named: "search"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(HomeViewController.addItem(_:)))
		navigationItem.rightBarButtonItem = rightBarButton
		rightBarButton.action = #selector(HomeViewController.addItem(_:)) // adds search icon

		let leftBarButton = UIBarButtonItem(image: UIImage(named: "menuIcon"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(HomeViewController.openMenu))

		navigationItem.leftBarButtonItem = leftBarButton// adds sidebar-menu icon
		self.navigationItem.hidesBackButton = true

		for item in MenuItems.values {
			if item != .Home {
				if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("itemsCollectionViewID") as? ItemsCollectionViewController {
					vc.setCategory(item)
					addChildViewController(vc)
					views.append(vc)
				}
			}
			else {
				views.append(UIViewController())
			}
		}

	}

	func openMenu() {
		self.slideMenuController()?.openLeft()
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
	}

	func addItem(sender: UIButton!)
	{
		print("search icon pressed")
	}

	func leftButtonTap() { // right now the left menu side bar is actually a button for logout. when you make sidebar can u just make one of the tabs in there to do this
		print("Left button tapped!")

		if (PFUser.currentUser() != nil) {
			PFUser.logOut()
		} else {
			FBSDKLoginManager().logOut()
		}

		let loginview = self.storyboard?.instantiateViewControllerWithIdentifier("Login")
		let loginPageNav = UINavigationController (rootViewController: loginview!)
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		appDelegate.window?.rootViewController = loginPageNav

	}

	// MARK: ACTabScrollViewDelegate
	func tabScrollView(tabScrollView: ACTabScrollView, didChangePageTo index: Int) {
//		print(index)
		scrollingMenu.changePageToIndex(index, animated: true)

		self.menuLabels[index].attributedText = NSAttributedString(string: MenuItems.values[index].rawValue.uppercaseString, attributes: [NSUnderlineStyleAttributeName: 1])
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
		menuLabels.append(label)

		return stackView
	}

	func tabScrollView(tabScrollView: ACTabScrollView, contentViewForPageAtIndex index: Int) -> UIView {
		return views[index].view
	}

}