//
//  StoreEntity.swift
//  SeakApp
//
//  Created by Roman Volkov on 25/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation

class StoreEntity {
	var objectID: String?
	var address: String?
	var descr: String?
	var name: String?
	var addressLatLong: String?

	var coordinates: [String] {
		guard let coordinatesString = addressLatLong else { return [] }
		let coordinates = coordinatesString.componentsSeparatedByString(",")
		if coordinates.count < 2 {
			fatalError("wrong coordinates \(coordinatesString)")
		}
		return coordinates
	}
	var latitude: Double? {
		if self.coordinates.count == 2 {
			return Double(coordinates[0])
		}
		return nil
	}

	var longitude: Double? {
		if self.coordinates.count == 2 {
			return Double(coordinates[1])
		}
		return nil
	}
}