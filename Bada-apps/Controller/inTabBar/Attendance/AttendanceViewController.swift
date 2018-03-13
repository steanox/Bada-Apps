//
//  AttendanceViewController.swift
//  Bada-apps
//
//  Created by Handy Handy on 07/03/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit
import CoreLocation

class AttendanceViewController: BaseController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var coverageAreaView: CoverageAreaView!
    @IBOutlet weak var clockInOutView: ClockInOutView!
    
    var attendance: Attendance?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Attendance.observeForStatus { (status) in
            switch status {
            case ._in:
                 self.clockInOutView.clockStatus = status
                self.clockInOutView.clockInOutButton.setImage(#imageLiteral(resourceName: "clockOutButton"), for: UIControlState.normal)
            case ._out:
                self.clockInOutView.clockStatus = status
                self.clockInOutView.clockInOutButton.setImage(#imageLiteral(resourceName: "clockInButton"), for: UIControlState.normal)
            case ._done:
                print("done")
            }
        }
    }
    
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        styleUI()
    }
    
    override func styleUI() {
        super.styleUI()
        
        nameLabel.text = User.name
        
        currentDateLabel.text = Date().current()
        bdDate?.getCurrent({ (data) in
            DispatchQueue.main.async {
                print(data)
                self.currentDateLabel.text = data.getDate()
            }
            
        })
        coverageAreaView.applyShadow(0.0)
        clockInOutView.applyShadow(15.0)
        
    }
    
    func handleAttendance(with notes: String = ""){
        attendance = Attendance(for: User.getUser(), notes: notes)
        attendance?.delegate = self
        
   
        if let distance = coverageAreaView.distanceToBeacon, let status = attendance?.status{
            switch distance {
            case .near , .immediate:
                
                switch status {
                case .checkIn:
                    attendance?.performCheckIn()
                case .checkOut:
                    attendance?.performCheckOut()
                case .late:
                    getTabBarController()?.view.showNote(title: "Late Notes",source: self)
                case .earlyLeave:
                    getTabBarController()?.view.showNote(title: "Early Leave Notes",source: self)
                case .notEligibleTime:
                    view.showNotification(title: "Failed", description: "You only can attend at 6.00 AM", buttonText: "close", onSuccess: {
                        self.tabBarController?.tabBar.isHidden = false
                    })
                case .error:
                    view.showNotification(title: "Failed", description: "Something went wrong", buttonText: "close", onSuccess: {
                        self.tabBarController?.tabBar.isHidden = false
                    })
                }

            case .far:
                view.showNotification(title: "Failed", description: "Please move a little closer", buttonText: "close", onSuccess: {
                    self.tabBarController?.tabBar.isHidden = false
                })
            case .unknown:
                view.showNotification(title: "Failed", description: "You cannot attend here", buttonText: "close", onSuccess: {
                    self.tabBarController?.tabBar.isHidden = false
                })
            }
        }
        
    }
    
    
    
    
    
//    override func keyboard(will status: StatusKeyboard, with notification: NSNotification) {
//
//        let origin = self.view.frame.origin
//        var size = CGSize()
//
//        switch status {
//        case .show:
//            if let keyboardSize = (notification.userInfo? [UIKeyboardFrameEndUserInfoKey]
//                as? NSValue)?.cgRectValue {
//
//                size.width = self.view.frame.size.width
//                size.height = UIWindow().frame.height - keyboardSize.height
//                let newRect = CGRect(origin: origin, size: size)
//                UIView.animate(withDuration: 0.3, animations: {
//                    UIAni
//                })
//
//                self.view.frame = newRect
//
//            }
//        case .hide:
//            print("c")
////            if self.view.frame.height < UIWindow().frame.height {
////                size.width = self.view.frame.size.width
////                size.height = UIWindow().frame.height
////                let newRect = CGRect(origin: origin, size: size)
////                self.view.frame = newRect
////            }
//        }
//    }
    
    
    
}

extension AttendanceViewController: AttendanceDelegate{
    func attendanceOnProgress() {
        startActivityIndicator()
    }
    
    func attendanceSuccess() {
        view.showNotification(title: "Success", description: "Thank you have a nice day", buttonText: "Close", onSuccess: {
            self.tabBarController?.tabBar.isHidden = false
        })
    }
    
    func attendanceFailed(error: String) {
        view.showNotification(title: "Failed", description: error, buttonText: "Close", onSuccess: {
            self.tabBarController?.tabBar.isHidden = false
        })
    }
    
    func attendanceRemoveProgress() {
        stopActivityIndicator()
    }
    
}

