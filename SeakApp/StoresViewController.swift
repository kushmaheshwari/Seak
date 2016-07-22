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

	var openStoreBlock: () -> Void = { print("tapped StoresViewCellController") }

	override func awakeFromNib() {
		super.awakeFromNib()
		self.distanceLabel.layer.cornerRadius = 3
		self.distanceLabel.layer.masksToBounds = true
		self.layer.cornerRadius = 5
		self.layer.masksToBounds = true

		let tap = UITapGestureRecognizer(target: self, action: #selector(StoresViewCellController.tap(_:)))
		tap.numberOfTapsRequired = 1

		self.addGestureRecognizer(tap)
	}

	func tap(gesture: UITapGestureRecognizer?) {
		openStoreBlock()
	}
}

class StoresViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)

		if let vc = self.storyboard?.instantiateViewControllerWithIdentifier(StoryboardNames.StoresCollection.rawValue) as? StoresCollectionView {
//			vc.navigationVC = self.navigationController
			vc.dataSourceType = .All
			vc.loadCollectionViewDataCell()
			self.addChildViewController(vc)
			self.view.addSubview(vc.view)
		}

		self.setTitle()
	}

	func setTitle() {
		guard let titleView = NSBundle.mainBundle().loadNibNamed("StoresNavigationTitle", owner: nil, options: nil)[0] as? UIView else { fatalError("Can't init StoresNavigationTitleView") }

		self.navigationItem.title = nil
		self.navigationItem.titleView = titleView

	}

	@IBAction func menuIceonPressed(sender: AnyObject) {
		self.slideMenuController()?.openLeft()
	}
	@IBAction func searchIconPressed(sender: AnyObject) {
	}

}