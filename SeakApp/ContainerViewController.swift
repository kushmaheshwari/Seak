//
//  ContainerViewController.swift
//  SeakApp
//
//  Created by Roman Volkov on 06/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit

class ContainerViewController: SlideMenuController {
	override func awakeFromNib() {
		if let controller = self.storyboard?.instantiateViewControllerWithIdentifier("navigationID") {
			self.mainViewController = controller
		}
		if let controller = self.storyboard?.instantiateViewControllerWithIdentifier("LeftMenuID") {
			self.leftViewController = controller
		}
		super.awakeFromNib()
	}
}