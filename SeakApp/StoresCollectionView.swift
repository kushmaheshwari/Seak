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
import Firebase

class StoresCollectionView: UICollectionViewController,
UICollectionViewDelegateFlowLayout{

	fileprivate let repository = StoreRepository()
	fileprivate let favoritesRepository = FavoriteRepository()
	fileprivate let collectionCellId = "StoreCellID"
	fileprivate var currentLocation: CLLocation? = nil
    fileprivate var locationRadius: Int? = nil

	fileprivate var storeArray: [StoreEntity] = []
    fileprivate var favoritesStoreArray: [FavoriteStore] = []
    // fileprivate let favoriteStoreCache = NSCache<AnyObject>()
	fileprivate var refreshControl: UIRefreshControl!
	var dataSourceType: StoreCollectionViewSource = .none

	override func awakeFromNib() {
		super.awakeFromNib()

		self.collectionView?.alwaysBounceVertical = true

		self.refreshControl = UIRefreshControl()
		self.refreshControl.attributedTitle = NSAttributedString(string: "")
		self.refreshControl.addTarget(self, action: #selector(ItemsCollectionViewController.refresh(_:)), for: UIControlEvents.valueChanged)
		self.collectionView?.addSubview(refreshControl)

		self.collectionView?.register(UINib(nibName: "StoreViewItemCell", bundle: nil), forCellWithReuseIdentifier: self.collectionCellId)

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
		NotificationCenter.default.addObserver(self, selector: #selector(StoresCollectionView.addStoreNotification(_:)), name: NSNotification.Name(rawValue: AddStoreView.addStoreNotification), object: nil)

		NotificationCenter.default.addObserver(self, selector: #selector(StoresCollectionView.removeStoreNotification(_:)), name: NSNotification.Name(rawValue: AddStoreView.removeStoreNotification), object: nil)

	}

	func removeObserver() {
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: AddStoreView.addStoreNotification), object: nil)
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: AddStoreView.removeStoreNotification), object: nil)
	}

	func addStoreNotification(_ notification: Notification) {
        
        switch self.dataSourceType{
        case .favorites:
            return
        case .all:
            if let objectID = (notification as NSNotification).userInfo?["storeObjectID"] as? String {
                if let index = self.storeArray.index(where: { $0.objectID == objectID }) {
                    let indexPath = IndexPath(row: index, section: 0)
                    self.collectionView?.reloadItems(at: [indexPath])
                }
            }
            break
        case .none: return
        }
        
	}

	func removeStoreNotification(_ notification: Notification) {
        switch self.dataSourceType{
        case .favorites:
            if let objectID = (notification as NSNotification).userInfo?["storeObjectID"] as? String {
                if let index = self.storeArray.index(where: { $0.objectID == objectID }) {
                    self.storeArray.remove(at: index)
                    let indexPath = IndexPath(item: index, section: 0)
                    self.collectionView?.deleteItems(at: [indexPath])
                }
            }
            break
        case .all:
            if let objectID = (notification as NSNotification).userInfo?["storeObjectID"] as? String {
                if let index = self.storeArray.index(where: { $0.objectID == objectID }) {
                    let indexPath = IndexPath(row: index, section: 0)
                    self.collectionView?.reloadItems(at: [indexPath])
                }
            }
            break
        case .none: return
        }
    }

	func refresh(_ sender: AnyObject)
	{
		loadCollectionViewDataCell()
		self.refreshControl.endRefreshing()
	}

    func filter(_ stores:[StoreEntity])->[StoreEntity] {
        return stores.filter({ (store) -> Bool in
            if let storeCoordinates = store.coordintaes {
                let location = CLLocation(latitude: storeCoordinates.latitude, longitude: storeCoordinates.longitude)
                return (self.currentLocation!.distance(from: location) * 0.000621371) <= Double(self.locationRadius!)
            }
            return false
        })
    }
    
	func loadCollectionViewDataCell()
	{
		switch self.dataSourceType {
		case .all:
			repository.getAll { (items) in
				self.storeArray = items
                if let _ = self.currentLocation, let _ = self.locationRadius {
                    self.storeArray = self.filter(self.storeArray)
                }
                OperationQueue.main.addOperation({
                    if self.storeArray.count != 0
                    {
                        self.collectionView?.reloadData()
                    } else
                    {
                        let geoCoder = CLGeocoder()
                        let location = CLLocation(latitude: UserDataCache.getUserLocationLatt()!, longitude: UserDataCache.getUserLocationLong()!)
                        
                        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                            if let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardNames.EmptyStoresView.rawValue) as? EmptyStoresViewController
                            {
                                // Place details
                                var placeMark: CLPlacemark!
                                placeMark = placemarks?[0]
                                
                                // City
                                if let city = placeMark.addressDictionary!["City"] as? NSString {
                                    vc.cityName = city as String
                                }
                                
                                self.addChildViewController(vc)
                                self.view.addSubview(vc.view)
                            }
                            })
                        }
                })
			}

		case .favorites:
            if FIRAuth.auth()?.currentUser == nil { fatalError("empty current user") }
			self.favoritesRepository.getAllStores({ (items) in
				self.storeArray = items
                OperationQueue.main.addOperation({
                    self.collectionView?.reloadData()
                })
			})
		default:
			fatalError("unknown data source type")
		}

	}

	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.storeArray.count
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.collectionCellId, for: indexPath) as? StoresViewCellController
		{
			cell.addViewContainer.subviews.forEach({ $0.removeFromSuperview() })

            let item = storeArray[(indexPath as NSIndexPath).row]
            
            cell.titleLabel.text = item.name ?? ""
			cell.descriptionLabel.text = item.descr ?? ""

            cell.distanceLabel.isHidden = true
            if let itemCoords = item.coordintaes {
                let location = CLLocation(latitude: itemCoords.latitude, longitude: itemCoords.longitude)
                if let distance = self.currentLocation?.distance(from: location) {
                    cell.distanceLabel.text = String(format: "%.1fmi away", distance * 0.000621371)
                    cell.distanceLabel.isHidden = false
                }
            }

            
			cell.isUserInteractionEnabled = true

			// Add add/remove icon
			cell.addViewContainer.backgroundColor = UIColor.clear
			if let v = Bundle.main.loadNibNamed("AddStoreView", owner: self, options: nil)?[0] as? AddStoreView {
				v.store = item
				cell.addViewContainer.addSubview(v)
				cell.addViewContainer.bringSubview(toFront: v)
				cell.bringSubview(toFront: cell.addViewContainer)
				cell.addViewContainer.bringSubview(toFront: v)
				v.load()
			}

			cell.openStoreBlock = { () in
				if let destinationVC = self.storyboard?.instantiateViewController(withIdentifier: StoryboardNames.StoreDetails.rawValue) as? StoreDetailsMainViewController {
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

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

		let screenSize = self.collectionView!.bounds
		let width = screenSize.width - 40
		let constrainedSize = CGSize(width: width / 2, height: 100)

		return constrainedSize
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return CGFloat(8)
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return CGFloat(8)
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
		return CGSize.zero
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		return CGSize.zero
	}

}
