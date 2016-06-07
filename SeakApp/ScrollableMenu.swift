//
//  ScrollableMenu.swift
//  SeakApp
//
//  Created by Roman Volkov on 04/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit

class ScrollableMenu: ACTabScrollView {

	override func awakeFromNib() {
		super.awakeFromNib()

//		self.tabSectionHeight = 30
		self.arrowIndicator = false
		self.tabSectionBackgroundColor = UIColor.colorWithHexString("126c94")
		self.contentSectionBackgroundColor = UIColor.colorWithHexString("126c94")
		self.tabGradient = true
		self.pagingEnabled = true
		self.cachedPageLimit = 3
		self.defaultPage = 1
	}
}