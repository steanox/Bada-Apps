//
//  BirthdayNotification.swift
//  Bada-apps
//
//  Created by octavianus on 07/06/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit



class BirthdayNotificationView: UIView{
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var container: UIView!
    
    
    var onSuccess:  (()-> Void )?
    
    
    fileprivate weak var notificationBirthdayNibView: UIView!
    
    
    init(frame: CGRect,for name: String,profilePictureURL: String?,onSuccess: (()-> Void)? ) {
        super.init(frame: frame)
        self.onSuccess = onSuccess
        setup(name,profilePictureURL)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
    
    func setup(_ name: String, _ profilePictureURL: String?){
        let bNotification = UINib.loadView(with: Identifier.birthdayNotification, self)
        self.container.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame =  self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(blurEffectView, at: 0)
        
        self.name.text = name
        
        

        self.container.layer.cornerRadius = 10
        
        self.profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2
        self.profilePicture.layer.masksToBounds = true
        
        if let pic = profilePictureURL{
            self.isHidden = true
            self.profilePicture.loadImageUsingCacheWith(urlString: pic){
                self.isHidden = false
                self.addSubview(bNotification)
                
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1.5, initialSpringVelocity: 1, options: [.curveEaseInOut], animations: {
                    self.container.transform = CGAffineTransform.identity
                    let confetti = ConfettiEmitter(for: self)
                    confetti.startBirthDayConfetti(on: self)
                }, completion: { (true) in

                })
                self.notificationBirthdayNibView = bNotification
            }
        }else{
            self.profilePicture.image = #imageLiteral(resourceName: "ProfilePictDummy")
        }
        
        
        
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
