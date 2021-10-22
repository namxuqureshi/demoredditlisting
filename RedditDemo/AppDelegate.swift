//
//  AppDelegate.swift
//  RedditDemo
//
//  Created by Muhammad Usman on 22/10/2021.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
//    @main

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = DemoListingVC()
        DataManager.sharedInstance.screenWidth = UIScreen.main.bounds.width
        DataManager.sharedInstance.screenHeight = UIScreen.main.bounds.height
        let navigationController = UINavigationController.init(rootViewController: vc)
        navigationController.isNavigationBarHidden = true
        navigationController.hidesBottomBarWhenPushed = false
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }

   


}

