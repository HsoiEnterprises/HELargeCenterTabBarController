//
//  AppDelegate.swift
//  HELargeCenterTabBarController
//
//  Created by hsoi on 9/20/15.
//  Copyright © 2015 Hsoi Enterprises LLC. All rights reserved.
//

import UIKit
import HELargeCenterTabBarController


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        if let tabBarController = window?.rootViewController as? HELargeCenterTabBarController {
            
            // Hsoi 2015-09-20 - At this point the OS hasn't yet loaded the tab view (HELargeCenterTabBarController.viewDidLoad() 
            // hasn't yet been called). So we'll let things go around the block once and then we'll load it all up.
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let unselectedImage = UIImage(named: "tab-unselected"), selectedImage = UIImage(named: "tab-selected") {
                    
                    // Hsoi 2015-09-20 - Comment/Uncomment one line or the other to see how `allowSwitch works.
                    
                    tabBarController.addCenterButton(unselectedImage: unselectedImage, selectedImage: selectedImage)
                    //tabBarController.addCenterButton(unselectedImage: unselectedImage, selectedImage: selectedImage, target: self, action: "presentSecondViewController:", allowSwitch: false)
                }
            })
        }
        
        return true
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


    // MARK: -
    
    func presentSecondViewController(sender: AnyObject) {
        if let rootViewController = window?.rootViewController {
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("modalNavViewController")
            rootViewController.presentViewController(viewController, animated: true, completion: nil)
        }
    }

}

