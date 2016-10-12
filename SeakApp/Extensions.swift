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
			if v.isFirstResponder {
				return v
			}
		}

		return UIView()
	}
}

extension UIColor {
	static func colorWithHexString (_ hex: String) -> UIColor {
		var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

		if (cString.hasPrefix("#")) {
			cString = cString.substring(to: cString.characters.index(cString.startIndex, offsetBy: 1))
		}

		if (cString.characters.count != 6) {
			return UIColor.gray
		}

		let rString = cString.substring(to: cString.characters.index(cString.startIndex, offsetBy: 2))
		let gString = cString.substring(from: cString.characters.index(cString.startIndex, offsetBy: 2)).substring(to: cString.characters.index(cString.startIndex, offsetBy: 2))
		let bString = cString.substring(from: cString.characters.index(cString.startIndex, offsetBy: 4)).substring(to: cString.characters.index(cString.startIndex, offsetBy: 2))

		var r: CUnsignedInt = 0, g: CUnsignedInt = 0, b: CUnsignedInt = 0;

		Scanner(string: rString).scanHexInt32(&r)
		Scanner(string: gString).scanHexInt32(&g)
		Scanner(string: bString).scanHexInt32(&b)

		return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
	}
}

extension UIStackView {
	func setStars(_ count: Int) {
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
    private static var cache: [String: Data] = [:]
    private static let fileManager = FileManager.default
    private static let diskPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
    
    func downloadWithCache(urlString: String) {
        
        let cacheDirectory = UIImageView.diskPaths[0] as NSString
        let diskPath = cacheDirectory.appendingPathComponent("\(urlString.hashValue)")
        
        self.image = nil
        if let imgData = UIImageView.cache[urlString] {
            self.image = UIImage(data: imgData)
        }
        else
            if UIImageView.fileManager.fileExists(atPath: diskPath),
                let image = UIImage(contentsOfFile: diskPath) {
                
                self.image = image
                let data = UIImageJPEGRepresentation(image, 1.0)
                UIImageView.cache[urlString] = data
                
            }
            else
            {
                OperationQueue().addOperation({
                    if let url = NSURL(string: urlString) {
                        guard let data = NSData(contentsOf: url as URL) else { return }
                        
                        UIImageView.cache[urlString] = data as Data
                        data.write(toFile: diskPath, atomically: true)
                        OperationQueue.main.addOperation({
                            self.image = UIImage(data: data as Data)
                            self.setNeedsDisplay()
                        })
                    }
                })
        }
    }
}

extension Date {
    func isGreaterThanDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
}
