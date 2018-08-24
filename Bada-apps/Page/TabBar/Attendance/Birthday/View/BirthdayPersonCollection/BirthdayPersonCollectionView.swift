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
    var birthdayData: [Birthday] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let birthdayPersonList: UIView = UINib.loadView(with: "BirthdayPersonCollectionView", self)
        self.addSubview(birthdayPersonList)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.width / 2
        cell.profilePicture.layer.masksToBounds = true
        cell.backgroundColor = UIColor.red
        
        
        return cell
    }
    
}

extension BirthdayPersonCollectionView:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat  = 35
        let collectionSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionSize / 2, height: collectionSize / 3)
    }
    

}
