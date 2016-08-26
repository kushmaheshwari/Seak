//
//  StoresCollectionView.swift
//  SeakApp
//
//  Created by Roman Volkov on 15/07/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Parse

class StoresCollectionView: UICollectionViewController,
UICollectionViewDelegateFlowLayout{

	private let repository = StoreRepository()
	private let favoritesRepository = FavoriteRepository()
	private let collectionCellId = "StoreCellID"
	private var currentLocation: CLLocation? = nil
    private var locationRadius: Int? = nil

	var storeArray: [StoreEntity] = []
	var refreshControl: UIRefreshControl!
	var dataSourceType: StoreCollectionViewSource = .None

	override func awakeFromNib() {
		super.awakeFromNib()

		self.collectionView?.alwaysBounceVertical = true

		self.refreshControl = UIRefreshControl()
		self.refreshControl.attributedTitle = NSAttributedString(string: "")
		self.refreshControl.addTarget(self, action: #selector(ItemsCollectionViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
		self.collectionView?.addSubview(refreshControl)

		self.collectionView?.registerNib(UINib(nibName: "StoreViewItemCell", bundle: nil), forCellWithReuseIdentifier: self.collectionCellId)

		self.addObservers()
        
        if let location = UserDataCache.getUserLocation() {
            self.currentLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        }
        self.locationRadius = UserDataCache.getUserRadius()
	}

	deinit {
		self.removeObserver()
	}

	func addObservers() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(StoresCollectionView.addStoreNotification(_:)), name: AddStoreView.addStoreNotification, object: nil)

		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(StoresCollectionView.removeStoreNotification(_:)), name: AddStoreView.removeStoreNotification, object: nil)

	}

	func removeObserver() {
		NSNotificationCenter.defaultCenter().removeObserver(self, name: AddStoreView.addStoreNotification, object: nil)
		NSNotificationCenter.defaultCenter().removeObserver(self, name: AddStoreView.removeStoreNotification, object: nil)
	}

	func addStoreNotification(notification: NSNotification) {
        
        switch self.dataSourceType{
        case .Favorites:
            return
        case .All:
            if let objectID = notification.userInfo?["storeObjectID"] as? String {
                if let index = self.storeArray.indexOf({ $0.objectID == objectID }) {
                    let indexPath = NSIndexPath(forRow: index, inSection: 0)
                    self.collectionView?.reloadItemsAtIndexPaths([indexPath])
                }
            }
            break
        case .None: return
        }
        
	}

	func removeStoreNotification(notification: NSNotification) {
        switch self.dataSourceType{
        case .Favorites:
            if let objectID = notification.userInfo?["storeObjectID"] as? String {
                if let index = self.storeArray.indexOf({ $0.objectID == objectID }) {
                    self.storeArray.removeAtIndex(index)
                    let indexPath = NSIndexPath(forItem: index, inSection: 0)
                    self.collectionView?.deleteItemsAtIndexPaths([indexPath])
                }
            }
            break
        case .All:
            if let objectID = notification.userInfo?["storeObjectID"] as? String {
                if let index = self.storeArray.indexOf({ $0.objectID == objectID }) {
                    let indexPath = NSIndexPath(forRow: index, inSection: 0)
                    self.collectionView?.reloadItemsAtIndexPaths([indexPath])
                }
            }
            break
        case .None: return
        }
    }


	func refresh(sender: AnyObject)
	{
		loadCollectionViewDataCell()
		self.refreshControl.endRefreshing()
	}

    func filter(stores:[StoreEntity])->[StoreEntity] {
        return stores.filter({ (store) -> Bool in
            if let storeCoordinates = store.coordintaes {
                let location = CLLocation(latitude: storeCoordinates.latitude, longitude: storeCoordinates.longitude)
                return (self.currentLocation!.distanceFromLocation(location) * 0.000621371) <= Double(self.locationRadius!)
            }
            return false
        })
    }
    
	func loadCollectionViewDataCell()
	{
		switch self.dataSourceType {
		case .All:
			repository.getAll { (items) in
				self.storeArray = items
                if let _ = self.currentLocation, let _ = self.locationRadius {
                    self.storeArray = self.filter(self.storeArray)
                }
				dispatch_async(dispatch_get_main_queue(), {
					self.collectionView?.reloadData()
				})

			}

		case .Favorites:
			self.favoritesRepository.getAllStores({ (items) in
				self.storeArray = items
				dispatch_async(dispatch_get_main_queue(), {
					self.collectionView?.reloadData()
				})
			})
		default:
			fatalError("unknown data source type")
		}

	}

	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return storeArray.count
	}

	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.collectionCellId, forIndexPath: indexPath) as? StoresViewCellController
		{
			cell.addViewContainer.subviews.forEach({ $0.removeFromSuperview() })

			let item = storeArray[indexPath.row]
			if let name = item.name {
				cell.titleLabel.text = name
			}
			if let description = item.descr {
				cell.descriptionLabel.text = description
			}

            cell.distanceLabel.hidden = true
            if let itemCoords = item.coordintaes {
                let location = CLLocation(latitude: itemCoords.latitude, longitude: itemCoords.longitude)
                if let distance = self.currentLocation?.distanceFromLocation(location) {
                    cell.distanceLabel.text = String(format: "%.1fmi away", distance * 0.000621371)
                    cell.distanceLabel.hidden = false
                }
            }

            
			cell.userInteractionEnabled = true

			// Add add/remove icon
			cell.addViewContainer.backgroundColor = UIColor.clearColor()
			if let v = NSBundle.mainBundle().loadNibNamed("AddStoreView", owner: self, options: nil)[0] as? AddStoreView {
				v.store = item
				cell.addViewContainer.addSubview(v)
				cell.addViewContainer.bringSubviewToFront(v)
				cell.bringSubviewToFront(cell.addViewContainer)
				cell.addViewContainer.bringSubviewToFront(v)
				v.load()
			}

			cell.openStoreBlock = { () in
				if let destinationVC = self.storyboard?.instantiateViewControllerWithIdentifier(StoryboardNames.StoreDetails.rawValue) as? StoreDetailsMainViewController {
					destinationVC.navigationVC = self.navigationController
					destinationVC.storeEntity = item
					destinationVC.initTabs()
					self.navigationController?.pushViewController(destinationVC, animated: true)
				}
			}

			cell.updateConstraintsIfNeeded()
			cell.sizeToFit()
			cell.titleLabel.sizeToFit()
			cell.descriptionLabel.sizeToFit()

			return cell
		}
		return UICollectionViewCell()
	}

	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

		let screenSize = self.collectionView!.bounds
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