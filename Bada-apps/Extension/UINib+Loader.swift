//
//  UINib+Loader.swift
//  MVVMSwift
//
//  Created by Handy Handy on 10/23/17.
//  Copyright © 2017 binus. All rights reserved.
//

import UIKit

fileprivate extension UINib {
    static func nib(named nibName: String) -> UINib {
        return UINib(nibName: nibName, bundle: nil)
    }
    
    static func loadSingleView(_ nibName: String, owner: Any?) -> UIView {
        return nib(named: nibName).instantiate(withOwner: owner, options: nil).first as! UIView
    }
}

extension UINib {
    
    class func loadView(with identifier: String ,_ owner: AnyObject) -> UIView {
        return loadSingleView(identifier, owner: owner)
    }
    
}












