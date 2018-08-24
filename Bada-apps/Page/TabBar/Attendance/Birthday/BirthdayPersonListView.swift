//
//  BirthdayPersonListView.swift
//  Bada-apps
//
//  Created by octavianus on 31/07/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit

class BirthdayPersonCollectionView: UIView{
    
    @IBOutlet weak var birthdayPersonList: UICollectionView!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let birthdayPersonList: UIView = UINib.loadView(with: Identifier.birthdayPersonCollection, self)
        self.addSubview(birthdayPersonList)
        setup()
    }
    
    private func setup(){
        self.birthdayPersonList.register(UINib(nibName: "BirthdayPersonListCell", bundle: nil), forCellWithReuseIdentifier: Identifier.birthdayPersonList)
        self.birthdayPersonList.delegate = self
        self.birthdayPersonList.dataSource = self
    }
    
}

extension BirthdayPersonCollectionView:
