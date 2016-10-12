//
//   ReviewViewController.swift
//  SeakApp
//
//  Created by Екатерина Волкова on 04/07/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit

class ReviewViewCellController: UITableViewCell
{
	@IBOutlet weak var starsStackView: UIStackView!

	@IBOutlet weak var previewMainLabel: UILabel!
	@IBOutlet weak var previewNameLabel: UILabel!
	@IBOutlet weak var previewDateLabel: UILabel!
	@IBOutlet weak var previewAuthorImage: UIImageView!
}

class LeaveReviewPresentationController: UIPresentationController {

	var overlappingHeight: CGFloat = 0.0

	override var frameOfPresentedViewInContainerView : CGRect {
		let topSpacing: CGFloat = 4
		let bottomSpacing: CGFloat = 4
		let borderSpacing: CGFloat = 8
		return CGRect(x: borderSpacing, y: UIScreen.main.bounds.size.height - self.overlappingHeight - bottomSpacing + topSpacing, width: UIScreen.main.bounds.size.width - borderSpacing * 2, height: self.overlappingHeight - topSpacing)
	}
}

class ReviewViewController: UIViewController,
UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate
{
	@IBOutlet weak var previewLabel: UILabel!
	@IBOutlet weak var previewTableView: UITableView!
	@IBOutlet weak var closeWindowButton: UIButton!
	@IBOutlet weak var starsStackView: UIStackView!


	private let repository = ReviewRepository()
    private let itemRepository = ItemRepository()
    private let userReposirory = UserRepository()
	private var items: [ReviewEntity] = []
	var itemEntity: ItemEntity?

	override func viewDidLoad() {
		super.viewDidLoad()

		let titleImage = UIImage(named: "navBarLogo")
		let imgView = UIImageView(image: titleImage)
		imgView.frame = CGRect(x: 0, y: 0, width: 50, height: 25)
		imgView.contentMode = .scaleAspectFit
		self.title = ""
		self.previewLabel.text = ""
		self.navigationItem.titleView = imgView

		self.previewTableView.separatorColor = UIColor.colorWithHexString("f5f5f5")

		self.previewTableView.dataSource = self
		self.previewTableView.delegate = self

		self.previewTableView.estimatedRowHeight = 135
		self.previewTableView.rowHeight = UITableViewAutomaticDimension
        
        self.setAvgRating()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.loadReviews()
	}

	func loadReviews() {
		if self.itemEntity == nil {
			fatalError("Empty ItemEntity")
		}
        self.items.removeAll()
        
		self.repository.getAll(by: self.itemEntity?.objectID) { (reviews) in
			self.items = reviews
            OperationQueue.main.addOperation({ 
                self.setAvgRating()
                self.previewTableView.reloadData()
            })
		}
	}

	func setAvgRating() {
		let rating = self.itemEntity?.avgRating
		self.starsStackView.setStars(Int(rating ?? 0))
		self.previewLabel.text = "\((self.itemEntity?.countReview ?? 0)) Reviews"
	}

	@IBAction func closeView(_ sender: AnyObject) {
		self.dismiss(animated: true, completion: nil)
	}

	func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
		let presenter = LeaveReviewPresentationController(presentedViewController: presented, presenting: presentingViewController!)
		presenter.overlappingHeight = self.previewTableView.frame.size.height + 60
		return presenter
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "goToAddReview" {
			segue.destination.transitioningDelegate = self
			segue.destination.modalPresentationStyle = .custom
			if let vc = segue.destination as? LeaveReviewViewController {
				vc.item = self.itemEntity
                vc.submitComletionBlock = { () in
                    
                    self.itemRepository.getById(self.itemEntity?.objectID!, completion: { (item) in
                        self.itemEntity?.avgRating = item.avgRating
                        self.itemEntity?.countReview = item.countReview
                        
                        self.loadReviews()
                    })
                }
			} // end cast
		}
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1 // self.items.count
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return self.items.count
	}

	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 4
	}

	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 4))
		headerView.backgroundColor = UIColor.clear
		return headerView
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellIdentifire = "Cell"
		if let cell = previewTableView.dequeueReusableCell(withIdentifier: cellIdentifire) as? ReviewViewCellController
		{
			cell.previewNameLabel.text = ""
            cell.previewAuthorImage.image = nil
            

            let item = self.items[indexPath.section]
            self.userReposirory.getById(userId: item.userId, completion: { (user) in
                cell.previewNameLabel.text = user.username
                if let _ = user.picutre {
                    cell.previewAuthorImage.downloadWithCache(urlString: user.picutre!)
                }
            })
			
			let dateFormater = DateFormatter()

			dateFormater.dateFormat = "MMMM dd, yyyy"
			cell.previewDateLabel.text = "Posted " + dateFormater.string(from: item.createdAt! as Date)

			cell.previewAuthorImage.layer.cornerRadius = CGFloat(25)
			cell.previewAuthorImage.clipsToBounds = true
            

			cell.previewMainLabel.text = item.review
			cell.starsStackView.setStars(Int(item.rating!))

			return cell
		}
		return UITableViewCell()
	}
}
