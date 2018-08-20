//
//  BIrthdayMainActionButtonView.swift
//  Bada-apps
//
//  Created by octavianus on 26/07/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit

enum BirthdayAction{
    case giveWishes
    case viewWished
}

class BirthdayMainActionButtonView: UIView{
    
    @IBOutlet weak var actionIcon: UIButton!
    
    public var currentState: BirthdayAction?{
        didSet{
            
        }
    }
    public var totalNotification: Int?
    
    init(frame: CGRect,for action: BirthdayAction,totalNotification: Int){
        super.init(frame: frame)
        
        let birthdayAction = UINib.loadView(with: Identifier.birthdayMainAction, self)
        
        self.currentState = action
        
        if let state = currentState {
            switch state {
            case .giveWishes:
                self.actionIcon.setImage(UIImage(named: "popper"), for: .normal)
            case .viewWished:
                self.actionIcon.setImage(UIImage(named: "present"), for: .normal)
            }
        }
        
        self.totalNotification = totalNotification
        self.addSubview(birthdayAction)
        
    }
    
    @IBAction func handleTap(){
        print("asd")
        if let state = self.currentState{
            switch state{
            case .giveWishes:
                self.giveWishes()
            case .viewWished:
                self.viewWished()
            }
        }
    }
    
    private func giveWishes(){

    }
    
    private func viewWished(){
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

