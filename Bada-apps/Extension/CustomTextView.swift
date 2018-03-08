//
//  CustomTextView.swift
//  Bada-apps
//
//  Created by Handy Handy on 08/03/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit

class CustomTextView: UITextView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.borderColor = UIColor(rgb: Color.formColor).cgColor
        self.layer.borderWidth = 1
        
    }
    
}
