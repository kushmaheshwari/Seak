//
//  KeyboardManager.swift
//  SeakApp
//
//  Created by Roman Volkov on 16/06/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit

class KeyboardManager {
	weak var viewController: UIViewController? = nil

	init() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(KeyboardManager.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(KeyboardManager.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
	}

	deinit {
		if let vc = self.viewController {
			NSNotificationCenter.defaultCenter().removeObserver(vc)
		}
		self.viewController = nil
	}

	@objc func keyboardWillShow(sender: NSNotification) {
		if self.viewController == nil {
			return
		}

		print(self.viewController?.getFirstResponder().debugDescription)
		print("================")
		print(sender.userInfo)
		print("================")
		if let size = sender.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue() {
			self.viewController!.view.frame.origin.y = self.viewController!.view.frame.origin.y - size.height
		}
	}

	@objc func keyboardWillHide(sender: NSNotification) {
		if self.viewController == nil {
			return
		}

		if let size = sender.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue() {
			self.viewController!.view.frame.origin.y = self.viewController!.view.frame.origin.y + size.height
		}
	}
}