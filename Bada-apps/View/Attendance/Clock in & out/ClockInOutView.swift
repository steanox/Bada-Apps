//
//  ClockInOutView.swift
//  Bada-apps
//
//  Created by Handy Handy on 07/03/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit


enum Clock {
    case _in
    case _out
}



class ClockInOutView: UIView {

    @IBOutlet weak var clockInOutButton: UIButton!
    @IBOutlet weak var clockInOutTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    

    
    fileprivate weak var clockInOutArea: UIView!
    
    var clock:Clock! {
        didSet{
            self.updateUI(clock: clock)
        }
        
    }
    
    typealias onResponse = (()->())
    
    var onTap: onResponse?
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let clockInOut: UIView = UINib.loadView(with: Identifier.clockInOut, self)
        
        self.addSubview(clockInOut)
        self.clockInOutArea = clockInOut
        
        dateLabel.textColor = UIColor(rgb: Color.dateClockInOut)
        clock = Clock._out
        
//        updateUI(clock: ._in)
    }
    
    @IBAction func clockInOutDidTap(_ sender: UIButton) {
        let vc = parentViewController as! AttendanceViewController
        vc.handleAttendance()
    }
    
    func updateUI (clock: Clock) {
        switch clock {
        case ._in:
            clockInOutButton.setImage(#imageLiteral(resourceName: "clockOutButton"), for: UIControlState.normal)
            self.clock = ._out
        case ._out:
            clockInOutButton.setImage(#imageLiteral(resourceName: "clockInButton"), for: UIControlState.normal)
            self.clock = ._in
        }
    }
    
    func tryingIdentifying() {
        let faceId = FaceID()
        faceId.identifiyingFaceID { (response) in
            switch response {
            case .isSuccess:
                DispatchQueue.main.async {
                    self.updateUI(clock: self.clock)
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
