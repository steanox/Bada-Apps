//
//  TextFieldNote.swift
//  Bada-apps
//
//  Created by Handy Handy on 08/03/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit

class NoteTextView: UIView, UITextViewDelegate {
    
    @IBOutlet weak var noteTextField: UITextView!
    @IBOutlet weak var container: UIView!
    
    fileprivate weak var noteTextFieldNibView: UIView!
    
    var previousRect = CGRect.zero

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let noteTextFieldView = UINib.loadView(with: Identifier.noteTextView, self)
        addSubview(noteTextFieldView)
        self.noteTextFieldNibView = noteTextFieldView
        
        noteTextField.delegate = self
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let pos = textView.endOfDocument
        let currentRect = textView.caretRect(for: pos)
        if previousRect != CGRect.zero {
            if currentRect.origin.y > previousRect.origin.y {
                animateHeight(become: .bigger)
            }else if currentRect.origin.y < previousRect.origin.y {
                animateHeight(become: .smaller)
            }
        }
        previousRect = currentRect
    }
    
    func animateHeight(become: Become) {
        
        
        switch become {
        case .bigger:
            UIView.animate(withDuration: 0.2, animations: {
                
            })
        case .smaller:
            print("ngecil")
        }
    
    }
    
}


