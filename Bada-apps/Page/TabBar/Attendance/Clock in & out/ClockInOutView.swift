//
//  ClockInOutView.swift
//  Bada-apps
//
//  Created by Handy Handy on 07/03/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


enum ClockStatus {
    case _notYet
    case _in
    case _out
    case _done
    case _error
}



class ClockInOutView: UIView {
    
    @IBOutlet weak var clockInOutButton: UIButton!
    @IBOutlet weak var clockInOutTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var blackView: UIView = {
        var bv = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        bv.backgroundColor = UIColor.black
        
        return bv
    }()
    
    
    
    fileprivate weak var clockInOutArea: UIView!
    
    var clockStatus: ClockStatus?
    typealias onResponse = (()->())
    
    var onTap: onResponse?
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let clockInOut: UIView = UINib.loadView(with: Identifier.clockInOut, self)
        
        self.addSubview(clockInOut)
        self.clockInOutArea = clockInOut
        
        dateLabel.textColor = UIColor(rgb: Color.dateClockInOut)
        
        clockInOutButton.layer.cornerRadius = clockInOutButton.frame.width / 2.0
        clockInOutButton.layer.masksToBounds = true
        
    }
    
    @IBAction func clockInOutDidTap(_ sender: UIButton) {
        tryingIdentifying()
    }
    
    func tryingIdentifying() {
        let faceId = FaceID()
        let vc = self.parentViewController as! AttendanceViewController
        faceId.identifiyingFaceID { (response) in
            switch response {
            case .isSuccess:
                vc.handleAttendance()
                break
            case .notSupported:
                break
            case .unknownError:
                vc.showNotification(title: "Face ID", message: Message.faceIdUnknowError, buttonText: "Close")
                break
            }
        }
    }
    
}
