//
//  BigFollowStoreButtonView.swift
//  SeakApp
//
//  Created by Roman Volkov on 09/08/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit

class BigFollowStoreButtonView: UIView {
    @IBOutlet weak var addImg: UIImageView!
    
    fileprivate let repository = FavoriteRepository()
    fileprivate var favoriteStore: FavoriteStore? = nil
    fileprivate var tapped: Bool = false
    
    weak var store: StoreEntity? = nil
    static let addStoreNotification = String(describing: AddStoreView.self) + "_add"
    static let removeStoreNotification = String(describing: AddStoreView.self) + "_remove"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addImg.isHidden = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddStoreView.tap(_:)))
        tapRecognizer.numberOfTapsRequired = 1
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapRecognizer)
    }
    
    func load() {
        guard let _ = self.store else { fatalError("empty Store Entity") }
        repository.getStatus(by: self.store!) { (item) in
            self.favoriteStore = item
            self.setImage()
        }
    }
    
    func tap(_ sender: AnyObject?) {
        if (self.tapped) {
            return
        }
        self.tapped = true
        if self.favoriteStore == nil { // means neeed to like it and retrieve favoriteStore
            self.repository.add(self.store!, completion: { (favoriteStore) in
                self.favoriteStore = favoriteStore
                self.setImage()
                self.tapped = false
                let dict: [AnyHashable: Any]? = ["storeObjectID": self.store!.objectID!]
                NotificationCenter.default.post(name: Notification.Name(rawValue: AddStoreView.addStoreNotification), object: nil, userInfo: dict)
            })
        } else {
            self.repository.remove(self.favoriteStore!.storeId, successBlock: { (success) in
                if (success) {
                    let dict: [AnyHashable: Any]? = ["storeObjectID": self.store!.objectID!]
                    NotificationCenter.default.post(name: Notification.Name(rawValue: AddStoreView.removeStoreNotification), object: nil, userInfo: dict)
                    self.favoriteStore = nil
                    self.setImage()
                    self.tapped = false
                }
            })
        }
    }
    
    func setImage() {
        self.addImg.isHidden = false
        if self.favoriteStore != nil {
            self.addImg.image = UIImage(named: "bigCheckmarkButton")
        } else {
            self.addImg.image = UIImage(named: "bigPlusButton")
        }
    }
 
}
