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
import FirebaseStorage



enum UserCheck:Error{
    case userNotExists
    case wrongDateOfBirth
    case somethingWentWrong
}

class User{
    
    typealias errorHandler = (_ error: Error) -> Void
    typealias successHandler = () -> Void
    typealias registerSuccessHandler = () -> Void
    typealias loginSuccessHandler = (_ user: Any)->Void
    typealias resetSuccessHandler = (String)->Void
    
    var email: String?
    var name: String?
    var uid: String?
    
    
    func getName(_ completion: @escaping ((String?)->())) {
        guard let uid = Auth.auth().currentUser?.uid else {completion(nil);return}
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            let userData = snapshot.value as? NSDictionary
            let name = userData?["name"] as? String ?? ""
            completion(name)
        }
    }
    
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
        user.uid = currentUser?.uid
        

        
        return user
        
    }
    
    static func getProfilePictureURL(onSuccess: @escaping (String)->() ){
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        
        if let cachedImageURL = UserDefaults.standard.object(forKey: userUID) as? String{
            onSuccess(cachedImageURL)
        }else{
            Database.database().reference().child("users").child(userUID).observeSingleEvent(of: .value) { (snapshot) in
                
                guard let value = snapshot.value as? [String : Any] else { return }
                
                if let profilePictureURL = value["profilePictureURL"] as? String{
                  
                    UserDefaults.standard.set(profilePictureURL as Any, forKey: userUID)
                    onSuccess(profilePictureURL)
                }
            }
        }
    }
    
    
    static func getAttendanceHistory(by limit: Int,offset: String,onResponse: @escaping (_ AttendanceData: [String:Any])->())->UInt{
        guard let uid = Auth.auth().currentUser?.uid else {return 0}
        let ref = Database.database().reference()
 
        return ref.child("users/\(uid)/attendances").queryOrderedByKey().queryEnding(atValue: offset as Any).queryLimited(toLast: UInt(limit)).observe(.value) { (snapshot) in
            guard let attendances = snapshot.value as? [String: Any] else { return }
            onResponse(attendances)
        }
    }
    
    static func upload(profilePicture: UIImage,onSuccess: @escaping ()->()){
        
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        UserDefaults.standard.removeObject(forKey: userUID)
        let storageRef = Storage.storage().reference().child(Identifier.profilePictureStoragePath).child("\(userUID).png")
        
        if let imageData = UIImageJPEGRepresentation(profilePicture, 0.25){
            
            storageRef.putData(imageData, metadata: nil) { (meta, err) in
                if err != nil {
                    let message = err.debugDescription
                    print(message)
                    return
                }
                
                storageRef.downloadURL(completion: { (url, err) in
                    
                    if err != nil{
                        return
                    }
                    
                    guard let imageURL =  url?.absoluteString else { return }
                    
                    let imageValue = ["profilePictureURL" : imageURL]
                    
                    Database.database().reference().child("users").child(userUID).updateChildValues(imageValue)
                    onSuccess()
                })

                

            }
        }
    }
    
    static func checkBirthDataCache(onSuccess response: @escaping ()->()){
        
        if let _ = UserDefaults.standard.object(forKey: "birthDate") as? String{
            response()
        }else{
            Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value) { (snapshot) in
                guard let data = snapshot.value as? [String:Any] else { return }
                guard let birthDate = data["birthDate"] as? String else { return }
                UserDefaults.standard.set(birthDate as Any, forKey: "birthDate")
                UserDefaults.standard.synchronize()
                response()
            }
        }
    }
    
    
    
    
    
    static func register(appleID: String, fullName: String, dateOfBirth: String, userData:[String:Any] = [:],onSuccess: @escaping registerSuccessHandler ,onError:@escaping errorHandler)  {
        
        do{
            //Encryting the Email to tripleDes
            let tripleDesEnc = TripleDesEncryptor()
            let data = appleID.data(using:String.Encoding.utf8)!
            let mailData = try tripleDesEnc.encrypt(data: data) as NSData
            guard let myMailData = mailData.toHexString else {return}

            //check if the inputted appleID is exists on the checkUser node
            Database.database().reference().child("checkUser").observeSingleEvent(of: .value) { (snapshot) in
                
                if snapshot.hasChild("\(myMailData)"){
                    snapshot.ref.child("\(myMailData)").observeSingleEvent(of: .value, with: { (userSnapshot) in
                        
                        guard let data = userSnapshot.value as? [String:String] else { return }
                        guard let dateData = data["dateOfBirth"] else {return}
                        
                        if dateOfBirth == dateData{
                            let password = String("\(myMailData)".prefix(10))
                            Auth.auth().createUser(withEmail: appleID, password: password) { (user, error) in
                                if error != nil{
                                    onError(error!)
                                    return
                                }
                                
                                
                                guard let uid = user?.user.uid else{
                                    
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
                                values["name"] = fullName
                                values["birthDate"] = dateData[dateData.index(dateData.startIndex, offsetBy: 5)...]
                                
                                
                                
                                
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
    
    static func resetPassword(email: String, onSuccess: @escaping resetSuccessHandler,onError: @escaping errorHandler) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error != nil {
                onError(error!)
                return
            }else {
                onSuccess(Message.resetPasswordSuccess)
            }
        }
    }
    
    static func logout(onSuccess: @escaping successHandler, onError: @escaping errorHandler) {
        do{
            try Auth.auth().signOut()
            onSuccess()
        }catch let error {
            onError(error)
        }
    }
    
    
}

