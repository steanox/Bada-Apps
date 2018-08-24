//
//  SkimmerEffect.swift
//  Bada-apps
//
//  Created by Handy Handy on 22/07/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit

extension UIView {
    
    func applySkimmerEffect() {
        let darkView = UIView()
        darkView.backgroundColor = UIColor.init(rgb: Color.silver)
        let yPosition = -200
        darkView.frame = CGRect(x: 0, y: yPosition, width: 1000, height: 1000)
        
        let shineView = UIView()
        shineView.backgroundColor = UIColor.init(rgb: Color.mercury)
        shineView.frame = CGRect(x: 0, y: yPosition, width: 1000, height: 1000)
        
        shineView.addSubview(darkView)
        shineView.tag = Identifier.skimmerTag
        self.addSubview(shineView)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor,
                                UIColor.init(rgb: Color.mercury).cgColor,
                                UIColor.clear.cgColor]
        gradientLayer.locations = [0, 0.5, 1]
        gradientLayer.frame = darkView.frame
        
        let angle = 75.0 * CGFloat.pi / 180.0
        gradientLayer.transform = CATransform3DMakeRotation(angle, 0, 0, 1)
        
        darkView.layer.mask = gradientLayer
        self.layer.masksToBounds = true
        
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = 2.0
        animation.fromValue = -(darkView.frame.width)
        animation.toValue = darkView.frame.width - 200
        animation.repeatCount = .infinity
        
        gradientLayer.add(animation, forKey: "SKIMMER EFFECT")
    }
    
    func removeSkimmerEffect() {
        for subview in self.subviews {
            if subview.tag == Identifier.skimmerTag {
                let item = subview.subviews[0]
                item.layer.removeFromSuperlayer()
                subview.removeFromSuperview()
            }
        }
    }
    
    func skimmer(state: ShimmerState, views: UIView...) {
        for view in views {
            switch state {
            case .start:
                view.applySkimmerEffect()
            case .stop:
                view.removeSkimmerEffect()
            }
        }
        
    }
    
}

enum ShimmerState {
    case start
    case stop
}



