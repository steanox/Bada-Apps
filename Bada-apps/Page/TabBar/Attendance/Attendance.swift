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
import FirebaseAnalytics

enum Status{
    case checkIn
    case checkOut
}

enum ClockStatus {
    case _notYet
    case _in
    case _out
    case _done
    case _error
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
    var time: String?
    var delegate: AttendanceDelegate?
    var ref: DatabaseReference = Database.database().reference()
    
    var attendancePath: DatabaseReference!
    var userAttendancePath: DatabaseReference!
    
    var handle:UInt!
    
    var dateComponent: DateComponents!{
        didSet{
            self.time = "\(dateComponent.hour!):\(dateComponent.minute!):\(dateComponent.second!)"
            self.dateID = Attendance.getDateIDNow()
        }
    }
    
    
    init() {
        //check if user is logged in or not
        self.updateTime()
    }
    
    
    public func performWith(notes: String, forUID uid: String){
        self.checkStatusInDatabase(forUID: uid) { [weak self](status) in
            switch status {
            case .late:
                self?.performCheckIn(forUID: uid, notes: notes)
            case .earlyLeave:
                self?.performCheckOut(forUID: uid, notes: notes)
            default:
                self?.delegate?.attendanceFailed(error: "You cannot perform")
            }
        }
        
    }
    
    public func performCheckIn(forUID uid:String,notes: String?){
        delegate?.attendanceOnProgress()
        
        guard
            let _ = self.dateID,
            let time = self.time
            else{
                self.delegate?.attendanceRemoveProgress()
                self.delegate?.attendanceFailed(error: "Something went wrong please try contact our admin")
                return
        }
        
        let data: [String:Any] = [
            "status":"1",
            "checkInTime": time as Any,
            "checkInNotes": (notes ?? "") as Any
        ]
            
        getDateAttendanceUserPath(withUID: uid).observeSingleEvent(of: .value) { (snapshot) in
            //check if user already check in or not
            if !snapshot.hasChild("checkInTime") && !snapshot.hasChild("checkOutTime"){
                        
                //Set value to user node to improve performance on reading the history of attendance
                self.getUserAttendancePath(withUID: uid).setValue(data)
                
                snapshot.ref.setValue(data, withCompletionBlock: {[weak self] (error, currentRef) in
                    self?.delegate?.attendanceRemoveProgress()
                    
                    if error != nil {
                        currentRef.cancelDisconnectOperations()
                        guard let error = error?.localizedDescription else { return }
                        self?.delegate?.attendanceFailed(error: error )
                        return
                    }
                      
                    Analytics.setUserProperty(self?.time, forName: "check_in_time")
                    self?.delegate?.attendanceSuccess()
                            
                })
            }else{
                self.delegate?.attendanceRemoveProgress()
                self.delegate?.attendanceFailed(error: "You cannot check in again for today")
            }
        }
    }
    
    func performCheckOut(forUID uid:String,notes: String?){
        delegate?.attendanceOnProgress()
        
        guard
            let _ = self.dateID,
            let time = self.time
        else{
            self.delegate?.attendanceRemoveProgress()
            self.delegate?.attendanceFailed(error: "Something went wrong please try contact our admin")
            return
        }
        
        let data: [String:Any] = [
            "status":"2",
            "checkOutTime":time as Any,
            "checkOutNotes": (notes ?? "") as Any
        ]
        
        getDateAttendanceUserPath(withUID: uid).observeSingleEvent(of: .value) { (snapshot) in
            
            if !snapshot.hasChild("checkOutTime") {
                //Set value to user node to improve performance on reading the history of attendance
                self.getUserAttendancePath(withUID: uid).updateChildValues(data)
               
                snapshot.ref.updateChildValues(data, withCompletionBlock: { [weak self] (error, currentRef) in
                    self?.delegate?.attendanceRemoveProgress()
                    
                    if error != nil{
                        currentRef.cancelDisconnectOperations()
                        guard let error = error?.localizedDescription else {return}
                        self?.delegate?.attendanceFailed(error: error)
                        return
                    }
                    
                    
                    Analytics.setUserProperty(self?.time, forName: "check_out_time")
                    self?.delegate?.attendanceSuccess()
                    
                })
                
            }else{
                self.delegate?.attendanceRemoveProgress()
                self.delegate?.attendanceFailed(error: "You cannot check out again for today")
            }
            
        }
        
        
    }
    
