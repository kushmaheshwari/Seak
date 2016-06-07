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

class HomeViewController: UIViewController
{
	var refreshControl: UIRefreshControl!
	var searchBar: UISearchBar?
	var searchBarActive: Bool = false
	var searchBarBoundsY: CGFloat?

	override func viewDidLoad() {
		super.viewDidLoad()

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

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
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

}