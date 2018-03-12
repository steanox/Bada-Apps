//
//  AttendanceViewController.swift
//  Bada-apps
//
//  Created by Handy Handy on 07/03/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit

class AttendanceViewController: BaseController {
    
    
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var coverageAreaView: CoverageAreaView!
    @IBOutlet weak var clockInOutView: ClockInOutView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\(coverageAreaView.beacon.inCoverageArea)")
    }
    
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        styleUI()
    }
    
    override func styleUI() {
        super.styleUI()
        
    
        currentDateLabel.text = Date().current()
        coverageAreaView.applyShadow(0.0)
        clockInOutView.applyShadow(15.0)
        
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

