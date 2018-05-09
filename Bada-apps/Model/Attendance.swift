//
//  Attendance.swift
//  Bada-Apps
//
//  Created by Octavianus . on 06/03/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

enum Status{
    case checkIn
    case checkOut
}

enum AttendanceType{
    case notEligibleTime
    case checkIn
    case late
    case earlyLeave
    case notCheckIn
    
    case checkOut
    case error

}

protocol AttendanceDelegate {
    func attendanceSuccess()
    func attendanceOnProgress()
    func attendanceFailed(error: String)
    func attendanceRemoveProgress()
}

class Attendance{
    
    var dateID: String?
    var status: AttendanceType {
        get{
            return checkStatus()
        }
    }
    var userID = Auth.auth().currentUser?.uid
    var notes: String?
    var time: String?
    var delegate: AttendanceDelegate?
    var ref: DatabaseReference = Database.database().reference()
    
    var dateComponent: DateComponents!{
        didSet{
            self.time = "\(dateComponent.hour!):\(dateComponent.minute!):\(dateComponent.second!)"
            
            
            let formatter = DateFormatter()
            let calendar = Calendar(identifier: .gregorian)
            guard let date = calendar.date(from: dateComponent) else { return }
            formatter.dateFormat = "yyyyMMdd"
            
           
            self.dateID = formatter.string(from: date)
            
            //self.dateID = "\(dateComponent.year!)\(dateComponent.month!)\(dateComponent.day!)"
        }
    }
    
    
    init(for user: User, notes:String?) {
        
        //check if user is logged in or not
        guard (Auth.auth().currentUser) != nil else { return }
        
        self.notes = notes
        self.updateTime()
       
        
    }
    
    func performWithNotes(){
        switch status {
        case .late:
            performCheckIn()
        case .earlyLeave:
            performCheckOut()
        default:
            self.delegate?.attendanceFailed(error: "You cannot perform")
        }
    }
    
    func performCheckIn(){
        delegate?.attendanceOnProgress()
        if let _ = dateID,let _ = time{
         
            var data: [String:Any] = ["status":"1","checkInTime":self.time as Any]
            
            //check if notes avaiable
            
            if let notes = notes{
                data["checkInNotes"] = notes
            }
            
            self.ref.child("attendance/\(self.dateID!)/\(self.userID!)").observeSingleEvent(of: .value) { (snapshot) in
                
                //check if user already check in or not

                if !snapshot.hasChild("checkInTime") && !snapshot.hasChild("checkOutTime") , let timeInput = self.time ,let dateID = self.dateID{
                    snapshot.ref.setValue(data, withCompletionBlock: {[weak self] (error, currentRef) in
                        
                    
                        let keyname = "checkIn\(dateID)"
                        
                        print("time: \(timeInput) --- dateid: \(dateID)")
                        
                        userData.set(timeInput as? Any, forKey: keyname)
                        
                        print(userData.object(forKey: keyname))
                        
                        self?.delegate?.attendanceRemoveProgress()
                        if error != nil {
                            currentRef.cancelDisconnectOperations()
                            guard let error = error?.localizedDescription else {return}
                            self?.delegate?.attendanceFailed(error: error )
                            return
                        }
                        

                        //lastCheckIn.setObject((self?.time)! as AnyObject, forKey: (self?.dateID)! as AnyObject)
 
                        self?.delegate?.attendanceSuccess()
                        
                    })
                }else{
                    self.delegate?.attendanceRemoveProgress()
                    self.delegate?.attendanceFailed(error: "You cannot check in again for today")
                }
                
            }
        }
        
    }
    
     func checkStatus()-> AttendanceType{

        let dateComponent = Calendar.current.dateComponents(in: TimeZone.current, from: Date())
        
        if let data = lastCheckIn.object(forKey: dateID! as AnyObject){

        }else{
            
        }
        
        let minute = (String(dateComponent.minute!).count < 2) ? "0\(dateComponent.minute!)" : "\(dateComponent.minute!)"
        let hour = (String(dateComponent.hour!).count < 2) ? "0\(dateComponent.hour!)" : "\(dateComponent.hour!)"
        
        
        
        
       guard let currentTime = Int("\(hour)\(minute)") else {return AttendanceType.error}
        
        if currentTime < Identifier.checkInStartTime{
            return .notEligibleTime
        }else
        if currentTime > Identifier.checkInStartTime && currentTime < Identifier.checkInLimitTime && !isCheckIn(){
            return .checkIn
        }else
        if currentTime > Identifier.checkInLimitTime && !isCheckIn(){
            return .late
        }else
        if isCheckIn(){
            
            if  currentTime < Identifier.checkOutTime{
                return .earlyLeave
            }
            else{
                
                if isCheckOut(){
                    return .notEligibleTime
                }else{
                   return .checkOut
                }
                
            }
            
            
        }else{
            return .notCheckIn
        }

        
        
    }
    
