//
//  HomegridViewController.swift
//  SeakApp
//
//  Created by Kush Maheshwari on 5/29/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import SlideMenuControllerSwift

class HomeViewController: UIViewController
{
	override func viewDidLoad() {
		super.viewDidLoad()

		self.navigationItem.backBarButtonItem = nil

		let titleImage = UIImage(named: "navBarLogo")
		let imgView = UIImageView(image: titleImage)
		imgView.frame = CGRect(x: 0, y: 0, width: 50, height: 25)
		imgView.contentMode = .scaleAspectFit
		self.title = ""
		self.navigationItem.titleView = imgView

		let rightBarButton = UIBarButtonItem(image: UIImage(named: "searchIcon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(HomeViewController.addItem(_:)))
		navigationItem.rightBarButtonItem = rightBarButton
		rightBarButton.action = #selector(HomeViewController.addItem(_:)) // adds search icon

		let leftBarButton = UIBarButtonItem(image: UIImage(named: "menuIcon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(HomeViewController.openMenu))

		navigationItem.leftBarButtonItem = leftBarButton// adds sidebar-menu icon
		self.navigationItem.hidesBackButton = true

		if let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardNames.MainPageView.rawValue) as? MainPageViewController {
			vc.navigationVC = self.navigationController
			self.addChildViewController(vc)
			self.view.addSubview(vc.view)
			self.view.bringSubview(toFront: vc.view)
		}

	}

	func openMenu() {
		self.slideMenuController()?.openLeft()
	}

	func addItem(_ sender: UIButton!)
	{
        if let svc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardNames.SearchViewController.rawValue) as? SearchItemsViewController {
            self.navigationController?.pushViewController(svc, animated: true)
        }
	}

}
