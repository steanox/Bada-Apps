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

protocol BirthdayMainActionButtonViewDelegate {
    func giveWishes()
    func viewWishes()
}

class BirthdayMainActionButtonView: UIView{
    
    @IBOutlet weak var actionIcon: UIButton!
    var delegate: BirthdayMainActionButtonViewDelegate?

    public var currentState: BirthdayAction?{
        didSet{
        }
    }
    
    
    public var totalNotification: Int?{
        didSet{
            setupNotification()
        }
    }
    
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
        self.addAnimation()
        
    }
    
    private func addAnimation(){
        let rotate = CASpringAnimation(keyPath: "transform.rotation")
        rotate.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        rotate.fromValue = 0
        rotate.toValue = -0.25
        rotate.duration = 1.0
        rotate.damping = 2.0
        rotate.mass = 1.0
        rotate.speed = 1.0
        rotate.autoreverses = true
        rotate.repeatCount = Float.infinity
        
        actionIcon.layer.add(rotate, forKey: "rotateButton")
        
    }
    
    @IBAction func handleTap(){
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
        delegate?.giveWishes()
    }
    
    private func viewWished(){
        delegate?.viewWishes()
    }
    
    private func setupNotification(){
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

