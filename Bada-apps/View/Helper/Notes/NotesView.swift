//
//  NotesView.swift
//  Bada-apps
//
//  Created by Handy Handy on 08/03/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit

class NotesView: UIView {

    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    
    fileprivate weak var notesNibView: UIView!
    
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
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame =  self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(blurEffectView, at: 0)
        
        self.noteLabel.text = title
        self.applyShadow(0)
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }) { (true) in
            self.removeFromSuperview()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        close()
    }
    
    
    
    
    
    
    
    
}
