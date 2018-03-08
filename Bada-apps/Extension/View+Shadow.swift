//
//  View+Shadow.swift
//  Bada-apps
//
//  Created by Handy Handy on 07/03/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit

extension UIView {
    
    func applyShadow(_ offset: CGFloat) {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.7
        
        let path = UIBezierPath()
        
        // Start at the Top Left Corner
        path.move(to: CGPoint(x: 0.0, y: 1.5))
        
        // Move to the Bottom Left Corner
        path.addLine(to: CGPoint(x: 0.0, y: self.frame.size.height + offset))
        
        // Move to the Bottom Right Corner
        path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height + offset))
        
        // Move to the Top Right Corner
        path.addLine(to: CGPoint(x: self.frame.size.width, y: 1.5))
        
        // This is the extra point in the middle
        path.addLine(to: CGPoint(x: self.frame.size.width/2.0, y: self.frame.size.height/2.0))
        
        path.addLine(to: CGPoint(x: 0.0, y: 1.5))
        
        path.close()
        
        self.layer.shadowPath = path.cgPath
    }
    
    func showNotification(title: String, description: String, buttonText: String,onSuccess: @escaping ()->Void ){
        let notif = NotificationView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), title: title, description: description, buttonText: buttonText,onSuccess: onSuccess)
        
        UIView.transition(with: self, duration: 0.2, options: [.curveEaseInOut,.transitionCrossDissolve], animations: {
            self.addSubview(notif)
        }, completion: nil)
    }
    
    func showNote(title: String) {
        let rect = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        let notes = NotesView(frame: rect, title: title)
        self.addSubview(notes)
        
        notes.alpha = 0.0
        
        UIView.animate(withDuration: 0.2) {
            notes.alpha = 1.0
        }
    
    }
    
    var parentViewController: UIViewController? {
        let parentResponder: UIResponder? = self
        return parentResponder?.viewController
    }
    
}