    func performCheckOut(){
        delegate?.attendanceOnProgress()
        if let _ = dateID,let _ = time{
            var data: [String:Any] = ["status":"2","checkOutTime":self.time as Any]
            
            if let notes = notes{
                data["checkOutNotes"] = notes
            }
            
            
            self.ref.child("attendance/\(self.dateID!)/\(self.userID!)").observeSingleEvent(of: .value) { (snapshot) in
                
                if !snapshot.hasChild("checkOutTime") , let timeInput = self.time , let dateID = self.dateID {
                    snapshot.ref.updateChildValues(data, withCompletionBlock: {[weak self] (error, currentRef) in

                        
                        let keyname = "checkOut\(dateID)"
                        
                        userData.set(timeInput as? Any, forKey: keyname)
                        
                        self?.delegate?.attendanceRemoveProgress()
                        
                        if error != nil{
                            currentRef.cancelDisconnectOperations()
                            guard let error = error?.localizedDescription else {return}
                            self?.delegate?.attendanceFailed(error: error)
                            return
                        }
                        
                        //lastCheckOut.setObject(self?.time as AnyObject, forKey: (self?.dateID)! as AnyObject)
                        
                        self?.delegate?.attendanceSuccess()
                    })
                }else{
                    self.delegate?.attendanceRemoveProgress()
                    self.delegate?.attendanceFailed(error: "You cannot check out again for today")
                }
                
            }
        }
        
    }
    
//    static func checkAttendanceForToday(){
//        let userID = Auth.auth().currentUser?.uid
//        let dateComponent = Calendar.current.dateComponents(in: TimeZone.current, from: Date())
//        let dateID = "\(dateComponent.year!)\(dateComponent.month!)\(dateComponent.day!)"
//        
//        Database.database().reference().child("attendances/\(dateID)/\(userID)").observe(.value) { (snapshot) in
//            
//            if snapshot.hasChild("checkInTime"){
//                
//            }else{
//                
//            }
//        }
//    }
    
    static func observeForStatus(onResponse: @escaping (ClockStatus)->()){
        
        let userID = (Auth.auth().currentUser?.uid)!
        let dateComponent = Calendar.current.dateComponents(in: TimeZone.current, from: Date())
        
        let formatter = DateFormatter()
        let calendar = Calendar(identifier: .gregorian)
        guard let date = calendar.date(from: dateComponent) else { return }
        formatter.dateFormat = "yyyyMMdd"
        
        let dateID = formatter.string(from: date)
        Database.database().reference().removeAllObservers()
        Database.database().reference().child("attendance/\(dateID)/\(userID)").observe(.value, with: { (snapshot) in
    
       
            if snapshot.value == nil {
                onResponse(._notYet)
            }
            else
            if snapshot.hasChild("checkInTime") && !snapshot.hasChild("checkOutTime") {
                
                onResponse(._in)
            }
            else
            if snapshot.hasChild("checkOutTime") && snapshot.hasChild("checkInTime"){
               
                onResponse(._out)
            }
            else {
                onResponse(._notYet)
            }
            
        }) { (error) in
         
        }
        
    }
    
    private func isCheckIn()->Bool{
        
    
//        if let _ = lastCheckIn.object(forKey: self.dateID! as AnyObject){
//            return true
//        }else{
//            return false
//        }
        
        if let _ = userData.object(forKey: "checkIn\(dateID!)"){
            return true
        }else{
            return false
        }
    }
    
    private func isCheckOut()->Bool{
//        if let _ = lastCheckOut.object(forKey: self.dateID! as AnyObject){
//            return true
//        }else{
//            return false
//        }
        if let _ = userData.object(forKey: "checkOut\(dateID!)"){
            return true
        }else{
            return false
        }
    }
    
    private func updateTime(){
        
        dateComponent = Calendar.current.dateComponents(in: TimeZone.current, from: Date())
    }

    static func getDateID() -> String? {
        let dateComponent = Calendar.current.dateComponents(in: TimeZone.current, from: Date())
        return "\(dateComponent.year!)\(dateComponent.month!)\(dateComponent.day!)"
    }
    
}
