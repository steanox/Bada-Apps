//
//  AttendanceViewController.swift
//  Bada-apps
//
//  Created by Handy Handy on 07/03/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit

class AttendanceViewController: BaseController {
    
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
        
        coverageAreaView.applyShadow(0.0)
        clockInOutView.applyShadow(15.0)
        
    }
    
}

