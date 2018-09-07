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
    var bdDate: BDDate?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator = LoadingIndicator(view: self.view)
        
    }

    func getTabBarController() -> RootTabBarController? {
        guard let rootTabBarController = self.tabBarController as? RootTabBarController else {
            return nil
        }
        return rootTabBarController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        bdDate = BDDate()
        styleUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func styleUI() {
        view.backgroundColor = UIColor(rgb: Color.backgroundColor)
        
    }
    
    func startActivityIndicator() {
        guard let rootTabBarController = self.tabBarController as? RootTabBarController else {
            loadingIndicator?.startLoading()
            return
        }
        rootTabBarController.tabBar.isHidden = true
        loadingIndicator?.startLoading()
    }
    
    func stopActivityIndicator() {
        guard let rootTabBarController = self.tabBarController as? RootTabBarController else {
            loadingIndicator?.stopLoading()
            return
        }
        rootTabBarController.tabBar.isHidden = false
        loadingIndicator?.stopLoading()
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        keyboard(will: .show, with: notification)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        keyboard(will: .hide, with: notification)
    }
    
    func keyboard(will status: StatusKeyboard, with notification: NSNotification) {
        let origin = self.view.frame.origin
//        var size = CGSize()
        
        switch status {
        case .show:
            if let keyboardSize = (notification.userInfo? [UIKeyboardFrameEndUserInfoKey]
                as? NSValue)?.cgRectValue {
//                size.width = self.view.frame.size.width
//                size.height = UIWindow().frame.height - keyboardSize.height
//                let newRect = CGRect(origin: origin, size: size)
//                self.view.frame = newRect
                
                let xPosition = self.view.frame.origin.x
                let yPosition = UIWindow().frame.origin.y - keyboardSize.height + Identifier.differenceViewOfKeyboard
                let newPosition = CGPoint(x: xPosition, y: yPosition)
                self.view.frame.origin = newPosition
                
            }
        case .hide:
            if origin.y != UIWindow().frame.origin.y {
//           if self.view.frame.height < 0 {
//                size.width = self.view.frame.size.width
//                size.height = UIWindow().frame.height
//                let newRect = CGRect(origin: origin, size: size)
//                self.view.frame = newRect
                
                let newPosition = CGPoint(x: 0.0, y: 0.0)
                self.view.frame.origin = newPosition
            }
        }
    }
    
}

enum StatusKeyboard {
    case show
    case hide
}

