//
//  BaseAnimation.swift
//  Bada-apps
//
//  Created by Handy Handy on 16/03/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit

enum ModalAnimatedTransitioningType {
    case present
    case dismiss
}

class BaseAnimator: NSObject {
    
    var transitionType: ModalAnimatedTransitioningType = .present
    
    func animatePresentingInContext(transitionContext: UIViewControllerContextTransitioning, fromVC: UIViewController, toVC: UIViewController) {
        NSException(name: NSExceptionName.internalInconsistencyException, reason:"\(#function) must be overridden in a subclass/category", userInfo:nil).raise()
    }
    
    func animateDismissingInContext(transitionContext: UIViewControllerContextTransitioning, fromVC: UIViewController, toVC: UIViewController) {
        NSException(name: NSExceptionName.internalInconsistencyException, reason:"\(#function) must be overridden in a subclass/category", userInfo:nil).raise()
    }
    
}

extension BaseAnimator: UIViewControllerAnimatedTransitioning {
    
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let from =
            transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let to = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        
        if let from = from, let to = to {
            switch transitionType {
            case .present:
                animatePresentingInContext(transitionContext: transitionContext, fromVC: from, toVC: to)
            case .dismiss:
                animateDismissingInContext(transitionContext: transitionContext, fromVC: from, toVC: to)
            }
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        NSException(name: NSExceptionName.internalInconsistencyException, reason:"\(#function) must be overridden in a subclass/category", userInfo:nil).raise()
        return 0
    }
}











