//
//  BirthdayPersonListCell.swift
//  Bada-apps
//
//  Created by octavianus on 08/08/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit

class BirthdayPersonListCell: UICollectionViewCell{
    
    @IBOutlet weak var profilePicture: UIImageView!
    var buttonAction: (()-> Void)?
    
    @IBAction func handleButton(){
        if let action = buttonAction{
            action()
        }
    }
    
    
    
}
