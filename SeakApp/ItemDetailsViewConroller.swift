//
//  ItemDetailsViewConroller.swift
//  SeakApp
//
//  Created by Roman Volkov on 01/07/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ItemDetailsViewConroller: UIViewController, MKMapViewDelegate {

	var itemEntity: ItemEntity? = nil
	fileprivate let reviewRepository = ReviewRepository()

	@IBOutlet weak var itemImage: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var priceLabel: UILabel!
	@IBOutlet weak var reviewsTitle: UILabel!
	@IBOutlet weak var starsStackView: UIStackView!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var addresslabel: UILabel!
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var likeViewContainer: UIView!

	override func viewDidLoad() {
		super.viewDidLoad()

		self.setTitle()
        if let url = self.itemEntity?.picture {
            self.itemImage.downloadWithCache(urlString: url)
        }
        
		self.titleLabel.text = self.itemEntity?.name
		self.descriptionLabel.text = self.itemEntity?.descr
		if let price = self.itemEntity?.price {
			self.priceLabel.text = String(format: "$%.2f", price)
		}
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

		// add like viewcontroller
		self.likeViewContainer.backgroundColor = UIColor.clear

		if let v = Bundle.main.loadNibNamed("LikeItemView", owner: self, options: nil)?[0] as? LikeItemView {
			v.item = self.itemEntity
			self.likeViewContainer.addSubview(v)
			self.likeViewContainer.bringSubview(toFront: v)
			v.load()
		}

		self.automaticallyAdjustsScrollViewInsets = false
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.setAvgRating()
	}

	func setAvgRating() {
        let rating = self.itemEntity?.avgRating ?? 0
        self.starsStackView.setStars(Int(rating))
        self.reviewsTitle.text = String(format: "%.1f/5 \((self.itemEntity?.countReview ?? 0)) reviews.", rating)
	}

	func setTitle() {
		guard let titleView = Bundle.main.loadNibNamed("DetailsNavigationTitle", owner: nil, options: nil)?[0] as? DetailsNavigationTitleView else { fatalError("Can't init DetailsNavigationTitleView") }

		titleView.titleView.text = self.itemEntity?.storeEntity?.name

		self.navigationItem.title = nil
		self.navigationItem.titleView = titleView
	}

	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		let identifier = "pin"
		var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
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

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "goToReviewsSegue" {
			if let destinationVC = segue.destination as? ReviewViewController {
				destinationVC.itemEntity = self.itemEntity
			}
		}
	}
}
