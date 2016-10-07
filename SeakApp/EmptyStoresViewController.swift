//
//  EmptyStoresViewController.swift
//  SeakApp
//
//  Created by Екатерина Волкова on 06/10/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class EmptyStoresViewController: UIViewController,
                                 MKMapViewDelegate,
                                 CLLocationManagerDelegate
{
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var bringSeakBtn: UIButton!
    var cityName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let boldString = "SEAK "
        let nonBoldString1 = "Bring "
        let nonBoldString2 = "to my city"

        let boldAttr = [NSFontAttributeName: UIFont(name: "Roboto-Bold", size: 14)!, NSForegroundColorAttributeName: UIColor.white]
        let nonBoldAttr = [NSFontAttributeName: UIFont(name: "Roboto-Regular", size: 14)!, NSForegroundColorAttributeName: UIColor.white]
        
        let boldAttrStr = NSAttributedString(string: boldString, attributes: boldAttr)
        let nonBoldAttrStr1 = NSAttributedString(string: nonBoldString1, attributes: nonBoldAttr)
        let nonBoldAttrStr2 = NSAttributedString(string: nonBoldString2, attributes: nonBoldAttr)
        
        let combination = NSMutableAttributedString()
        combination.append(nonBoldAttrStr1)
        combination.append(boldAttrStr)
        combination.append(nonBoldAttrStr2)
        
        bringSeakBtn.setAttributedTitle(combination, for: .normal)
        cityLabel.text = cityName + " - but we are expanding soon"
        setCityName()
    }
    
    func setCityName()
    {
            }
}
