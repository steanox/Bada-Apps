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

protocol AttendanceDelegate {
    func attendanceSuccess()
    func attendanceOnProgress()
    func attendanceFailed()
    func attendanceRemoveProgress()
}

class Attendance{
    
    var dateID: String?
    var status: Status?
    var userID = Auth.auth().currentUser?.uid
    var notes: String?
    var time: String?
    var delegate: AttendanceDelegate?
    var ref: DatabaseReference = Database.database().reference()
    
    
    init(_ status: Status,for user: User, notes:String?) {
        delegate?.attendanceOnProgress()
        
        //check if user is logged in or not
        guard (Auth.auth().currentUser?.isAnonymous) != nil else { return }
        
        let dateComponent = Calendar.current.dateComponents(in: TimeZone.current, from: Date())
        self.dateID = "\(dateComponent.year!)-\(dateComponent.month!)-\(dateComponent.day!)"
        self.status = status
        self.notes = notes
        self.time = "\(dateComponent.hour!):\(dateComponent.minute!):\(dateComponent.second!)"
        
        switch self.status! {
        case .checkIn:
            performCheckIn()
        case .checkOut:
            performCheckOut()
        }
    
    }
    
    private func performCheckIn(){
        
        if let _ = dateID,let _ = time{
         
            var data: [String:Any] = ["status":"1","checkInTime":self.time as Any]
            
            //check if notes avaiable
            
            if let notes = notes{
                data["checkInNotes"] = notes
            }
            ref.onDisconnectRemoveValue()
            self.ref.child("attendance/\(self.dateID!)/\(self.userID!)").observeSingleEvent(of: .value) { (snapshot) in
                
                //check if user already check in or not
                if !snapshot.hasChild("checkInTime") && !snapshot.hasChild("checkOutTime"){
                    snapshot.ref.setValue(data, withCompletionBlock: {[weak self] (error, currentRef) in
                        self?.delegate?.attendanceRemoveProgress()
                        if error != nil {
                            currentRef.cancelDisconnectOperations()
                            self?.delegate?.attendanceFailed()
                            return
                        }
                        self?.delegate?.attendanceSuccess()
                        
                    })
                }
                
            }
        }
        
    }
    
    private func performCheckOut(){
        if let _ = dateID,let _ = time{
            var data: [String:Any] = ["status":"2","checkInTime":self.time as Any]
            
            if let notes = notes{
                data["checkOutNotes"] = notes
            }
            
            ref.onDisconnectRemoveValue()
            self.ref.child("attendance/\(self.dateID!)/\(self.userID!)").observeSingleEvent(of: .value) { (snapshot) in
                
                if !snapshot.hasChild("checkOutTime"){
                    snapshot.ref.updateChildValues(data, withCompletionBlock: {[weak self] (error, currentRef) in
                        self?.delegate?.attendanceRemoveProgress()
                        if error != nil{
                            currentRef.cancelDisconnectOperations()
                            self?.delegate?.attendanceFailed()
                            return
                        }
                        self?.delegate?.attendanceSuccess()
                    })
                }
                
            }
        }
        
    }
    
    
    
}
