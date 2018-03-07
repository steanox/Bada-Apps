//
//  RootTabBarController.swift
//  Bada-apps
//
//  Created by Handy Handy on 07/03/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit


class RootTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBar.backgroundColor = UIColor(rgb: Color.backgroundColor)
        self.tabBar.layer.borderColor = UIColor.clear.cgColor
        self.tabBar.clipsToBounds = true
        
        self.tabBar.items?[0].image = #imageLiteral(resourceName: "attendanceTabBarItem")
        self.tabBar.items?[1].image = #imageLiteral(resourceName: "historyTabBarItem")
        self.tabBar.items?[2].image = #imageLiteral(resourceName: "newsTabBarItem")
        
        self.tabBar.tintColor = UIColor(rgb: Color.attendanceImageColor)
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.selectedImage {
        case #imageLiteral(resourceName: "attendanceTabBarItem")?:
            self.tabBar.tintColor = UIColor(rgb: Color.attendanceImageColor)
        case #imageLiteral(resourceName: "historyTabBarItem")?:
            self.tabBar.tintColor = UIColor(rgb: Color.historyImageColor)
        case #imageLiteral(resourceName: "newsTabBarItem")?:
            self.tabBar.tintColor = UIColor(rgb: Color.newsImageColor)
        default:
            self.tabBar.tintColor = UIColor.brown
        }
    }
    
    
}
