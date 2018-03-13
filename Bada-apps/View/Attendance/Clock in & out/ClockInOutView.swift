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
    case _in
    case _out
    case _done
}



class ClockInOutView: UIView {

    @IBOutlet weak var clockInOutButton: UIButton!
    @IBOutlet weak var clockInOutTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    

    
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

        
        
    }
    
    @IBAction func clockInOutDidTap(_ sender: UIButton) {
        let vc = parentViewController as! AttendanceViewController
        vc.handleAttendance()
    }
    

    
    func tryingIdentifying() {
        let faceId = FaceID()
        faceId.identifiyingFaceID { (response) in
            switch response {
            case .isSuccess:
                DispatchQueue.main.async {
               
                }
                break
            case .notSupported:
                break
            case .unknownError:
                break
            }
        }
    }
    
}
