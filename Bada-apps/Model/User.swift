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

enum UserCheck:Error{
    case userNotExists
    case wrongDateOfBirth
    case somethingWentWrong
}

class User{
    
    typealias errorHandler = (_ error: Error) -> Void
    typealias registerSuccessHandler = () -> Void
    typealias loginSuccessHandler = (_ user: Any)->Void
    
    var email: String?
    var name: String?
    
    static var email: String {
        get{
            if let user = Auth.auth().currentUser{
                return user.value(forKeyPath: "email") as! String
            }
            
            return ""
        }
    }

    
    static func getUser()->User{
        let currentUser = Auth.auth().currentUser
        
        let user = User()
        user.email = currentUser?.value(forKeyPath: "email") as? String
        //user.name = currentUser?.value(forKeyPath: "name") as? String
        
        return user
        
    }
    
    static func register(appleID: String,fullName: String, dateOfBirth: String, userData:[String:Any] = [:],onSuccess: @escaping registerSuccessHandler ,onError:@escaping errorHandler)  {
        
        do{
            let tripleDesEnc = TripleDesEncryptor()
            let mailData = try tripleDesEnc.encrypt(data: appleID.toData()!) as NSData
            
            Database.database().reference().child("checkUser").observeSingleEvent(of: .value) { (snapshot) in
                
                //check if the inputted appleID is exists on the checkUser node
                if snapshot.hasChild(mailData.toHexString!){
                    snapshot.ref.child(mailData.toHexString!).observeSingleEvent(of: .value, with: { (userSnapshot) in
                        
                        let data = userSnapshot.value as! [String:String]
                        let dateData = data["dateOfBirth"]
                        
                        if dateOfBirth == dateData{
                            
        
                            let password = String(mailData.toHexString!.prefix(10))
                            Auth.auth().createUser(withEmail: appleID, password: password) { (user, error) in
                                if error != nil{
                                    onError(error!)
                                    return
                                }
                                
                                guard let uid = user?.uid else{
                                    
                                    onError(UserCheck.somethingWentWrong)
                                    return
                                }
                                
                                
                                Mailer.sendPasswordMail(fullname: fullName, email: appleID, password: password)
                                
                                
                                if error != nil{
                                    onError(error!)
                                    return
                                }
                                var values = userData
                                values["email"] = appleID
                                values["status"] = 0
                                
                                
                                
                                Database.database().reference(withPath: "users").child(uid).updateChildValues(values, withCompletionBlock: { (error, currentRef) in
                                    if error != nil{
                                        onError(error!)
                                        return
                                    }
                                    
                                    
                                    onSuccess()
                                })
                            }
                            
                        }else{
                            
                            onError(UserCheck.wrongDateOfBirth)
                            return
                        }
                    })
                }else{
                    onError(UserCheck.userNotExists)
                    return
                }
            }
            
        }catch{
            onError(UserCheck.somethingWentWrong)
            return
        }
    }
    
    private func sendVerificationEmail(){
        
    }
    
    
    
    static func login(email: String, password: String, onSuccess: @escaping loginSuccessHandler,onError: @escaping errorHandler){
        
        
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil{
                onError(error!)
                return
            }
            //TODO:- Make sure how the user for login
//            Database.database().reference(withPath: "users").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
//
//            })
            
            
            onSuccess(user as Any)
        }
        
    }
    

    
}

