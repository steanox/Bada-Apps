//
//  FirebaseAttendanceSystem.swift
//  Bada-apps
//
//  Created by octavianus on 06/07/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol FirebaseAttendanceSystem{
    var attendancePath: DatabaseReference! { get set}
    var userAttendancePath: DatabaseReference! { get set}
}
