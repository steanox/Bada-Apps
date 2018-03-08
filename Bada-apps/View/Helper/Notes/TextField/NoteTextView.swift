//
//  TextFieldNote.swift
//  Bada-apps
//
//  Created by Handy Handy on 08/03/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit

class NoteTextView: UIView {

    @IBOutlet weak var noteTextField: UITextView!

    fileprivate weak var noteTextFieldNibView: UIView!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let noteTextFieldView = UINib.loadView(with: Identifier.noteTextView, self)
        addSubview(noteTextFieldView)
        self.noteTextFieldNibView = noteTextFieldView
        
    }

}
