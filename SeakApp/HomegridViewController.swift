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
	var refreshControl: UIRefreshControl!
	var searchBar: UISearchBar?
	var searchBarActive: Bool = false
	var searchBarBoundsY: CGFloat?

	var views: [ItemsCollectionView] = []
	var menuLabels: [UILabel] = []

	var attrs = [

	]

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

		self.refreshControl = UIRefreshControl() // adds refreshing
		self.refreshControl.attributedTitle = NSAttributedString(string: "")
		self.refreshControl.addTarget(self, action: #selector(HomeViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
//		self.collectionView.addSubview(refreshControl)

		for item in MenuItems.values {
			let v = ItemsCollectionView()
			let index = MenuItems.values.indexOf(item)
			switch Int(index!) {
			case 0:
				v.backgroundColor = UIColor.redColor()
			case 1:
				v.backgroundColor = UIColor.blueColor()
			case 2:
				v.backgroundColor = UIColor.grayColor()
			case 3:
				v.backgroundColor = UIColor.orangeColor()
			default:
				v.backgroundColor = UIColor.blackColor()
			}
			views.append(v)
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

	func refresh(sender: AnyObject) {
		// loadCollectionViewData()
		self.refreshControl.endRefreshing()
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

		self.menuLabels[index].attributedText = NSAttributedString(string: MenuItems.values[index].rawValue, attributes: [NSUnderlineStyleAttributeName: 1])
	}

	func tabScrollView(tabScrollView: ACTabScrollView, didScrollPageTo index: Int) {
	}

	// MARK: ACTabScrollViewDataSource
	func numberOfPagesInTabScrollView(tabScrollView: ACTabScrollView) -> Int {
		return MenuItems.values.count
	}

	func tabScrollView(tabScrollView: ACTabScrollView, tabViewForPageAtIndex index: Int) -> UIView {
		// create a label
		let label = UILabel()
		label.text = MenuItems.values[index].rawValue
		label.textAlignment = .Center
		label.textColor = UIColor.whiteColor()

		// if the size of your tab is not fixed, you can adjust the size by the following way.
		label.sizeToFit() // resize the label to the size of content
		label.frame.size = CGSize(
			width: label.frame.size.width + 28,
			height: label.frame.size.height + 5) // add some paddings
		menuLabels.append(label)

		return label
	}

	func tabScrollView(tabScrollView: ACTabScrollView, contentViewForPageAtIndex index: Int) -> UIView {
		return views[index]
	}

}