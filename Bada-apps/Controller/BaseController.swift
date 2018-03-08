//
//  BaseController.swift
//  Bada-apps
//
//  Created by Handy Handy on 07/03/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit

class BaseController: UIViewController {
    
    var loadingIndicator: LoadingIndicator?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator = LoadingIndicator(view: self.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        styleUI()
    }
    
    func styleUI() {
        view.backgroundColor = UIColor(rgb: Color.backgroundColor)
        
    }
    
    func startActivityIndicator() {
        guard let rootTabBarController = self.tabBarController as? RootTabBarController else {
            loadingIndicator?.startLoading()
            return
        }
        rootTabBarController.startLoading()
    }
    
    func stopActivityIndicator() {
        guard let rootTabBarController = self.tabBarController as? RootTabBarController else {
            loadingIndicator?.stopLoading()
            return
        }
        rootTabBarController.stopLoading()
    }
    
}

