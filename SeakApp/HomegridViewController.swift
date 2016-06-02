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

private let reuseIdentifier = "MyCell"

class HomeViewController: UICollectionViewController {

	private let repository = ItemRepository()

	var items = [ItemEntity]()
	var searchItems = [ItemEntity]()
	var refreshControl: UIRefreshControl!
	var searchBar: UISearchBar?
	var searchBarActive: Bool = false
	var searchBarBoundsY: CGFloat?
	@IBOutlet var collectionVieww: UICollectionView!

	override func viewDidLoad() {
		super.viewDidLoad()

		self.title = "SEAK"
		let rightBarButton = UIBarButtonItem(image: UIImage(named: "search"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(HomeViewController.addItem(_:)))
		navigationItem.rightBarButtonItem = rightBarButton
		rightBarButton.action = #selector(HomeViewController.addItem(_:)) // adds search icon

		let leftBarButton = UIBarButtonItem(image: UIImage(named: "hamburger"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(HomeViewController.leftButtonTap))
		navigationItem.leftBarButtonItem = leftBarButton// adds sidebar-menu icon

		loadCollectionViewData()

		self.refreshControl = UIRefreshControl() // adds refreshing
		self.refreshControl.attributedTitle = NSAttributedString(string: "")
		self.refreshControl.addTarget(self, action: #selector(HomeViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
		self.collectionVieww.addSubview(refreshControl)

		// Do any additional setup after loading the view.
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
	}

	func addItem(sender: UIButton!)
	{
		print("search icon pressed")
	}

	func refresh(sender: AnyObject) {
		loadCollectionViewData()
		self.refreshControl.endRefreshing()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func loadCollectionViewData() { // loading cells with data

		repository.getAll() { (data) -> Void in
			self.items = data
			print("Successfully retrieved \(data.count) scores.")
			self.collectionVieww.reloadData()
		}
	}

	func leftButtonTap() { // right now the left menu side bar is actually a button for logout. when you make sidebar can u just make one of the tabs in there to do this
		print("Left button tapped!")

		if (PFUser.currentUser() != nil) {

			PFUser.logOut()
		} else {
			let LoginManager = FBSDKLoginManager()
			LoginManager.logOut()
		}

		let loginview = self.storyboard?.instantiateViewControllerWithIdentifier("Login")
		let loginPageNav = UINavigationController (rootViewController: loginview!)
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		appDelegate.window?.rootViewController = loginPageNav

	}

	// MARK: UICollectionViewDataSource
	override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}

	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if self.searchBarActive {
			return searchItems.count
		}
		else {
			return items.count
		}

	}

	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CollectionViewCell

		let item = items[indexPath.row]
		cell.itemNameLabel.text = item.name
		if let price = item.price {
			cell.priceLabel.text = String(format: "%.1f", price)
		}
		cell.productImageView.file = item.picture
		cell.productImageView.loadInBackground()

		return cell
	}

}

extension HomeViewController: UICollectionViewDelegateFlowLayout { // Grid View
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		return CGSizeMake(collectionView.frame.size.width / 2 - 16, 228)
	}

	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
		return 8
	}

	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
		return 8
	}

	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
		return UIEdgeInsetsMake(8, 8, 4, 8)
	}
}
