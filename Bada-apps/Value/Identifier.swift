//
//  Identifier.swift
//  Bada-apps
//
//  Created by Handy Handy on 07/03/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit

struct Identifier {
    
    public static let beaconUuid = "CB10023F-A318-3394-4199-A8730C7C1AEC"
    public static let beacon = "myBeacon"
    public static let accountCell = "accountCell"
    
    public static let coverageArea = "CoverageAreaView"
    public static let clockInOut = "ClockInOutView"
    public static let dragableHistory = "DragableHistoryView"
    public static let history = "HistoryView"
    public static let authentication = "Authentication"
    
    public static let notification = "Notification"
    public static let birthdayNotification = "BirthdayNotificationView"
    public static let notes = "NotesView"
    public static let noteTextView = "NoteTextView"
    
    public static let formatDay = "EEEE,"
    public static let formatMonthYear = "MMMM yyyy"
    
    public static let firebaseURL = "https://us-central1-bada-51073.cloudfunctions.net/helper/"
    public static let timeUrl = "https://bada.apps.binus.ac.id/t/time"
    
    public static let checkInLocalNotification = "Check In Remainder"
    public static let checkOutlocalNotification = "Check Out Remainder"
    public static let snoozelocalNotification = "snooze"
    public static let alarmCategoryNotification = "alarm.category"
    
    public static let checkInStartTime = 0600
    public static let checkInLimitTime = 0900
    public static let checkOutTime = 1800
    public static let skimmerTag = 451890
    
    public static let differenceViewOfKeyboard: CGFloat = 100.0
    
    public static let profilePictureStoragePath = "profilePicture/"
    public static let userDatabasePath = "users/"
    public static let attendanceDatabasePath = "attendance/"
    
    public static let baseHTMLString = """
    <header>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style>
            div{
                font-family: 'Roboto', sans-serif;
            }

            
        </style>
    </header>
    """
    
}





