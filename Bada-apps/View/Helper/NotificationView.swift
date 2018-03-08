//
//  NotificationView.swift
//  Bada-apps
//
//  Created by Octavianus . on 07/03/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit


class NotificationView: UIView{
    
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var container: UIView!
    
    var onSuccess:  (()-> Void )?
    
    
    fileprivate weak var notificationNibView: UIView!
    
    
    init(frame: CGRect,title: String,description: String, buttonText: String,onSuccess: (()-> Void)? ) {
        super.init(frame: frame)
        self.onSuccess = onSuccess
        setup(title,description,buttonText)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
    
    func setup(_ title: String, _ description: String, _  buttonText: String){
        let notification = UINib.loadView(with: Identifier.notification, self)
        addSubview(notification)
        self.notificationNibView = notification
        
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame =  self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(blurEffectView, at: 0)
        
        self.titleText.text = title
        self.descriptionText.text = description
        self.button.setTitle(buttonText, for: .normal)
        self.container.applyShadow(1)
        
        
    }
    
    @IBAction func close(){
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }) { (true) in
            if let success = self.onSuccess{
                success()
            }
            self.removeFromSuperview()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        close()
    }
    
    
    
}

