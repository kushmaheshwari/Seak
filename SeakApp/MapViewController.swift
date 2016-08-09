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
                         UITableViewDelegate
{
    var resultSearchController: UISearchController? = nil
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultTableView: UITableView!
    var searchResultCount: Int = 1
    
    @IBOutlet weak var mapView: MKMapView!
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocationCoordinate2D? = nil
    @IBOutlet weak var locationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Set Location"
        self.mapView.delegate = self
        
        locationButton.layer.cornerRadius = 15
        
        if let coordinates = UserDataCache.getUserLocation() {
            self.mapView.centerCoordinate = coordinates
            self.mapView.region = MKCoordinateRegionMakeWithDistance(coordinates, 700, 700)
        }
        
        searchResultTableView.delegate = self
        searchBar.delegate = self
        searchResultTableView.hidden = true
    }
    
    @IBAction func saveLocation(sender: AnyObject) {
        self.currentLocation = mapView.centerCoordinate
        UserDataCache.saveUserLocationLatt(currentLocation?.latitude)
        UserDataCache.saveUserLocationLong(currentLocation?.longitude)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultCount
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchResultTableView.hidden = false
       
        if self.mapView.annotations.count != 0
        {
            let annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        
        let localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        let localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            if localSearchResponse != nil
            {
                if localSearchResponse?.mapItems.count >= 4
                {
                    self.searchResultCount = 4
                }
                else
                {
                    self.searchResultCount = (localSearchResponse?.mapItems.count)!
                }
                self.mapView.centerCoordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude: localSearchResponse!.boundingRegion.center.longitude)
            }
        }
    }
    
}
