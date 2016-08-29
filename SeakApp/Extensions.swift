//
//  Extensions.swift
//  SeakApp
//
//  Created by Roman Volkov on 04/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
	func hideKeyboardWhenTappedAround() {
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
		view.addGestureRecognizer(tap)
	}

	func dismissKeyboard() {
		view.endEditing(true)
	}

	func getFirstResponder() -> UIView {
		for v in self.view.subviews {
			if v.isFirstResponder() {
				return v
			}
		}

		return UIView()
	}
}

extension UIColor {
	static func colorWithHexString (hex: String) -> UIColor {
		var cString: String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString

		if (cString.hasPrefix("#")) {
			cString = cString.substringToIndex(cString.startIndex.advancedBy(1))
		}

		if (cString.characters.count != 6) {
			return UIColor.grayColor()
		}

		let rString = cString.substringToIndex(cString.startIndex.advancedBy(2))
		let gString = cString.substringFromIndex(cString.startIndex.advancedBy(2)).substringToIndex(cString.startIndex.advancedBy(2))
		let bString = cString.substringFromIndex(cString.startIndex.advancedBy(4)).substringToIndex(cString.startIndex.advancedBy(2))

		var r: CUnsignedInt = 0, g: CUnsignedInt = 0, b: CUnsignedInt = 0;

		NSScanner(string: rString).scanHexInt(&r)
		NSScanner(string: gString).scanHexInt(&g)
		NSScanner(string: bString).scanHexInt(&b)

		return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
	}
}

extension UIStackView {
	func setStars(count: Int) {
		for starView in self.arrangedSubviews {
			if let imgView = starView as? UIImageView {
				imgView.image = UIImage(named: "blankStar")
			}
		}

		for i in 0..<count {
			if let imgView = self.arrangedSubviews[i] as? UIImageView {
				imgView.image = UIImage(named: "filledStar")
			}
		}
	}
}

extension UIImageView {
    private static let cache = NSCache()
    
    func downloadWithCache(urlString: String) {
        if let imgData = UIImageView.cache.objectForKey(urlString) as? NSData {
            self.image = UIImage(data: imgData)
            self.setNeedsDisplay()
        }
        else {
            NSOperationQueue().addOperationWithBlock({[weak self] () in
                if let url = NSURL(string: urlString) {
                    guard let data = NSData(contentsOfURL: url) else { return }
                    NSOperationQueue.mainQueue().addOperationWithBlock({ 
                        self?.image = UIImage(data: data)
                        UIImageView.cache.setObject(data, forKey: urlString)
                        self?.setNeedsDisplay()
                    })
                }
            })
        }
    }
}

extension NSDate {
    func isGreaterThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
}