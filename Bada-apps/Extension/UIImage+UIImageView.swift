//
//  UIImage.swift
//  Bada-apps
//
//  Created by Octavianus . on 5/15/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit
import Dispatch



extension UIImage{
    
}

extension UIImageView{
    
    
    func loadImageUsingCacheWith(urlString: String){
        
        
        //self.image = nil //prevent flashing
        
        //check image cache
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage{
            self.image = cachedImage
            return
        }
        
        
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil{
                print(error)
                return
            }
            
            DispatchQueue.main.async {
                
                guard let downloadedImage = UIImage(data: data!) else { return }
                
                imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                self.image = downloadedImage
                
            }
            
        }).resume()
        
    }
}
