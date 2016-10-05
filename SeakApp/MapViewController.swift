//
//  MapViewController.swift
//  SeakApp
//
//  Created by Екатерина Волкова on 03/08/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit
import MapKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}



class MapViewController: UIViewController,
                         MKMapViewDelegate,
                         CLLocationManagerDelegate,
                         UISearchBarDelegate,
                         UITableViewDelegate,
                         UITableViewDataSource,
                         UITextFieldDelegate
{
    fileprivate var resultSearchController: UISearchController? = nil
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultTableView: UITableView!
    fileprivate var searchResultCount: Int = 1
    
    @IBOutlet weak var mapView: MKMapView!
    fileprivate let locationManager = CLLocationManager()
    fileprivate var currentLocation: CLLocationCoordinate2D? = nil
    @IBOutlet weak var locationButton: UIButton!
    fileprivate var mapSearchItems: [MKMapItem]? = []
    fileprivate var searching: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Set Location"
        
        self.locationButton.layer.cornerRadius = 15
        
        self.mapView.delegate = self
        if let coordinates = UserDataCache.getUserLocation() {
            self.mapView.centerCoordinate = coordinates
            self.mapView.region = MKCoordinateRegionMakeWithDistance(coordinates, 700, 700)
        }
        
        self.searchResultTableView.delegate = self
        self.searchResultTableView.dataSource = self
        self.searchResultTableView.isHidden = true
        self.searchResultTableView.reloadData()
        self.searchBar.delegate = self
        self.searchBar.searchBarStyle = .prominent
        self.searchBar.backgroundImage = UIImage()
        
        for view: UIView in searchBar.subviews {
            if (view is UITextField) {
                let tf: UITextField = (view as! UITextField)
                tf.delegate = self
            }
        }
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(MapViewController.mapTap(_:)))
        self.mapView.addGestureRecognizer(tap)
        
    }
    
    func clearSearchInfo() {
        self.searchBar.resignFirstResponder()
        self.searchResultTableView.isHidden = true
        self.searching = false
        self.mapSearchItems = []
        self.searchResultTableView.reloadData()
    }
    
    func mapTap(_ sender: AnyObject?) {
        clearSearchInfo()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location {
            self.currentLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    @IBAction func setToUserLocation(_ sender: AnyObject) {
        if self.currentLocation == nil {
        
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.background).async(execute: {
                
                while (self.currentLocation == nil) { }
                DispatchQueue.main.async(execute: {
                    self.mapView.centerCoordinate = self.currentLocation!
                    self.mapView.region = MKCoordinateRegionMakeWithDistance(self.currentLocation!, 700, 700)
                })
            })
        }
        else {
            self.mapView.centerCoordinate = self.currentLocation!
            self.mapView.region = MKCoordinateRegionMakeWithDistance(self.currentLocation!, 700, 700)
        }
        
        clearSearchInfo()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.perform(#selector(self.searchBarCancelButtonClicked), with: self.searchBar, afterDelay: 0.1)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        clearSearchInfo()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if mapSearchItems?.count >= 4
        {
            self.searchResultCount = 4
        }
        else
        {
            self.searchResultCount = (mapSearchItems?.count)!
        }
        return self.searchResultCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.searchResultTableView.dequeueReusableCell(withIdentifier: "cellID")
        if mapSearchItems != nil
        {
            cell?.textLabel?.text = mapSearchItems![(indexPath as NSIndexPath).row].placemark.title
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = mapSearchItems![(indexPath as NSIndexPath).row]
        self.mapView.centerCoordinate = selectedItem.placemark.coordinate
        searchResultTableView.isHidden = true
        self.searching = false
        self.mapSearchItems = []
        searchBar.perform(#selector(self.resignFirstResponder), with: nil, afterDelay: 0.1)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    @IBAction func saveLocation(_ sender: AnyObject) {
        UserDataCache.saveUserLocationLatt(currentLocation?.latitude)
        UserDataCache.saveUserLocationLong(currentLocation?.longitude)
        
        let alert = UIAlertController(title: "", message: "Location is saved", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count == 0 {
            clearSearchInfo()
            searchBar.resignFirstResponder()
            return
        }
        
        self.searching = true
        
        let localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchText
        let localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            
            if !self.searching {
                return //return if user leaves searchbar
            }
            
            if localSearchResponse != nil
            {
                self.mapSearchItems = localSearchResponse?.mapItems
                
                self.searchResultTableView.reloadData()
                var tableHeight: CGFloat = 0.0
                let len = (self.mapSearchItems!.count>=4) ? 4 : self.mapSearchItems!.count
                for i in 0..<len {
                    tableHeight += self.tableView(self.searchResultTableView, heightForRowAt: IndexPath(row: i, section: 0))
                }
                self.searchResultTableView.frame = CGRect(x: self.searchResultTableView.frame.origin.x, y: self.searchResultTableView.frame.origin.y, width: self.searchResultTableView.frame.size.width, height: tableHeight)
                self.searchResultTableView.isHidden = false
            }
        }

    }
    
}
