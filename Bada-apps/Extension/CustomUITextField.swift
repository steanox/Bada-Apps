//
//  CustomUITextField.swift
//  Bada-apps
//
//  Created by Octavianus . on 08/03/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit

class CustomUITextField: UITextField {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.borderColor = UIColor(rgb: Color.formColor).cgColor
        self.layer.borderWidth = 1
        self.leftViewMode = .always
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds,
                                     UIEdgeInsetsMake(0, 10, 0, 15))
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        
        
        return UIEdgeInsetsInsetRect(bounds,
                                     UIEdgeInsetsMake(0, 10, 0, 10))
    }
    

    
}
