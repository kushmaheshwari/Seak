//
//  ContainerViewController.swift
//  SeakApp
//
//  Created by Roman Volkov on 06/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit
import SlideMenuControllerSwift

class ContainerViewController: SlideMenuController {
	override func awakeFromNib() {
		if let controller = self.storyboard?.instantiateViewController(withIdentifier: StoryboardNames.Navigation.rawValue) {
			self.mainViewController = controller
		}
		if let controller = self.storyboard?.instantiateViewController(withIdentifier: "LeftMenuID") {
			self.leftViewController = controller
		}
		SlideMenuOptions.leftViewWidth = UIScreen.main.bounds.width / 1.5
		SlideMenuOptions.contentViewScale = 1
		super.awakeFromNib()
	}
}
