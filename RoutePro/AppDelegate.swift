//
//  AppDelegate.swift
//  RoutePro
//
//  Created by Alfredo Luco on 24-05-16.
//  Copyright © 2016 citymovil. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate {

    var window: UIWindow?
    var locationManager: CLLocationManager = CLLocationManager()


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        //self.locationManager.startUpdatingLocation()
        self.locationManager.startMonitoringSignificantLocationChanges()
        
        //scheduled timer
        
//        NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(AppDelegate.refreshLatLon), userInfo: nil, repeats: true)
        
        let settings = UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
        UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler(nil)
        let loop = NSTimer.scheduledTimerWithTimeInterval(60.0, target: self, selector: #selector(AppDelegate.refreshLatLon), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(loop, forMode: NSRunLoopCommonModes)
        
//        let timer: NSTimer = NSTimer(timeInterval: 3.0, target: self, selector: #selector(AppDelegate.refreshLatLon), userInfo: nil, repeats: true)
        
        return true
    }
    
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        print("refreshing 2")
        NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(AppDelegate.refreshLatLon), userInfo: nil, repeats: true)
        completionHandler(UIBackgroundFetchResult.NewData)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//        print("background")

    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func refreshLatLon(){
        
        //Getting the data
        //1.- Today's date
        
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale.systemLocale()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let today = NSDate()
        
        //2.- Latitude and Longitude
        
        let lat = locationManager.location!.coordinate.latitude
        let long = locationManager.location!.coordinate.longitude
        
        //3.- Initialize RouteManager
        
        let api = RouteManager()
        
        print("date: \(formatter.stringFromDate(today)) lat: \(lat) lon: \(long)")
        
        
//        print("refreshing")
    }

}

