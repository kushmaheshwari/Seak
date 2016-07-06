//
//  ItemDetailsViewConroller.swift
//  SeakApp
//
//  Created by Roman Volkov on 01/07/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit
import ParseUI
import MapKit

class ItemDetailsViewConroller: UIViewController, MKMapViewDelegate {

	var itemEntity: ItemEntity? = nil

	@IBOutlet weak var itemImage: PFImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var priceLabel: UILabel!
	@IBOutlet weak var reviewsTitle: UILabel!
	@IBOutlet weak var starsStackView: UIStackView!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var addresslabel: UILabel!
	@IBOutlet weak var mapView: MKMapView!

	override func viewDidLoad() {
		super.viewDidLoad()

		self.setTitle()
		self.itemImage.file = self.itemEntity?.picture
		self.itemImage.loadInBackground()
		self.titleLabel.text = self.itemEntity?.name
		self.descriptionLabel.text = self.itemEntity?.descr
		if let price = self.itemEntity?.price {
			self.priceLabel.text = String(format: "$%.2f", price)
		}
		self.reviewsTitle.text = ""
		setStars(3)
		self.addresslabel.text = self.itemEntity?.storeEntity?.address

		if let coordinates = self.itemEntity?.storeEntity?.coordintaes {
			self.mapView.delegate = self
			self.mapView.centerCoordinate = coordinates
			self.mapView.region = MKCoordinateRegionMakeWithDistance(coordinates, 200, 200)

			let point = MKPointAnnotation()
			point.coordinate = coordinates
			point.title = self.itemEntity?.storeEntity?.name

			self.mapView.addAnnotation(point)
		}
	}

	func setTitle() {
		guard let titleView = NSBundle.mainBundle().loadNibNamed("DetailsNavigationTitle", owner: nil, options: nil)[0] as? DetailsNavigationTitleView else { fatalError("Can't init DetailsNavigationTitleView") }

		titleView.titleView.text = self.itemEntity?.storeEntity?.name

		self.navigationItem.title = nil
		self.navigationItem.titleView = titleView
	}

	func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
		let identifier = "pin"
		var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
		if pinView == nil {
			pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)

			pinView!.canShowCallout = true
			pinView!.image = UIImage(named: "mapPoint")
		}
		else {
			pinView!.annotation = annotation
		}

		return pinView
	}

	func setStars(count: Int) {
		for starView in self.starsStackView.arrangedSubviews {
			if let imgView = starView as? UIImageView {
				imgView.image = UIImage(named: "blankStar")
			}
		}

		for i in 0..<count {
			if let imgView = self.starsStackView.arrangedSubviews[i] as? UIImageView {
				imgView.image = UIImage(named: "filledStar")
			}
		}
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "goToReviewsSegue" {
			if let destinationVC = segue.destinationViewController as? ReviewViewController {
				destinationVC.itemEntity = self.itemEntity
			}
		}
	}
}