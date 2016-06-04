//
//  Enums.swift
//  SeakApp
//
//  Created by Roman Volkov on 02/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation

enum ParseClassNames: String {
	case Item = "Item"
}

enum StoryboardNames: String {
	case MainStoryboard = "Main"
	case Login = "Login"
	case Navigation = "navigation"
}

enum MenuItems: String {
	case Latest = "Latest"
	case Clothes = "Clothes"
	case Electronics = "Electronics"
	case Textbooks = "Textbooks"
	case Accessories = "Accessories"
	case Appliances = "Appliances"
	case Miscellaneous = "Miscellaneous"

	static let values = [Latest, Clothes, Electronics,
		Textbooks, Accessories, Appliances, Miscellaneous]
}