//
//  BirthdayNotification.swift
//  Bada-apps
//
//  Created by octavianus on 07/06/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit



class BirthdayNotificationView: UIView{
    
    @IBOutlet weak var photoCollection: UICollectionView!
    @IBOutlet weak var container: UIView!
    
    var birthdayData: [Birthday] = []
    
    var onSuccess:  (()-> Void )?
    
    fileprivate weak var notificationBirthdayNibView: UIView!
    
    init(frame: CGRect,profilePictureURL: [Birthday],onSuccess: (()-> Void)? ) {
        super.init(frame: frame)
        self.onSuccess = onSuccess
        self.birthdayData = profilePictureURL
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    private func setup(){
        let bNotification = UINib.loadView(with: Identifier.birthdayNotification, self)
        
        self.photoCollection.register(UINib(nibName: "BirthdayPhotoCell", bundle: nil), forCellWithReuseIdentifier: Identifier.birthdayPhotoCell)
        self.photoCollection.alwaysBounceHorizontal = true
        self.photoCollection.dataSource = self
        self.photoCollection.delegate = self
        self.photoCollection.backgroundColor = UIColor.clear
        self.photoCollection.indicatorStyle = .white
        
        //Setup the blur effect
        self.container.transform = CGAffineTransform(scaleX: 0, y: 0)
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame =  self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(blurEffectView, at: 0)
        
        self.container.layer.cornerRadius = 10
        
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

extension BirthdayNotificationView: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return birthdayData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photoCollection.dequeueReusableCell(withReuseIdentifier: Identifier.birthdayPhotoCell, for: indexPath) as! BirthdayPhotoCell
        cell.isHidden = true
        cell.imageURL = birthdayData[indexPath.row].profileImageURL
       
        return cell
    }
    
    
}

extension BirthdayNotificationView: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let perView = self.container.frame.width / 5
        let size = CGSize(width: perView, height:  perView)
        return size
    }
    
    
    
    
    
}


