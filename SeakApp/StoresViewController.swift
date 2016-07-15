//
//  StoresViewController.swift
//  SeakApp
//
//  Created by Roman Volkov on 21/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class StoresViewCellController: UICollectionViewCell
{
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var distanceLabel: UILabel!

	@IBOutlet weak var addViewContainer: UIView!

	override func awakeFromNib() {
		super.awakeFromNib()
		self.distanceLabel.layer.cornerRadius = 3
		self.distanceLabel.layer.masksToBounds = true
		self.layer.cornerRadius = 5
		self.layer.masksToBounds = true
	}
}

class StoresViewController: UIViewController, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate {

	@IBOutlet weak var collectionView: UICollectionView!
	var storeArray: [StoreEntity] = []
	private let repository = StoreRepository()
	private let collectionCellId = "StoreCellID"
	private let locationManager = CLLocationManager()
	private var currentLocation: CLLocation? = nil
	private var distanceLabels: [UILabel] = []
	var refreshControl: UIRefreshControl!

	override func viewDidLoad() {
		super.viewDidLoad()

		self.setTitle()
		self.collectionView?.alwaysBounceVertical = true
		self.refreshControl = UIRefreshControl()
		self.refreshControl.attributedTitle = NSAttributedString(string: "")
		self.refreshControl.addTarget(self, action: #selector(ItemsCollectionViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
		self.collectionView?.addSubview(refreshControl)

		self.collectionView.dataSource = self
		self.collectionView.delegate = self

		self.collectionView?.registerNib(UINib(nibName: "StoreViewItemCell", bundle: nil), forCellWithReuseIdentifier: self.collectionCellId)

		self.locationManager.delegate = self
		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
		self.locationManager.requestWhenInUseAuthorization()
		self.locationManager.startMonitoringSignificantLocationChanges()
		self.locationManager.startUpdatingLocation()

		loadCollectionViewDataCell()
	}

	func setTitle() {
		guard let titleView = NSBundle.mainBundle().loadNibNamed("StoresNavigationTitle", owner: nil, options: nil)[0] as? UIView else { fatalError("Can't init StoresNavigationTitleView") }

		self.navigationItem.title = nil
		self.navigationItem.titleView = titleView
	}

	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		self.currentLocation = locations.first
		for label in self.distanceLabels {
			let item = self.storeArray[label.tag]
			if let itemCoords = item.coordintaes {
				let location = CLLocation(latitude: itemCoords.latitude, longitude: itemCoords.longitude)
				if let distance = self.currentLocation?.distanceFromLocation(location) {
					label.text = String(format: "%.1fmi away", distance / 0.000621371)
				}
			}
		}
	}

	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		self.locationManager.stopUpdatingLocation()
		self.locationManager.stopMonitoringSignificantLocationChanges()
		self.distanceLabels.removeAll()
	}

	func refresh(sender: AnyObject)
	{
		loadCollectionViewDataCell()
		self.refreshControl.endRefreshing()
	}

	func loadCollectionViewDataCell()
	{
		self.distanceLabels.removeAll()
		repository.getAll { (items) in
			self.storeArray = items
			dispatch_async(dispatch_get_main_queue(), {
				self.collectionView.reloadData()
			})

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

			cell.distanceLabel.tag = indexPath.row
			self.distanceLabels.append(cell.distanceLabel)

			// Add add/remove icon
			cell.addViewContainer.backgroundColor = UIColor.clearColor()
			if let v = NSBundle.mainBundle().loadNibNamed("AddStoreView", owner: self, options: nil)[0] as? AddStoreView {
				v.store = item
				cell.addViewContainer.addSubview(v)
				cell.addViewContainer.bringSubviewToFront(v)
				v.load()
			}

			cell.updateConstraintsIfNeeded()
			cell.sizeToFit()
			cell.titleLabel.sizeToFit()
			cell.descriptionLabel.sizeToFit()
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
		let constrainedSize = CGSize(width: width / 2, height: 100)

		return constrainedSize
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