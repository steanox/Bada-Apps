//
//  Message.swift
//  Bada-apps
//
//  Created by Handy Handy on 07/03/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import Foundation

struct Message {
    
    public static let notInArea = "You’re not in the area"
    public static let finding = "Still Trying…"
    public static let inArea = "You’re in the area"
    public static let attendance = "Attendance"
    public static let news = "News"
    public static let profile = "Profile"
    public static let forgotPassword = "Forgot Password"
    public static let appleID = "Apple ID"
    public static let resetPasswordSuccess = "Succes!\nCheck your email to create new password."
    public static let faceIdUnknowError = "Make sure your face id is active."
    public static let signOut = "Sign Out"
    public static let close = "Close"
    public static let worldClassDeveloper = "World Class Developer"
    public static let bluetoothOff = "Please turn on your bluetooth"
    public static let changePassword = "Change Password"
    
    
    public static let update: (title: String,description: String, button: String) = (
        "Sorry",
        "You need the latest version of this application",
        "Update"
    )
    
}

