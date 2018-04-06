//
//  AppDelegate.swift
//  Bada-apps
//
//  Created by Octavianus . on 07/03/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit
import Firebase
import CommonCrypto

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        if Auth.auth().currentUser != nil {
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.makeKeyAndVisible()
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
            guard (mainStoryboard as? RootTabBarController) != nil else {return true}
            window?.rootViewController = mainStoryboard
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

}
