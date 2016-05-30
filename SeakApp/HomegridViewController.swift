//
//  HomegridViewController.swift
//  SeakApp
//
//  Created by Kush Maheshwari on 5/29/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import UIKit
import Parse
import FBSDKLoginKit

private let reuseIdentifier = "MyCell"



class HomeViewController: UICollectionViewController {
    
    var items = [PFObject]()
    var searchItems = [PFObject]()
    var refreshControl:UIRefreshControl!
    var searchBar:UISearchBar?
    var searchBarActive:Bool = false
    var searchBarBoundsY:CGFloat?
    @IBOutlet var collectionVieww: UICollectionView!
    
    // let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "SEAK"
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "search"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(HomeViewController.addItem(_:)))
        navigationItem.rightBarButtonItem = rightBarButton
        rightBarButton.action = #selector(HomeViewController.addItem(_:))
        
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "hamburger"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(HomeViewController.leftButtonTap))
        navigationItem.leftBarButtonItem = leftBarButton
        
        loadCollectionViewData()
        
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "")
        self.refreshControl.addTarget(self, action: #selector(HomeViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.collectionVieww.addSubview(refreshControl)
//        
//        if(NSUserDefaults.standardUserDefaults().boolForKey("HasLaunchedOnce")){
//            print("Not First")
//        }else{
//            let alert = UIAlertController(title: "Location", message: "Would you like to use your current location as your preferred location?", preferredStyle: UIAlertControllerStyle.Alert)
//            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
//                let user = PFUser.currentUser()
//                PFGeoPoint.geoPointForCurrentLocationInBackground {// if user says yes than set their base location as current location
//                    (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
//                    if error == nil {
//                        user!.setValue(geoPoint, forKey: "HomeGeoPoint")
//                        user!.saveInBackground()
//                    }else{
//                        print(error!.localizedDescription)
//                    }
//                }
//            }))
//            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
//                let Storyboard = UIStoryboard(name: "Main",bundle: nil)
//                let MainVC : UIViewController = Storyboard.instantiateViewControllerWithIdentifier("SetLocation")
//                self.presentViewController(MainVC,animated: true, completion: nil)
//            }))
//            self.presentViewController(alert, animated: true, completion: nil)
//            
//            
//            
//            // This is the first launch ever
//            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "HasLaunchedOnce")
//            NSUserDefaults.standardUserDefaults().synchronize()
//        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    
    
    func addItem(sender:UIButton!)
    {
//        let Storyboard = UIStoryboard(name: "Main",bundle: nil)
//        let MainVC : UIViewController = Storyboard.instantiateViewControllerWithIdentifier("AddItem")
//        self.presentViewController(MainVC,animated: true, completion: nil)
    }
    
    
    
    func refresh(sender:AnyObject){
        loadCollectionViewData()
        self.refreshControl.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func loadCollectionViewData(){
        let query = PFQuery(className:"Item")
        query.findObjectsInBackgroundWithBlock {(objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                self.items.removeAll(keepCapacity: true)
                
                print("Successfully retrieved \(objects!.count) scores.")
                
                if let objects = objects as [PFObject]! {
                    self.items = Array(objects.generate())
                    
                }
                self.collectionVieww.reloadData()
                
            } else {
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    /*  func filterContentForSearchText(searchText: String, scope: String = "All") {
     let predicate = NSPredicate(format: "name BEGINSWITH ", searchText)
     let query = PFQuery(className: "Item", predicate: predicate)
     
     query.findObjectsInBackgroundWithBlock {(objects: [PFObject]?, error: NSError?) -> Void in
     
     if error == nil {
     self.items.removeAll(keepCapacity: true)
     
     print("Successfully retrieved \(objects!.count) scores.")
     
     if let objects = objects as [PFObject]! {
     self.items = Array(objects.generate())
     
     }
     self.collectionVieww.reloadData()
     
     } else {
     print("Error: \(error!) \(error!.userInfo)")
     }
     }
     
     }*/
    
    
    
    
    
    
    
    func leftButtonTap() {
        print("Left button tapped!")
        
        if(PFUser.currentUser() != nil){
            
            PFUser.logOut()
        }else{
            let LoginManager = FBSDKLoginManager()
            LoginManager.logOut()
        }
        
        let loginview = self.storyboard?.instantiateViewControllerWithIdentifier("Login")
        let loginPageNav = UINavigationController (rootViewController: loginview!)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = loginPageNav
        
        
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.searchBarActive {
            return searchItems.count
        }
        else {
            return items.count
        }
        
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CollectionViewCell
        
        
        //        if self.searchBarActive{
        //            if let value = searchItems[indexPath.row]["name"] as? String {
        //                cell.itemNameLabel.text = value
        //            }
        //            if let value = searchItems[indexPath.row]["price"] as? Int {
        //                let stringFromDouble = "$"+"\(value)"
        //                cell.priceLabel.text = stringFromDouble
        //            }
        //
        //       }else{
        if let value = items[indexPath.row]["name"] as? String {
            cell.itemNameLabel.text = value
        }
        if let value = items[indexPath.row]["price"] as? Int {
            let stringFromDouble = "$"+"\(value)"
            cell.priceLabel.text = stringFromDouble
        }
        
        /*      if let value = items[indexPath.row]["picture"] as? UIImageView {
         cell.productImageView = value
         }*/
        //        }
        
        
        return cell
    }
    
    //    func filterContentForSearchText(searchText:String){
    //        let predicate = NSPredicate(format: "name BEGINSWITH "  + searchText)
    //        let query = PFQuery(className: "Item", predicate: predicate)
    //
    //        query.findObjectsInBackgroundWithBlock {(objects: [PFObject]?, error: NSError?) -> Void in
    //
    //            if error == nil {
    //                self.searchItems.removeAll(keepCapacity: true)
    //
    //                print("Successfully retrieved \(objects!.count) scores.")
    //
    //                if let objects = objects as [PFObject]! {
    //                    self.searchItems = Array(objects.generate())
    //
    //                }
    //                //self.collectionVieww.reloadData()
    //
    //            } else {
    //                print("Error: \(error!) \(error!.userInfo)")
    //            }
    //        }
    //      /*  self.dataSourceForSearchResult = self.dataSource?.filter({ (text:String) -> Bool in
    //            return text.containsString(searchText)
    //        })*/
    //    }
    
    //    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    //        // user did type something, check our datasource for text that looks the same
    //        if searchText.characters.count > 0 {
    //            // search and reload data source
    //            self.searchBarActive    = true
    //            self.filterContentForSearchText(searchText)
    //            self.collectionView?.reloadData()
    //        }else{
    //            // if text lenght == 0
    //            // we will consider the searchbar is not active
    //            self.searchBarActive = false
    //            self.collectionView?.reloadData()
    //        }
    //
    //    }
    
    //    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    //        self .cancelSearching()
    //        self.collectionView?.reloadData()
    //    }
    //
    //    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    //        self.searchBarActive = true
    //        self.view.endEditing(true)
    //    }
    //
    //    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
    //        // we used here to set self.searchBarActive = YES
    //        // but we'll not do that any more... it made problems
    //        // it's better to set self.searchBarActive = YES when user typed something
    //        self.searchBar!.setShowsCancelButton(true, animated: true)
    //    }
    //    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
    //        // this method is being called when search btn in the keyboard tapped
    //        // we set searchBarActive = NO
    //        // but no need to reloadCollectionView
    //        self.searchBarActive = false
    //        self.searchBar!.setShowsCancelButton(false, animated: false)
    //    }
    //    func cancelSearching(){
    //        self.searchBarActive = false
    //        self.searchBar!.resignFirstResponder()
    //        self.searchBar!.text = ""
    //    }
    //
    //    func addSearchBar(){
    //        if self.searchBar == nil{
    //            self.searchBarBoundsY = (self.navigationController?.navigationBar.frame.size.height)! + UIApplication.sharedApplication().statusBarFrame.size.height
    //
    //            self.searchBar = UISearchBar(frame: CGRectMake(0,self.searchBarBoundsY!, UIScreen.mainScreen().bounds.size.width, 44))
    //            self.searchBar!.searchBarStyle       = UISearchBarStyle.Minimal
    //            self.searchBar!.tintColor            = UIColor.whiteColor()
    //            self.searchBar!.barTintColor         = UIColor.whiteColor()
    //            self.searchBar!.delegate             = self;
    //            self.searchBar!.placeholder          = "search here";
    //
    //            self.addObservers()
    //        }
    //
    //        if !self.searchBar!.isDescendantOfView(self.view){
    //            self.view .addSubview(self.searchBar!)
    //        }
    //    }
    
    //    override func viewWillDisappear(animated: Bool) {
    //        super.viewWillDisappear(animated)
    //        self.searchBar!.delegate = nil
    //    }
    
    //    func addObservers(){
    //        let context = UnsafeMutablePointer<UInt8>(bitPattern: 1)
    //        self.collectionView?.addObserver(self, forKeyPath: "contentOffset", options: [.New,.Old], context: context)
    //    }
    //
    //    func removeObservers(){
    //        self.collectionView?.removeObserver(self, forKeyPath: "contentOffset")
    //    }
    //
    //    override func observeValueForKeyPath(keyPath: String?,
    //        ofObject object: AnyObject?,
    //        change: [String : AnyObject]?,
    //        context: UnsafeMutablePointer<Void>){
    //            if keyPath! == "contentOffset" {
    //                if let collectionV:UICollectionView = object as? UICollectionView {
    //                    self.searchBar?.frame = CGRectMake(
    //                        self.searchBar!.frame.origin.x,
    //                        self.searchBarBoundsY! + ( (-1 * collectionV.contentOffset.y) - self.searchBarBoundsY!),
    //                        self.searchBar!.frame.size.width,
    //                        self.searchBar!.frame.size.height
    //                    )
    //                }
    //            }
    //    }
    
    
    /*    override func collectionView(collectionView: UICollectionView,
     viewForSupplementaryElementOfKind kind: String,atIndexPath indexPath: NSIndexPath)-> UICollectionReusableView{
     switch kind {
     
     case UICollectionElementKindSectionHeader:
     //add header
     case UICollectionElementKindSectionFooter:
     //add footer
     default:
     break
     }
     
     }*/
    
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.frame.size.width/2 - 16, 228)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(8, 8, 4, 8)
    }
}
