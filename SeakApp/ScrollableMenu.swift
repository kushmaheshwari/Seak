//
//  ScrollableMenu.swift
//  SeakApp
//
//  Created by Roman Volkov on 04/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit

typealias ScrollableMenuAction = (item: MenuItems) -> Void

class ScrollableMenu: UIScrollView {

	var Action: ScrollableMenuAction = { (item) -> Void in print(item.rawValue) }

	override func awakeFromNib() {
		super.awakeFromNib()
		self.scrollEnabled = true

		var buttonX: CGFloat = 0
		for item in MenuItems.values {
			let button = UIButton(frame: CGRectMake(buttonX, 0, 100, 60))
			button.titleLabel?.textColor = UIColor.whiteColor()
			button.titleLabel?.text = item.rawValue
			button.backgroundColor = UIColor.redColor()
			self.addSubview(button)
			buttonX = buttonX + button.frame.size.width
			button.addTarget(self, action: #selector(itemClick(_:)), forControlEvents: .TouchUpInside)

			let label = UILabel()
			label.text = "|"
			self.addSubview(label)
			buttonX = buttonX + label.frame.size.width
			self.bringSubviewToFront(button)
			self.bringSubviewToFront(label)
		}
		self.contentSize.width = buttonX
	}

	func itemClick(sender: UIButton) {
		for item in MenuItems.values {
			if (item.rawValue == sender.titleLabel?.text) {
				Action(item: item)
				return
			}
		}
	}

}