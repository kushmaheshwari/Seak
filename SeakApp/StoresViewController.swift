//
//  StoresViewController.swift
//  SeakApp
//
//  Created by Roman Volkov on 21/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit

class StoresViewCellController: UICollectionViewCell
{
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
}

class StoresViewController: UIViewController, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout {

	@IBOutlet weak var collectionView: UICollectionView!
	var storeArray: [StoreEntity] = []
	private let repository = StoreRepository()
	private let collectionCellId = "StoreCellID"
	var refreshControl: UIRefreshControl!

	override func viewDidLoad() {
		super.viewDidLoad()

		self.refreshControl = UIRefreshControl()
		self.refreshControl.attributedTitle = NSAttributedString(string: "")
		self.refreshControl.addTarget(self, action: #selector(ItemsCollectionViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
		self.collectionView?.addSubview(refreshControl)

		self.collectionView.dataSource = self
		self.collectionView.delegate = self

		self.collectionView?.registerNib(UINib(nibName: "StoreViewItemCell", bundle: nil), forCellWithReuseIdentifier: self.collectionCellId)

		loadCollectionViewDataCell()
	}

	func refresh(sender: AnyObject)
	{
		loadCollectionViewDataCell()
		self.refreshControl.endRefreshing()
	}

	func loadCollectionViewDataCell()
	{
		repository.getAll { (items) in
			self.storeArray = items
			self.collectionView.reloadData()
		}
	}

	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return storeArray.count
	}

	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.collectionCellId, forIndexPath: indexPath) as? StoresViewCellController
		{
			let item = storeArray[indexPath.row]
			if let name = item.name {
				cell.titleLabel.text = name
			}
			if let description = item.descr {
				cell.descriptionLabel.text = description
			}
			return cell
		}
		return UICollectionViewCell()
	}

	@IBAction func menuIceonPressed(sender: AnyObject) {
		self.slideMenuController()?.openLeft()
	}
    @IBAction func searchIconPressed(sender: AnyObject) {
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenSize = self.collectionView.bounds
        let width = screenSize.width - 40
        return CGSize(width: width /  2, height: 100)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CGFloat(8)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CGFloat(8)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSizeZero
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeZero
    }

}