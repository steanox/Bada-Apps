//
//  BDDate.swift
//  Bada-apps
//
//  Created by Handy Handy on 13/03/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import Foundation

class BDDate {
    
    var networkProcessor: NetworkProcessor?
    typealias onResponse = ((String)->())
    
    init() {
        let timeUrl = URL(string: Identifier.timeUrl)
        networkProcessor = NetworkProcessor(method: .get, url: timeUrl!, parameter: nil)
    }
    
    func getCurrent(_ completion: @escaping onResponse) {
        networkProcessor?.processed({ (data) in
            guard let data = data else {return}
            if let now = String(data: data, encoding: .utf8) {
                completion(now)
            }
        })
    }
    
}


