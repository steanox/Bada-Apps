//
//  NotesView.swift
//  Bada-apps
//
//  Created by Handy Handy on 08/03/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit

class NotesView: UIView {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var notesTextView: CustomTextView!
    
    fileprivate weak var notesNibView: UIView!

    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    init(frame: CGRect, title: String) {
        super.init(frame: frame)
        
        setup(title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func setup(_ title: String) {
        let notesView = UINib.loadView(with: Identifier.notes, self)
        addSubview(notesView)
        self.notesNibView = notesView
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)

        blurEffectView.frame =  self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(blurEffectView, at: 0)
        
        container.layer.cornerRadius = 35
        container.layer.masksToBounds = true
        
        self.keyboardHeightLayoutConstraint?.constant = -35
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
        
        self.noteLabel.text = title
        self.applyShadow(0)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func tapToDismiss() {
        self.keyboardHeightLayoutConstraint?.constant = -305
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
            self.dismiss()
        }
    }
    
    @IBAction func tapToBlockDismiss() {
        notesTextView.resignFirstResponder()
    }
    
    @objc func dismiss() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }) { (true) in
            self.removeFromSuperview()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = -35.0
            } else {
                self.keyboardHeightLayoutConstraint?.constant = (endFrame?.size.height ?? 0.0) - 35.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    
}
