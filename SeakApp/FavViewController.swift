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

	fileprivate var itemsCollectionView: ItemsCollectionViewController? = nil
	fileprivate var storeCollectionView: StoresCollectionView? = nil

	override func viewDidLoad() {
		super.viewDidLoad()
		ItemsButton.backgroundColor = chosenTabColor
		StoreButton.backgroundColor = defaultTabColor
//		self.setTitle()
		self.navigationItem.title = "Favorites"
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
			self.itemsCollectionView = self.storyboard?.instantiateViewController(withIdentifier: StoryboardNames.ItemsCollection.rawValue) as? ItemsCollectionViewController
			if self.itemsCollectionView != nil {
				self.addChildViewController(self.itemsCollectionView!)
				self.itemsCollectionView?.dataSourceType = .favorites
			}
		}

		if self.storeCollectionView == nil {
			self.storeCollectionView = self.storyboard?.instantiateViewController(withIdentifier: StoryboardNames.StoresCollection.rawValue) as? StoresCollectionView
			if self.storeCollectionView != nil {
				// vc.navigationVC = self.navigationController
				self.addChildViewController(self.storeCollectionView!)
				self.storeCollectionView?.dataSourceType = .favorites
				self.storeCollectionView?.loadCollectionViewDataCell()
			}
		}

	}

	func setTitle() {
		let titleImage = UIImage(named: "navBarLogo")
		let imgView = UIImageView(image: titleImage)
		imgView.frame = CGRect(x: 0, y: 0, width: 50, height: 25)
		imgView.contentMode = .scaleAspectFit
		self.title = ""
		self.navigationItem.titleView = imgView
		self.navigationItem.title = nil
	}

	@IBAction func ItemsPressed(_ sender: AnyObject) {
		ItemsButton.backgroundColor = chosenTabColor
		StoreButton.backgroundColor = defaultTabColor
		setViewController(StoryboardNames.ItemsCollection.rawValue)
	}

	@IBAction func StorePressed(_ sender: AnyObject) {
		ItemsButton.backgroundColor = defaultTabColor
		StoreButton.backgroundColor = chosenTabColor
		setViewController(StoryboardNames.Store.rawValue)
	}

	@IBAction func menuIconPressed(_ sender: AnyObject) {
		self.slideMenuController()?.openLeft()
	}

	@IBAction func searchIconPressed(_ sender: AnyObject) {
	}

	func setViewController(_ storyBoardName: String)
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
					self.commonView.bringSubview(toFront: self.itemsCollectionView!.view)
				}

			}

			break;
		case StoryboardNames.Store.rawValue:

			if self.storeCollectionView != nil {

//                self.storeCollectionView?.navigationVC = self.navigationController
				self.storeCollectionView?.view.frame = self.commonView.bounds

				if self.storeCollectionView != nil {
					self.commonView.addSubview(self.storeCollectionView!.view)
					self.commonView.bringSubview(toFront: self.storeCollectionView!.view)
				}

			}
			break;
		default: break;
		}
	}

}
