//
//  Beacon.swift
//  Bada-apps
//
//  Created by Handy Handy on 07/03/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit
import CoreLocation

struct Beacon {
    
    var inCoverageArea: Bool?
    
    mutating func beaconDetected() {
        self.inCoverageArea = true
    }
    
    mutating func beaconNotDetected() {
        self.inCoverageArea = false
    }
    
}

