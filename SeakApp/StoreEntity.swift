//
//  StoreEntity.swift
//  SeakApp
//
//  Created by Roman Volkov on 25/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import MapKit

class StoreEntity {
	var objectID: String?
	var address: String?
	var descr: String?
	var name: String?
	var coordintaes: CLLocationCoordinate2D?
	var categories: [StoreCategory] = []
}