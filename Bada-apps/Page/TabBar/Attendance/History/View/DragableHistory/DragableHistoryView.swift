//
//  DragableHistoryView.swift
//  Bada-apps
//
//  Created by Handy Handy on 16/03/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit

class DragableHistoryView: UIView {
    
    fileprivate weak var dragableHistoryNibView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let dragableHistoryArea: UIView = UINib.loadView(with: Identifier.dragableHistory, self)
        self.addSubview(dragableHistoryArea)
        self.dragableHistoryNibView = dragableHistoryArea
    
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        dragableHistoryNibView.frame = self.bounds
    }
    
}
