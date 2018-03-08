//
//  Responder+byPass.swift
//  Bada-apps
//
//  Created by Handy Handy on 08/03/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit

extension UIResponder {
    var viewController: UIViewController? {
        if let vc = self as? UIViewController {
            return vc
        }
        
        return next?.viewController
    }
}

