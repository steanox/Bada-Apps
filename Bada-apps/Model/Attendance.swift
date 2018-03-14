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
    case late
    case earlyLeave
    case notCheckIn
    case checkIn
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
            self.dateID = "\(dateComponent.year!)\(dateComponent.month!)\(dateComponent.day!)"
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
                if !snapshot.hasChild("checkInTime") && !snapshot.hasChild("checkOutTime"){
                    snapshot.ref.setValue(data, withCompletionBlock: {[weak self] (error, currentRef) in
                        self?.delegate?.attendanceRemoveProgress()
                        if error != nil {
                            currentRef.cancelDisconnectOperations()
                            guard let error = error?.localizedDescription else {return}
                            self?.delegate?.attendanceFailed(error: error )
                            return
                        }
                        checkInStatus.setObject("checkIn" as AnyObject, forKey: (self?.dateID)! as AnyObject)
                        
                        self?.delegate?.attendanceSuccess()
                        
                    })
                }else{
                    self.delegate?.attendanceRemoveProgress()
                    self.delegate?.attendanceFailed(error: "You cannot attend again for today")
                }
                
            }
        }
        
    }
    
     func checkStatus()-> AttendanceType{
        let dateComponent = Calendar.current.dateComponents(in: TimeZone.current, from: Date())
        
        if let data = checkInStatus.object(forKey: dateID! as AnyObject){
                print("already check In")
            print(data)
        }else{
            print("notcheck in")
        }
        
        let minute = (String(dateComponent.minute!).count < 2) ? "0\(dateComponent.minute!)" : "\(dateComponent.minute!)"
        
        
        
        
       guard let currentTime = Int("\(dateComponent.hour!)\(minute)") else {return AttendanceType.error}
        print("current time: \(currentTime)")
        if currentTime < Identifier.checkInStartTime{
            return .notEligibleTime
        }else
        if currentTime > Identifier.checkInStartTime && currentTime < Identifier.checkInLimitTime{
            return .checkIn
        }else
        if currentTime > Identifier.checkInLimitTime && !isCheckIn(){
            return .late
        }else
        if isCheckIn(){
            print("you already check In")
            if  currentTime < Identifier.checkOutTime{
                return .earlyLeave
            }else{
                return .checkOut
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
                
                if !snapshot.hasChild("checkOutTime"){
                    snapshot.ref.updateChildValues(data, withCompletionBlock: {[weak self] (error, currentRef) in
                        self?.delegate?.attendanceRemoveProgress()
                        if error != nil{
                            currentRef.cancelDisconnectOperations()
                            guard let error = error?.localizedDescription else {return}
                            self?.delegate?.attendanceFailed(error: error)
                            return
                        }
                        self?.delegate?.attendanceSuccess()
                    })
                }
                
            }
        }
        
    }
    
    static func checkAttendanceForToday(){
        let userID = Auth.auth().currentUser?.uid
        let dateComponent = Calendar.current.dateComponents(in: TimeZone.current, from: Date())
        let dateID = "\(dateComponent.year!)\(dateComponent.month!)\(dateComponent.day!)"
        
        Database.database().reference().child("attendances/\(dateID)/\(userID)").observe(.value) { (snapshot) in
            
            if snapshot.hasChild("checkInTime"){
                
            }else{
                
            }
        }
    }
    
    static func observeForStatus(onResponse: @escaping (ClockStatus)->()){
        let userID = (Auth.auth().currentUser?.uid)!
        let dateComponent = Calendar.current.dateComponents(in: TimeZone.current, from: Date())
        let dateID = "\(dateComponent.year!)\(dateComponent.month!)\(dateComponent.day!)"
        
        Database.database().reference().child("attendance/\(dateID)/\(userID)").observe(.childAdded, with: { (snapshot) in
            
            if snapshot.key == "checkInTime"{
                
                onResponse(._in)
            }
            
            if snapshot.key == "checkOutTime"{
               
                onResponse(._out)
            }
            
            
        }) { (error) in
            print(error)
        }
        
    }
    
    private func isCheckIn()->Bool{
        if let _ = checkInStatus.object(forKey: self.dateID! as! AnyObject){
            return true
        }else{
            return false
        }
    }
    
    private func updateTime(){
        dateComponent = Calendar.current.dateComponents(in: TimeZone.current, from: Date())
    }
    
    
    
    
    
    
}
