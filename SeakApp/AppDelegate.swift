//
//  AppDelegate.swift
//  SeakApp
//
//  Created by Kush Maheshwari on 5/29/16.
//  Copyright © 2016 Kush Maheshwari. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import ParseFacebookUtilsV4
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

	var window: UIWindow?
    private let locationManager = CLLocationManager()
	
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

		UINavigationBar.appearance().shadowImage = UIImage()
		UINavigationBar.appearance().backgroundColor = UIColor.clearColor()

		Parse.setApplicationId("8tHn7AQGhVswN2FeRewJZcXY0YjIK3Ly7IaEvvZx",
			clientKey: "o7SW3QAsw3IVXKd5UdGBn7bNRyOILskA6NwGRhQy")
		PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
		PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
		FBSDKButton.classForCoder()
		FBSDKProfile.enableUpdatesOnAccessTokenChange(true)

        FIRApp.configure()
        
		IQKeyboardManager.sharedManager().enable = true
		IQKeyboardManager.sharedManager().enableAutoToolbar = true

        if UserDataCache.getUserLocation() == nil {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.startUpdatingLocation()
        }
        
		return FBSDKApplicationDelegate.sharedInstance()
			.application(application, didFinishLaunchingWithOptions: launchOptions)

	}

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location {
            let coordinates = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            UserDataCache.saveUserLocationLatt(coordinates.latitude)
            UserDataCache.saveUserLocationLong(coordinates.longitude)
            self.locationManager.stopUpdatingLocation()
        }        
    }

    
	func application(application: UIApplication,
		openURL url: NSURL,
		sourceApplication: String?,
		annotation: AnyObject) -> Bool {
			return FBSDKApplicationDelegate.sharedInstance().application(application,
				openURL: url,
				sourceApplication: sourceApplication,
				annotation: annotation)
	}

	func applicationWillResignActive(application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(application: UIApplication) {
		FBSDKAppEvents.activateApp()
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}

}

