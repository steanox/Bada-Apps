//
//  BirthdayViewController.swift
//  Bada-apps
//
//  Created by octavianus on 21/08/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit

class BirthdayViewController: UIViewController{
    
    @IBOutlet weak var birthdayCollection: BirthdayPersonCollectionView!
    var data: [Birthday] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        birthdayCollection.birthdayData = data
    }
    
}
