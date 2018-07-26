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
import Fabric
import Crashlytics
import SystemConfiguration

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        FirebaseAppSystem.config.checkForUpdate { (databaseVersion) in
            guard let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else { return }
            if databaseVersion != buildVersion{
                self.window?.rootViewController?.view.showNotification(title: Message.update.title, description: Message.update.description, buttonText: Message.update.button, onSuccess: {
                    
                    let urlString = "itms-beta://"
                    guard let testFlightURL = URL(string: urlString) else { return }
                    
                    UIApplication.shared.open(testFlightURL, options: [:], completionHandler: { (isOpen) in
                        if !isOpen{
                            self.window?.rootViewController?.view.showNotification(title: "Warning", description: "You need to install Test Flight", buttonText: "Install", onSuccess: nil)
                        }
                    })
                
                }, closeEnabled: false)
            }
        }
        Fabric.with([Crashlytics.self])
        
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
