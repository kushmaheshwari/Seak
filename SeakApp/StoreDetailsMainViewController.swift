//
//  StoreDetailsMainViewController.swift
//  SeakApp
//
//  Created by Roman Volkov on 21/07/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit

class StoreDetailsMainViewController: UIViewController {

	@IBOutlet weak var scrollableTabs: ScrollableMenu!
	weak var navigationVC: UINavigationController!
	weak var storeEntity: StoreEntity? = nil

	override func viewDidLoad() {
		super.viewDidLoad()
        
	}

	deinit {
		self.navigationVC = nil
		self.storeEntity = nil
	}
}