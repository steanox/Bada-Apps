//
//  Gradient+Image.swift
//  Bada-apps
//
//  Created by Handy Handy on 05/07/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit

extension CAGradientLayer {
    
    convenience init(frame: CGRect, colors: [UIColor]) {
        self.init()
        self.frame = frame
        self.colors = []
        for color in colors {
            self.colors?.append(color.cgColor)
        }
        startPoint = CGPoint(x: 0, y: 0)
        endPoint = CGPoint(x: 1, y: 0)
    }
    
    func createGradientImage() -> UIImage? {
        
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
    
}

extension UINavigationBar {
    
    func setGradientBackground(colors: [UIColor]) {
        barTintColor = UIColor(patternImage: #imageLiteral(resourceName: "TopBackground"))
        isTranslucent = false
    }
    
    func setupNavigationBar() {
        var colors = [UIColor]()
        colors.append(UIColor.init(rgb: Color.profileImageColor))
        colors.append(UIColor.init(rgb: Color.attendanceImageColor))
        self.setGradientBackground(colors: colors)
        
    }
}