    static func observeStatus(forUID uid: String?,onResponse: @escaping (ClockStatus)->()){
        
        guard let userID:String = uid else {
            onResponse(._error)
            return
        }
        
        let dateID:String = Attendance.getDateIDNow()
        
        let dateUserReference = Database.database().reference().child("\(Identifier.attendanceDatabasePath)\(dateID)/\(userID)")
        Database.database().reference().removeAllObservers()
        
        dateUserReference.observe(.value, with: { (snapshot) in
            
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
            onResponse(._error)
        }
        
    }
    
    static func getDateIDNow()->String{
        
        let dateComponent = Calendar.current.dateComponents(in: TimeZone.current, from: Date())
        let formatter = DateFormatter()
        let calendar = Calendar(identifier: .gregorian)
        
        guard let date = calendar.date(from: dateComponent) else { return "" }
        formatter.dateFormat = "yyyyMMdd"
        
        return formatter.string(from: date)
    }
    
    
    public func checkStatusInDatabase(forUID uid:String,onResponse: @escaping (AttendanceType)->()){
        guard
            let _ = self.dateID
        else{
            return
        }
        
        let dateComponent = Calendar.current.dateComponents(in: TimeZone.current, from: Date())
        let minute = (String(dateComponent.minute!).count < 2) ? "0\(dateComponent.minute!)" : "\(dateComponent.minute!)"
        let hour = (String(dateComponent.hour!).count < 2) ? "0\(dateComponent.hour!)" : "\(dateComponent.hour!)"
        guard let currentTime = Int("\(hour)\(minute)") else { return }
        
        getUserAttendancePath(withUID: uid).observeSingleEvent(of: .value) { (snapshot) in
            
            //Check In
            if !snapshot.hasChild("checkInTime") &&  !snapshot.hasChild("checkOutTime"){
                
                if currentTime < Identifier.checkInStartTime{
                    onResponse(.notEligibleTime)
                }else
                if currentTime > Identifier.checkInStartTime && currentTime < Identifier.checkInLimitTime{
                    onResponse(.checkIn)
                }else
                if currentTime > Identifier.checkInLimitTime{
                    onResponse(.late)
                }
                
            }else
            if snapshot.hasChild("checkInTime") && !snapshot.hasChild("checkOutTime"){
                if currentTime < Identifier.checkOutTime{
                    onResponse(.earlyLeave)
                }else{
                    onResponse(.checkOut)
                }
            }else
            if snapshot.hasChild("checkInTime") && snapshot.hasChild("checkOutTime"){
                onResponse(.notEligibleTime)
            }else{
                onResponse(.error)
            }
        }
    }
    
    private func updateTime(){
        dateComponent = Calendar.current.dateComponents(in: TimeZone.current, from: Date())
    }
    
    private func getUserAttendancePath(withUID uid: String)-> DatabaseReference{
        guard let dateID = dateID else { return DatabaseReference() }
        return self.ref.child("\(Identifier.userDatabasePath)\(uid)/attendances/\(dateID)")
    }
    
    private func getDateAttendanceUserPath(withUID uid: String)-> DatabaseReference{
        guard let dateID = dateID else { return DatabaseReference() }
        return self.ref.child("\(Identifier.attendanceDatabasePath)\(dateID)/\(uid)")
    }
    
    
    
    static func getDateIDComponent() -> String? {
        let dateComponent = Calendar.current.dateComponents(in: TimeZone.current, from: Date())
        return "\(dateComponent.year!)\(dateComponent.month!)\(dateComponent.day!)"
    }
    
}
