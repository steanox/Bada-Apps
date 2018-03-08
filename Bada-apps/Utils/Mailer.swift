//
//  File.swift
//  Bada-apps
//
//  Created by Octavianus . on 08/03/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import Foundation


class Mailer{
    
    
    static func sendPasswordMail(fullname: String,email:String,password: String){
        
        let url = URL(string: "\(Identifier.firebaseURL)send-email")
        
        var request = URLRequest(url: url!)
        request.addValue(fullname, forHTTPHeaderField: "fullname")
        request.addValue(email, forHTTPHeaderField: "email")
        request.addValue(password, forHTTPHeaderField: "password")
        
        request.httpMethod = "GET"
        
        let session = URLSession.shared.dataTask(with: request)
        session.resume()
        
    }
}
