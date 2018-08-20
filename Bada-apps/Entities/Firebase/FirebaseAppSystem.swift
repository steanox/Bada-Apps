//
//  FirebaseAppSystem.swift
//  Bada-apps
//
//  Created by octavianus on 05/07/18.
//  Copyright © 2018 Bada. All rights reserved.
//
import Foundation
import FirebaseDatabase




class FirebaseAppSystem{
    
    static var config: FirebaseAppSystem = FirebaseAppSystem()
    
    
    func checkForUpdate(onComplete: @escaping (String,Bool)->()){
        Database.database().reference().child("currentBuild").observeSingleEvent(of: .value, with: { (snap) in
            guard let currentBuild = snap.value as? String else { return }
            onComplete(currentBuild,false)
        }) { (err) in
            onComplete("0",true)
        }
    }
    
    func isConnectionEstablished(){
        
    }
    
    
    
}
