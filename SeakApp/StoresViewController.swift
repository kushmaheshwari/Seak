//
//  StoresViewController.swift
//  SeakApp
//
//  Created by Roman Volkov on 21/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit

class StoresViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	@IBAction func menuIceonPressed(sender: AnyObject) {
		self.slideMenuController()?.openLeft()
	}
    @IBAction func searchIconPressed(sender: AnyObject) {
    }
}