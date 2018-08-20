//
//  BirthdayPhotoCell.swift
//  Bada-apps
//
//  Created by octavianus on 27/07/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit

class BirthdayPhotoCell: UICollectionViewCell{
    
    @IBOutlet weak var photo: UIImageView!
    
    var imageURL: String? {
        didSet{
            if let pic = imageURL{
                self.photo.loadImageUsingCacheWith(urlString: pic){ [weak self] in
                    self?.layer.cornerRadius = (self?.frame.width)! / 2
                    self?.layer.masksToBounds = true
                    self?.backgroundColor =  UIColor.clear
                    self?.isHidden = false
                }
            }
        }
    }
}
