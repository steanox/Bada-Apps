//
//  BirthdayPersonListView.swift
//  Bada-apps
//
//  Created by octavianus on 31/07/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit

class BirthdayPersonCollectionView: UIView{
    
    @IBOutlet weak var birthdayPersonCollection: UICollectionView!
    let birthdayData: [Birthday] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let birthdayPersonList: UIView = UINib.loadView(with: "BirthdayPersonCollectionView", self)
        self.addSubview(birthdayPersonList)
        setup()
    }
    
    private func setup(){
        self.birthdayPersonCollection.register(UINib(nibName: "BirthdayPersonListCell", bundle: nil), forCellWithReuseIdentifier: Identifier.birthdayPersonListCell)
        self.birthdayPersonCollection.delegate = self
        self.birthdayPersonCollection.dataSource = self
    }
    
}

extension BirthdayPersonCollectionView: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return birthdayData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = birthdayPersonCollection.dequeueReusableCell(withReuseIdentifier: Identifier.birthdayPersonListCell, for: indexPath) as! BirthdayPersonListCell
        
        cell.profilePicture.loadImageUsingCacheWith(urlString: birthdayData[indexPath.row].profileImageURL, done: nil)
        return cell
    }
    
}

extension BirthdayPersonCollectionView:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: self.frame.width, height: self.frame.width * 1.5)
        return size
    }
}
