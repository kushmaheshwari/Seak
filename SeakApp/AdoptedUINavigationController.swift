//
//  AdoptedUINavigationController.swift
//  SeakApp
//
//  Created by Roman Volkov on 06/07/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit

class AdoptedUINavigationController: UINavigationController {

	override func viewDidLoad() {
		super.viewDidLoad()
		if (self.topViewController == self.visibleViewController) {

//			for subview in self.navigationBar.subviews {
//				if subview.isMemberOfClass(NSClassFromString("_UINavigationBarBackIndicatorView")!) {
//					subview.frame.size = CGSize(width: 1, height: 1)
//				}
//				if subview.isKindOfClass(NSClassFromString("UINavigationButton")!) {
//					subview.frame.size = CGSize(width: 42, height: 30)
//				}
//			}
		}
	}
}