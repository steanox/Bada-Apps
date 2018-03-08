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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
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

    @objc func keyboardWillShow(notification: NSNotification) {
        keyboard(will: .show, with: notification)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        keyboard(will: .hide, with: notification)
    }
    
    func keyboard(will status: StatusKeyboard, with notification: NSNotification) {
        let origin = self.view.frame.origin
        var size = CGSize()
        
        switch status {
        case .show:
            if let keyboardSize = (notification.userInfo? [UIKeyboardFrameEndUserInfoKey]
                as? NSValue)?.cgRectValue {
                size.width = self.view.frame.size.width
                size.height = UIWindow().frame.height - keyboardSize.height
                let newRect = CGRect(origin: origin, size: size)
                self.view.frame = newRect
                
            }
        case .hide:
            print("c")
            if self.view.frame.height < UIWindow().frame.height {
                size.width = self.view.frame.size.width
                size.height = UIWindow().frame.height
                let newRect = CGRect(origin: origin, size: size)
                self.view.frame = newRect
            }
        }
    }
    
}

enum StatusKeyboard {
    case show
    case hide
}

