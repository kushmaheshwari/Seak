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


class MapViewController: UIViewController,
                         MKMapViewDelegate,
                         CLLocationManagerDelegate,
                         UISearchBarDelegate,
                         UITableViewDelegate,
                         UITableViewDataSource,
                         UITextFieldDelegate
{
    var resultSearchController: UISearchController? = nil
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultTableView: UITableView!
    var searchResultCount: Int = 1
    
    @IBOutlet weak var mapView: MKMapView!
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocationCoordinate2D? = nil
    @IBOutlet weak var locationButton: UIButton!
    var mapSearchItems: [MKMapItem]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Set Location"
        
        locationButton.layer.cornerRadius = 15
        
        self.mapView.delegate = self
        if let coordinates = UserDataCache.getUserLocation() {
            self.mapView.centerCoordinate = coordinates
            self.mapView.region = MKCoordinateRegionMakeWithDistance(coordinates, 700, 700)
        }
        
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
        searchResultTableView.hidden = true
        searchResultTableView.reloadData()
        searchBar.delegate = self
        
        for view: UIView in searchBar.subviews {
            if (view is UITextField) {
                let tf: UITextField = (view as! UITextField)
                tf.delegate = self
            }
        }
    }
    
    @IBAction func setToUserLocation(sender: AnyObject) {
        self.mapView.centerCoordinate = UserDataCache.getUserLocation()!
        self.mapView.region = MKCoordinateRegionMakeWithDistance(UserDataCache.getUserLocation()!, 700, 700)
        searchBar.resignFirstResponder()
        searchResultTableView.hidden = true
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        self.performSelector(#selector(self.searchBarCancelButtonClicked), withObject: self.searchBar, afterDelay: 0.1)
        return true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.searchResultTableView.dequeueReusableCellWithIdentifier("cellID")
        if mapSearchItems != nil
        {
            cell?.textLabel?.text = mapSearchItems![indexPath.row].placemark.title
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedItem = mapSearchItems![indexPath.row]
        self.mapView.centerCoordinate = selectedItem.placemark.coordinate
        searchResultTableView.hidden = true
        searchBar.performSelector(#selector(self.resignFirstResponder), withObject: nil, afterDelay: 0.1)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30
    }
    
    @IBAction func saveLocation(sender: AnyObject) {
        self.currentLocation = mapView.centerCoordinate
        UserDataCache.saveUserLocationLatt(currentLocation?.latitude)
        UserDataCache.saveUserLocationLong(currentLocation?.longitude)
    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count == 0 {
            searchBar.performSelector(#selector(self.resignFirstResponder), withObject: nil, afterDelay: 0.1)
            searchResultTableView.hidden = true
        }
        
        let localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchText
        let localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            if localSearchResponse != nil
            {
                self.mapSearchItems = localSearchResponse?.mapItems
                
                self.searchResultTableView.reloadData()
                var tableHeight: CGFloat = 0.0
                let len = (self.mapSearchItems!.count>=4) ? 4 : self.mapSearchItems!.count
                for i in 0..<len {
                    tableHeight += self.tableView(self.searchResultTableView, heightForRowAtIndexPath: NSIndexPath(forRow: i, inSection: 0))
                }
                self.searchResultTableView.frame = CGRectMake(self.searchResultTableView.frame.origin.x, self.searchResultTableView.frame.origin.y, self.searchResultTableView.frame.size.width, tableHeight)
                self.searchResultTableView.hidden = false
            }
        }

    }
    
}
