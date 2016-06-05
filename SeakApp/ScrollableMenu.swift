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

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)

		var buttonX: CGFloat = 0
		for item in MenuItems.values {
			let button = UIButton(frame: CGRectMake(buttonX, 0, 100, 60))
			button.titleLabel?.text = item.rawValue
			self.addSubview(button)
			buttonX = buttonX + button.frame.size.width
			button.addTarget(self, action: #selector(itemClick(_:)), forControlEvents: .TouchUpInside)

			let label = UILabel()
			label.text = "|"
			self.addSubview(label)
			buttonX = buttonX + label.frame.size.width
		}
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