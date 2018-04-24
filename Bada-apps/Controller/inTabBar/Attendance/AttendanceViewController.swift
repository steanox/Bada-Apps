//
//  AttendanceViewController.swift
//  Bada-apps
//
//  Created by Handy Handy on 07/03/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications
import UserNotificationsUI

class AttendanceViewController: BaseController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var coverageAreaView: CoverageAreaView!
    @IBOutlet weak var clockInOutView: ClockInOutView!
    
    var content: UNMutableNotificationContent?
    
    var attendance: Attendance?

    // setting up dragable history view controller
    var disableInteractivePlayerTransitioning = false
    @IBOutlet weak var dragableHistoryView: DragableHistoryView!
    var historyViewController: HistoryViewController!
    var presentInteractor: MiniToLargeViewInteractive!
    var dismissInteractor: MiniToLargeViewInteractive!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clockInOutView.isHidden = true
        startActivityIndicator()
        askNotificationAuthorization()
        
//        do {
//            let tripleDesEnc = TripleDesEncryptor()
//            let data = "muhammads0707@gmail.com".data(using:String.Encoding.utf8)!
//            let mailData = try tripleDesEnc.encrypt(data: data) as? NSData
//            print(mailData?.toHexString)
//        } catch let e {
//            print(e.localizedDescription)
//        }
        
        
        
        
        // setting up dragable history view controller
