//
//  User.swift
//  Bada-Apps
//
//  Created by Octavianus . on 06/03/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase



class User{
    
    typealias errorHandler = (_ error: Error) -> Void
    typealias registerSuccessHandler = () -> Void
    typealias loginSuccessHandler = (_ user: Any)->Void
    
    
    static func register(email: String,password: String,userData:[String:String],onSuccess: @escaping registerSuccessHandler ,onError:@escaping errorHandler){

        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil{
                onError(error!)
                return
            }
            
            guard let uid = user?.uid else{
                onError(error!)
                return
            }
            
            var values = userData
            values["email"] = email
            
            Database.database().reference(withPath: "users").child(uid).updateChildValues(values, withCompletionBlock: { (error, currentRef) in
                
                if error != nil{
                    onError(error!)
                    return
                }
                
                onSuccess()
                
            })
        }
    }
    
    static func login(email: String, password: String, onSuccess: @escaping loginSuccessHandler,onError: @escaping errorHandler){
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if error != nil{
                onError(error!)
                return
            }
            onSuccess(user as Any)
        }
        
    }
    
}
