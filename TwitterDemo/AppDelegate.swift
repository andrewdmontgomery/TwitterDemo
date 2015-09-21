//
//  AppDelegate.swift
//  TwitterDemo
//
//  Created by Andrew Montgomery on 9/10/15.
//  Copyright (c) 2015 Andrew Montgomery. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static let storyboard = UIStoryboard(name: "Main", bundle: nil)

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userDidLogout", name: userDidLogoutNotification, object: nil)
        
        let sharedCache = NSURLCache(memoryCapacity: 2 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: nil)
        NSURLCache.setSharedURLCache(sharedCache)
        
//        let hamburgerViewController = window?.rootViewController as! HamburgerViewController
//        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let menuViewController = storyboard.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
//        
//        menuViewController.hamburgerViewController = hamburgerViewController
//        hamburgerViewController.menuViewController = menuViewController
        
        
        
        // We're going to need this for TwitterDemo to work
//        if User.currentUser != nil {
//            // Go to the logged in screen
//            print("Current user detected: \(User.currentUser?.name)")
//            let vc = storyboard.instantiateViewControllerWithIdentifier("TweetsNavigationControlller") 
//            window?.rootViewController = vc
//        }
        
//        if User.currentUser != nil {
//            let hamburgerViewController = storyboard.instantiateViewControllerWithIdentifier("HamburgerViewController") as! HamburgerViewController
//            let menuViewController = storyboard.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
//            
//            menuViewController.hamburgerViewController = hamburgerViewController
//            hamburgerViewController.menuViewController = menuViewController
//            
//            window?.rootViewController = hamburgerViewController
//        }
        
        setupContainerViewController()
        
        return true
    }

    func userDidLogout() {
        //let vc = storyboard.instantiateInitialViewController()
        let vc = AppDelegate.storyboard.instantiateInitialViewController()
        window?.rootViewController = vc
        
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
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        // for now, we can assume Twitter sent us here
        TwitterClient.sharedInstance.openURL(url)

        return true
    }
    
    func setupContainerViewController() {
        let hamburgerViewController = AppDelegate.storyboard.instantiateViewControllerWithIdentifier("HamburgerViewController") as! HamburgerViewController
        let menuViewController = AppDelegate.storyboard.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
        
        menuViewController.hamburgerViewController = hamburgerViewController
        hamburgerViewController.menuViewController = menuViewController
        
        if User.currentUser != nil {
            window?.rootViewController = hamburgerViewController
        }

    }
    
}