//        dragableHistoryView.translatesAutoresizingMaskIntoConstraints = false
//
//        historyViewController = HistoryViewController()
//        historyViewController.attendanceViewController = self
//        historyViewController.transitioningDelegate = self
//        historyViewController.modalPresentationStyle = .fullScreen
//
//        presentInteractor = MiniToLargeViewInteractive()
//        presentInteractor.attachToViewController(viewController: self, withView: dragableHistoryView, presentViewController: historyViewController)
//        dismissInteractor = MiniToLargeViewInteractive()
//        dismissInteractor.attachToViewController(viewController: historyViewController, withView: historyViewController.view, presentViewController: nil)
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        triggeringNotification()
        styleUI()
        
        Attendance.observeForStatus { (status) in
            switch status {
            case ._notYet:
                self.clockInOutView.isHidden = false
                self.stopActivityIndicator()
                self.clockInOutView.clockStatus = status
                self.clockInOutView.clockInOutButton.setImage(#imageLiteral(resourceName: "clockInButton"), for: UIControlState.normal)
                self.clockInOutView.clockInOutTitleLabel.text = "Clock In"
                self.clockInOutView.clockInOutTitleLabel.textColor = UIColor.init(rgb: Color.clockOutColor)
                
                self.clockInOutView.clockInOutButton.isUserInteractionEnabled = true
                self.clockInOutView.dateLabel.textColor = UIColor.init(rgb: Color.clockOutColor)
            case ._in:
                self.clockInOutView.isHidden = false
                self.stopActivityIndicator()
                self.clockInOutView.clockStatus = status
                self.clockInOutView.clockInOutButton.setImage(#imageLiteral(resourceName: "clockOutButton"), for: UIControlState.normal)
                self.clockInOutView.clockInOutTitleLabel.text = "Last Clock In"
                self.clockInOutView.clockInOutTitleLabel.textColor = UIColor.init(rgb: Color.clockInColor)
           
                self.clockInOutView.clockInOutButton.isUserInteractionEnabled = true
                self.clockInOutView.dateLabel.textColor = UIColor.init(rgb: Color.clockOutColor)
            case ._out:
                self.stopActivityIndicator()
                self.clockInOutView.isHidden = false
                self.clockInOutView.clockStatus = status
                    self.clockInOutView.clockInOutButton.setImage(#imageLiteral(resourceName: "button_Grey"), for: UIControlState.normal)
                    self.clockInOutView.clockInOutButton.isUserInteractionEnabled = false
                self.clockInOutView.clockInOutTitleLabel.textColor = UIColor.init(rgb: Color.clockInColor)
                self.clockInOutView.clockInOutTitleLabel.text = "Last Clock out"
                
                self.clockInOutView.dateLabel.textColor = UIColor.init(rgb: Color.clockOutColor)
            case ._done:
                self.clockInOutView.isHidden = false
                self.stopActivityIndicator()
            }
        }
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func styleUI() {
        super.styleUI()
        
        User.getUser().getName { (name) in
            guard let name = name else {return}
            self.nameLabel.text = name
        }
        
        currentDateLabel.text = Date().current()
        bdDate?.getCurrent({ (data) in
            DispatchQueue.main.async {
                self.currentDateLabel.text = data.getDate()
            }
            
        })
        coverageAreaView.applyShadow(0.0)
        clockInOutView.applyShadow(15.0)
        
        content = UNMutableNotificationContent()
        content?.title = "Remainder"
        content?.sound = UNNotificationSound.default()
        UNUserNotificationCenter.current().delegate = self
        
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
                case .notCheckIn:
                    view.showNotification(title: "Failed", description: "You have to check in First", buttonText: "close", onSuccess: {
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

extension AttendanceViewController: UNUserNotificationCenterDelegate {
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Tapped in notification")
    }
    
    //This is key callback to present notification while the app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("Notification being triggered")
        //You can either present alert ,sound or increase badge while the app is in foreground too with ios 10
        //to distinguish between notifications
        if notification.request.identifier == Identifier.checkInLocalNotification{
            
            completionHandler( [.alert,.sound,.badge])
            
        }
    }
    
    
    func askNotificationAuthorization() {
        //Requesting Authorization for User Interactions
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
            if !granted{
                let alert = UIAlertController(title: "Notification Access", message: "In order to remind you to fill attendance, turn on notification permissions.", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
                alert.addAction(alertAction)
                self.present(alert , animated: true, completion: nil)
            }
        }
    }
    
    func triggeringNotification() {
        print("1")
        self.notification(status: ._out)
        Attendance.observeForStatus { (status) in
            print("1")
            switch status {
            case ._notYet:
                self.notification(status: ._notYet)
            case ._out:
                print("2")
                self.notification(status: ._out)
            case ._in:
                print("3")
                self.notification(status: ._in)
            case ._done:
                print("Done")
            }
        }
    }
    
    func notification(status: ClockStatus) {
        removeAllNotification()
        
        switch status {
        case ._notYet:
            content?.subtitle = "asdasdasdasd"
            content?.body = "ing"
        case ._out:
            content?.subtitle = "test"
            content?.body = "ing"
        case ._in:
            content?.subtitle = "testing"
            content?.body = "dikit"
        case ._done:
            print("done")
        }
        
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 5.0, repeats: false)
        let request = UNNotificationRequest(identifier: Identifier.checkInLocalNotification, content: self.content!, trigger: trigger)
        UNUserNotificationCenter.current().add(request) {(error) in
            if (error != nil){
                print(error?.localizedDescription as Any)
            }
        }
        
    }
    
    func removeAllNotification() {
        let current = UNUserNotificationCenter.current()
        current.removePendingNotificationRequests(withIdentifiers: [Identifier.checkInLocalNotification, Identifier.checkOutlocalNotification])
    }
    
    func setCategories(title: String){
        let snoozeAction = UNNotificationAction(identifier: Identifier.snoozelocalNotification, title: "Snooze 10 minute", options: [])
        let clockInOutAction = UNNotificationAction(identifier: Identifier.snoozelocalNotification, title: title, options: [])
        
        let alarmCategory = UNNotificationCategory(identifier: Identifier.alarmCategoryNotification,actions: [snoozeAction, clockInOutAction], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([alarmCategory])
    }
    
}

extension AttendanceViewController: UIViewControllerTransitioningDelegate {
    
    @IBAction func dragableHistoryDidTap() {
//        disableInteractivePlayerTransitioning = true
//        self.present(historyViewController, animated: true) { [unowned self] in
//            self.disableInteractivePlayerTransitioning = false
//        }
        
        let infoText: [String] = [
            "We really appriciate your curiousity 😇, Too bad this feature hasn't come up.",
            "You'll be surprised when this feature come up, just wait for it 😏",
            "Oopss.... You are on the wrong section, please come back in a few moments probably"
        ]
    
        self.view.showNotification(title: "Sorry..", description: infoText[Int(arc4random_uniform(3))], buttonText: "Close", onSuccess: nil)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = MiniToLargeViewAnimator()
        animator.initialY = dragableHistoryView.frame.size.height
        animator.transitionType = .present
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = MiniToLargeViewAnimator()
        animator.initialY = dragableHistoryView.frame.size.height
        animator.transitionType = .dismiss
        return animator
    }
    
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard !disableInteractivePlayerTransitioning else { return nil }
        return presentInteractor
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard !disableInteractivePlayerTransitioning else { return nil }
        return dismissInteractor
    }
    
}





