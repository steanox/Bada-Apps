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
import FirebaseDatabase
import FirebaseAuth
import Crashlytics


class AttendanceViewController: BaseController, UIApplicationDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var coverageAreaView: CoverageAreaView!
    @IBOutlet weak var clockInOutView: ClockInOutView!
    @IBOutlet weak var profilePicturPlaceholder: UIView!
    @IBOutlet weak var imageLoadingIndicator: UIActivityIndicatorView!
    
    var content: UNMutableNotificationContent?
    
    var attendance: Attendance?
    var uid: String = ""
    
    // setting up dragable history view controller
    var disableInteractivePlayerTransitioning = false
    @IBOutlet weak var dragableHistoryView: DragableHistoryView!
    var historyViewController: HistoryViewController!
    var presentInteractor: MiniToLargeViewInteractive!
    var dismissInteractor: MiniToLargeViewInteractive!
    
    let dispatchGroup: DispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK:- update shimmer
//        clockInOutView.isHidden = true
//        startActivityIndicator()
        
        askNotificationAuthorization()
        NotificationCenter.default.addObserver(self, selector: #selector(observeStatusAndText), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
        
        profilePicture.isUserInteractionEnabled = false
        profilePicture.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapToChangeProfilePicture)))
        
        historyViewController = HistoryViewController()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.checkForBirthday()
        }
        
        if let uid = Auth.auth().currentUser?.uid{
            self.uid = uid
        }else{
            self.view.showNotification(title: "Error", description: "Please try to relogin", buttonText: "Logout") {
                try? Auth.auth().signOut()
                let authSB = UIStoryboard(name: "Authentication", bundle: nil).instantiateInitialViewController() as! LoginViewController
                self.present(authSB, animated: true, completion: nil)
            }
        }
        
        view.shimmer(state: .start, views: profilePicture, nameLabel, currentDateLabel, coverageAreaView.beaconImageView, coverageAreaView.beaconLabel, clockInOutView.clockInOutButton)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //TODO: Notification
        //        triggeringNotification()
        
        statusObserver()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let handler = Database.database().reference().observe(.value){ (snap) in
        }
        Database.database().reference().removeObserver(withHandle: handler)
    }
    
    
    private func checkForBirthday(){
        
        let dateComponent = Calendar.current.dateComponents(in: TimeZone.current, from: Date())
        let formatter = DateFormatter()
        let calendar = Calendar(identifier: .gregorian)

        guard let date = calendar.date(from: dateComponent) else { return }
        formatter.dateFormat = "MM/dd"
        let formattedDateNow = formatter.string(from: date) as Any

        UserDefaults.standard.removeObject(forKey: "birthdayCache")

        //MARK:- THIS FUNCTION FOR TESTING THE BIRTHDAY
        //testBirthday()
        
        if let birthdayCache = UserDefaults.standard.object(forKey: "birthdayCache") as? String{
            
            if formatter.string(from: date) != birthdayCache{
                UserDefaults.standard.set(formattedDateNow, forKey: "birthdayCache")
                triggerBirthdayNotification(for: formattedDateNow)
            }

        }else{
            UserDefaults.standard.set(formattedDateNow, forKey: "birthdayCache")
            triggerBirthdayNotification(for: formattedDateNow)
        }
    }
    //MARK:- Delete this after done testing
    
    let data: [Birthday] = [
        Birthday(profileImageURL: "https://firebasestorage.googleapis.com/v0/b/bada-51073.appspot.com/o/profilePicture%2F1LKK5s067MUy1i15famw7I90QSB3.png?alt=media&token=ffa3fb6d-4f94-4345-b79f-407bd1806295"),
        Birthday(profileImageURL: "https://firebasestorage.googleapis.com/v0/b/bada-51073.appspot.com/o/profilePicture%2F2xHwfNfWUidQY08Org2OScI9ixE3.png?alt=media&token=d34bfe85-adf8-4c4e-b46e-696251d970a9"),
        Birthday(profileImageURL: "https://firebasestorage.googleapis.com/v0/b/bada-51073.appspot.com/o/profilePicture%2F2xHwfNfWUidQY08Org2OScI9ixE3.png?alt=media&token=d34bfe85-adf8-4c4e-b46e-696251d970a9"),
        ]
    private func testBirthday(){
    
        let birthDayView = BirthdayNotificationView(frame: self.view.frame, profilePictureURL: data, onSuccess: nil)
        DispatchQueue.main.async {
            self.view.addSubview(birthDayView)
        }
        
        let birthdayButton = BirthdayMainActionButtonView(frame: CGRect(x: 15, y: 15, width: 75, height: 75), for: .giveWishes, totalNotification: 3)
        birthdayButton.delegate = self
        self.view.addSubview(birthdayButton)
    }
    
    private func triggerBirthdayNotification(for date: Any){
        
        Database.database().reference().child("users").queryOrdered(byChild: "birthDate").queryEqual(toValue: date).observeSingleEvent(of: .value) { (snap) in
            
            if snap.value == nil{
                return
            }

            
            guard let val = snap.value as? [String:Any] else {return}
            
            let keys = Array(val.keys)
            var data: [Birthday] = []
            
            for key in keys{
                guard let user = val[key] as? [String: Any] else {return}
                
                guard let picURL = user["profilePictureURL"] as? String else {return}
                
                data.append(Birthday(profileImageURL: picURL))
            }
            
            
            
            let birthDayView = BirthdayNotificationView(frame: self.view.frame, profilePictureURL: data, onSuccess: nil)
            
            
            DispatchQueue.main.async {
                self.view.addSubview(birthDayView)
            }
        }
    }
    
    private func addBirthdayActionButton(){
        let mainAction = BirthdayMainActionButtonView(frame:  CGRect(x: 50, y: 20, width: 50, height: 50), for: .viewWished, totalNotification: 2)
        self.view.addSubview(mainAction)
    }
    

    
    func statusObserver(){
        dispatchGroup.enter()
        Attendance.observeStatus(forUID: uid){ (status) in
            self.dispatchGroup.leave()
            self.stopActivityIndicator()
            switch status {
            case ._notYet:
                self.clockInOutView.isHidden = false
                self.clockInOutView.clockStatus = status
                self.clockInOutView.clockInOutButton.setImage( #imageLiteral(resourceName: "clockInButton"), for: UIControlState.normal)
                self.clockInOutView.clockInOutTitleLabel.text = "Clock In"
                self.clockInOutView.clockInOutTitleLabel.textColor = UIColor.init(rgb: Color.clockOutColor)
                
                self.clockInOutView.clockInOutButton.isUserInteractionEnabled = true
                self.clockInOutView.dateLabel.textColor = UIColor.init(rgb: Color.clockOutColor)
            case ._in:
                self.clockInOutView.isHidden = false
                self.clockInOutView.clockStatus = status
                self.clockInOutView.clockInOutButton.setImage( #imageLiteral(resourceName: "clockOutButton"), for: UIControlState.normal)
                self.clockInOutView.clockInOutTitleLabel.text = "Last Clock In"
                self.clockInOutView.clockInOutTitleLabel.textColor = UIColor.init(rgb: Color.clockInColor)
                
                self.clockInOutView.clockInOutButton.isUserInteractionEnabled = true
                self.clockInOutView.dateLabel.textColor = UIColor.init(rgb: Color.clockOutColor)
            case ._out:
                self.clockInOutView.isHidden = false
                self.clockInOutView.clockStatus = status
                self.clockInOutView.clockInOutButton.setImage( #imageLiteral(resourceName: "button_Grey"), for: UIControlState.normal)
                self.clockInOutView.clockInOutButton.isUserInteractionEnabled = false
                self.clockInOutView.clockInOutTitleLabel.textColor = UIColor.init(rgb: Color.clockInColor)
                self.clockInOutView.clockInOutTitleLabel.text = "Last Clock out"
                
                self.clockInOutView.dateLabel.textColor = UIColor.init(rgb: Color.clockOutColor)
            case ._done:
                self.clockInOutView.isHidden = false
            case ._error:
                self.view.showNotification(title: "Error", description: "Please check your internet connection and try again", buttonText: "Close", onSuccess: nil)
                self.clockInOutView.isHidden = false
                self.clockInOutView.clockStatus = status
                self.clockInOutView.clockInOutButton.setImage( #imageLiteral(resourceName: "button_Grey"), for: UIControlState.normal)
                self.clockInOutView.clockInOutButton.isUserInteractionEnabled = false
                self.clockInOutView.clockInOutTitleLabel.textColor = UIColor.init(rgb: Color.clockInColor)
                self.clockInOutView.clockInOutTitleLabel.text = "Connection Error"
            }
        }
    }
    
    @objc func observeStatusAndText(){
        styleUI()
        statusObserver()
        
    }
    
    override func styleUI() {
        super.styleUI()
        
        dispatchGroup.enter()
        User.getUser().getName { (name) in
            self.dispatchGroup.leave()
            guard let name = name else {return}
            self.nameLabel.text = name
        }
        
        currentDateLabel.text = Date().current()
        
        dispatchGroup.enter()
        bdDate?.getCurrent({ (data) in
            self.dispatchGroup.leave()
            self.currentDateLabel.text = data.getDate()
            DispatchQueue.main.async {
                self.currentDateLabel.text = data.getDate()
            }
            
        })
        coverageAreaView.applyShadow(0.0)
        clockInOutView.applyShadow(15.0)
        
        content = UNMutableNotificationContent()
        content?.title = "Reminder"
        content?.sound = UNNotificationSound.default()
        UNUserNotificationCenter.current().delegate = self
        
        self.profilePicturPlaceholder.layer.cornerRadius = self.profilePicturPlaceholder.frame.width / 2
        self.profilePicturPlaceholder.clipsToBounds = true


        self.profilePicture.layer.cornerRadius = self.profilePicture.frame.width / 2
        self.profilePicture.clipsToBounds = true
        
        
        dispatchGroup.enter()
        setProfilePicture()
        
        dispatchGroup.notify(queue: .main) {
            self.view.shimmer(state: .stop, views: self.profilePicture, self.nameLabel, self.currentDateLabel, self.coverageAreaView.beaconImageView, self.coverageAreaView.beaconLabel, self.clockInOutView.clockInOutButton)
        }
    }
    
    private func setProfilePicture(){
        User.getProfilePictureURL {[weak self] (profilePictureURL) in
            
            if profilePictureURL == ""{
                self?.profilePicture.image = #imageLiteral(resourceName: "ProfilePictDummy")
            }else{
                self?.profilePicture.loadImageUsingCacheWith(urlString: profilePictureURL, done: {
                    self?.dispatchGroup.leave()
                    self?.profilePicture.isUserInteractionEnabled = true
                })
            }
            
            
        }
    }
    
    @objc private func tapToChangeProfilePicture(){
        // Object reponsible to handle accessing the photo Library
        
        let imagePicker = UIImagePickerController()
        //connecting with the delegate
        imagePicker.delegate = self
        
        
        //show an alert
        let alert = UIAlertController(title: "Change Profile Picture", message: "Please choose your picture source", preferredStyle: .actionSheet)
        
        //adding button
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .camera
                imagePicker.modalPresentationStyle = .fullScreen
                self.present(imagePicker, animated: true, completion: nil)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        //function to present ViewControllers
        present(alert, animated: true)
    }
    
    func handleAttendance(with notes: String = ""){
        attendance = Attendance()
        attendance?.delegate = self
        
        if let distance = coverageAreaView.distanceToBeacon{
            
            attendance?.checkStatusInDatabase(forUID: self.uid,onResponse: { (status) in
                
                switch distance {
                case .near , .immediate:
                    
                    switch status {
                    case .checkIn:
                        self.attendance?.performCheckIn(forUID: self.uid, notes: "")
                    case .checkOut:
                        self.attendance?.performCheckOut(forUID: self.uid, notes: "")
                    case .late:
                        self.getTabBarController()?.view.showNote(title: "Late Notes",source: self)
                    case .earlyLeave:
                        self.getTabBarController()?.view.showNote(title: "Early Leave Notes",source: self)
                    case .notEligibleTime:
                        self.view.showNotification(title: "Failed", description: "You only can attend at 6.00 AM", buttonText: "close", onSuccess: {
                            self.tabBarController?.tabBar.isHidden = false
                        })
                    case .error:
                        self.view.showNotification(title: "Failed", description: "Something went wrong", buttonText: "close", onSuccess: {
                            self.tabBarController?.tabBar.isHidden = false
                        })
                    case .notCheckIn:
                        self.view.showNotification(title: "Failed", description: "You have to check in First", buttonText: "close", onSuccess: {
                            self.tabBarController?.tabBar.isHidden = false
                        })
                    }
                    
                case .far:
                    self.view.showNotification(title: "Failed", description: "Please move a little closer", buttonText: "close", onSuccess: {
                        self.tabBarController?.tabBar.isHidden = false
                    })
                case .unknown:
                    self.view.showNotification(title: "Failed", description: "You cannot attend here", buttonText: "close", onSuccess: {
                        self.tabBarController?.tabBar.isHidden = false
                    })
                }
                
            })
        }
    }
    
    func showNotification(title: String, message: String, buttonText: String) {
        self.view.showNotification(title: title, description: message, buttonText: buttonText) {
            self.tabBarController?.tabBar.isHidden = false
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
        
        self.notification(status: ._out)
        Attendance.observeStatus(forUID: uid){ (status) in
            
            switch status {
            case ._notYet:
                self.notification(status: ._notYet)
            case ._out:
                
                self.notification(status: ._out)
            case ._in:
                self.notification(status: ._in)
            case ._done:
                self.notification(status: ._done)
            case ._error:
                self.notification(status: ._error)
            }
        }
    }
    
    func notification(status: ClockStatus) {
        removeAllNotification()
        
//        switch status {
//        case ._notYet:
//            content?.subtitle = "asdasdasdasd"
//            content?.body = "ing"
//        case ._out:
//            content?.subtitle = "test"
//            content?.body = "ing"
//        case ._in:
//            content?.subtitle = "testing"
//            content?.body = "dikit"
//        case ._done:
//            print("done")
//        }
        
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

//MARK:- Transition setup for the history
extension AttendanceViewController: UIViewControllerTransitioningDelegate {
    
    @IBAction func dragableHistoryDidTap() {
        disableInteractivePlayerTransitioning = true
        
        let sb = UIStoryboard(name: "History", bundle: nil)
        
        self.present(sb.instantiateInitialViewController()!, animated: true) { [unowned self] in
                    self.disableInteractivePlayerTransitioning = false
        }
        
//        let infoText: [String] = [
//            "We really appriciate your curiousity 😇, Too bad this feature hasn't come up.",
//            "You'll be surprised when this feature come up, just wait for it 😏",
//            "Oopss.... You are on the wrong section, please come back in a few moments probably"
//        ]
//        
//        self.view.showNotification(title: "Sorry..", description: infoText[Int(arc4random_uniform(3))], buttonText: "Close", onSuccess: nil)
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


//MARK:- Image Picker Delegate
extension AttendanceViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage:UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        picker.dismiss(animated: true) {
            DispatchQueue.main.async {
                self.view.shimmer(state: .start, views: self.profilePicture)
                self.profilePicture.isUserInteractionEnabled = false
            }
            User.upload(profilePicture: chosenImage){
                DispatchQueue.main.async {
                    User.getProfilePictureURL {[weak self] (profilePictureURL) in
                        
                        if profilePictureURL == ""{
                            self?.profilePicture.image = #imageLiteral(resourceName: "ProfilePictDummy")
                        }else{
                            self?.profilePicture.loadImageUsingCacheWith(urlString: profilePictureURL, done: {
                                guard let profilePict = self?.profilePicture else {return}
                                self?.view.shimmer(state: .stop, views: profilePict)
                                profilePict.isUserInteractionEnabled = true
                            })
                        }
                        
                        
                    }
                }
            }
        }
    }
}

//MARK:- Birthday Main action button delegate

extension AttendanceViewController: BirthdayMainActionButtonViewDelegate{
    
    func giveWishes() {
//        let giveWishes = BirthdayPersonCollectionView(frame: self.view.frame)
//        giveWishes.birthdayData = self.data
//        self.view.addSubview(giveWishes)
        let sb = UIStoryboard(name: "Birthday", bundle: nil).instantiateInitialViewController() as! UINavigationController
        if let bd = sb.topViewController as? BirthdayViewController{
            bd.data = data
            show(sb, sender: nil)
        }
        
    }
    
    func viewWishes() {

    }
}





