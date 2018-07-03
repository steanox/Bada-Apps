//
//  News.swift
//  Bada-apps
//
//  Created by octavianus on 21/06/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import Foundation


class News{
    
    let title: String
    let documentID: String
    let content: String = ""
    
    init(id: String,title: String){
        self.documentID = id
        self.title = title
    }
}
