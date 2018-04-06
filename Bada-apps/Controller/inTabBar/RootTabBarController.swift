//
//  RootTabBarController.swift
//  Bada-apps
//
//  Created by Handy Handy on 07/03/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit


class RootTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var loadingIndicator: LoadingIndicator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator = LoadingIndicator(view: self.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBar.backgroundColor = UIColor(rgb: Color.backgroundColor)
        self.tabBar.layer.borderColor = UIColor.clear.cgColor
        self.tabBar.clipsToBounds = true
        
        self.tabBar.items?[0].image = #imageLiteral(resourceName: "attendanceTabBarItem")
        self.tabBar.items?[0].title = Message.attendance
        self.tabBar.items?[1].image = #imageLiteral(resourceName: "newsTabBarItem")
        self.tabBar.items?[1].title = Message.news
        self.tabBar.items?[2].image = #imageLiteral(resourceName: "profileTabBarItem")
        self.tabBar.items?[2].title = Message.profile
        self.tabBar.tintColor = UIColor(rgb: Color.attendanceImageColor)
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.selectedImage {
        case #imageLiteral(resourceName: "attendanceTabBarItem")?:
            self.tabBar.tintColor = UIColor(rgb: Color.attendanceImageColor)
        case #imageLiteral(resourceName: "newsTabBarItem")?:
            self.tabBar.tintColor = UIColor(rgb: Color.newsImageColor)
        case #imageLiteral(resourceName: "profileTabBarItem")?:
            self.tabBar.tintColor = UIColor(rgb: Color.profileImageColor)
        default:
            self.tabBar.tintColor = UIColor.brown
        }
    }
    
    func startLoading() {
        loadingIndicator?.startLoading()
    }
    
    func stopLoading() {
        loadingIndicator?.startLoading()
    }
    
    
}


