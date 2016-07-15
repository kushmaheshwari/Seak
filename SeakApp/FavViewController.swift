//
//  FavViewController.swift
//  SeakApp
//
//  Created by Екатерина Волкова on 13/07/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import UIKit
import Foundation

class FavViewController: UIViewController
{
	@IBOutlet weak var ItemsButton: UIButton!
	@IBOutlet weak var StoreButton: UIButton!
	@IBOutlet weak var commonView: UIView!
	let chosenTabColor = UIColor.colorWithHexString("318EC4")
	let defaultTabColor = UIColor.colorWithHexString("266D96")

	private var itemsCollectionView: ItemsCollectionViewController? = nil

	override func viewDidLoad() {
		super.viewDidLoad()
		ItemsButton.backgroundColor = chosenTabColor
		StoreButton.backgroundColor = defaultTabColor
		self.setTitle()
		self.navigationItem.hidesBackButton = true
		self.initCollectionViews()

		setViewController(StoryboardNames.ItemsCollection.rawValue)
	}

	deinit {
		self.itemsCollectionView?.view.removeFromSuperview()
		self.itemsCollectionView = nil
	}

	func initCollectionViews() {
		if self.itemsCollectionView == nil {
			self.itemsCollectionView = self.storyboard?.instantiateViewControllerWithIdentifier(StoryboardNames.ItemsCollection.rawValue) as? ItemsCollectionViewController
			if self.itemsCollectionView != nil {
				self.addChildViewController(self.itemsCollectionView!)
				self.itemsCollectionView?.dataSourceType = .Favorites
			}
		}
//TODO add storeview creation
	}

	func setTitle() {
		let titleImage = UIImage(named: "navBarLogo")
		let imgView = UIImageView(image: titleImage)
		imgView.frame = CGRectMake(0, 0, 50, 25)
		imgView.contentMode = .ScaleAspectFit
		self.title = ""
		self.navigationItem.titleView = imgView
		self.navigationItem.title = nil
	}

	@IBAction func ItemsPressed(sender: AnyObject) {
		ItemsButton.backgroundColor = chosenTabColor
		StoreButton.backgroundColor = defaultTabColor
		setViewController(StoryboardNames.ItemsCollection.rawValue)
	}

	@IBAction func StorePressed(sender: AnyObject) {
		ItemsButton.backgroundColor = defaultTabColor
		StoreButton.backgroundColor = chosenTabColor
		setViewController(StoryboardNames.Store.rawValue)
	}

	@IBAction func menuIconPressed(sender: AnyObject) {
		self.slideMenuController()?.openLeft()
	}

	@IBAction func searchIconPressed(sender: AnyObject) {
	}

	func setViewController(storyBoardName: String)
	{
		self.itemsCollectionView?.view.removeFromSuperview()
//		self.storeCollectionView?.view.removeFromSuperview()
		self.commonView.removeConstraints(self.commonView.constraints)

		switch (storyBoardName)
		{
		case StoryboardNames.ItemsCollection.rawValue:

			if self.itemsCollectionView != nil {

				self.itemsCollectionView?.navigationVC = self.navigationController
				self.itemsCollectionView?.view.frame = self.commonView.bounds

				if self.itemsCollectionView != nil {
					self.commonView.addSubview(self.itemsCollectionView!.view)
					self.commonView.bringSubviewToFront(self.itemsCollectionView!.view)
				}

			}

			break;
		case StoryboardNames.Store.rawValue:

			break;
		default: break;
		}
	}

}