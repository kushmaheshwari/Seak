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
		self.tabSectionBackgroundColor = UIColor.colorWithHexString("0b5883")
		self.contentSectionBackgroundColor = UIColor.colorWithHexString("0b5883")
		self.tabGradient = true
		self.pagingEnabled = true
		self.cachedPageLimit = 7
		self.defaultPage = 0
	}
}