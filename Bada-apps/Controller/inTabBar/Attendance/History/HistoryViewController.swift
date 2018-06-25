//
//  History.swift
//  Bada-apps
//
//  Created by Handy Handy on 07/03/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit
import FirebaseDatabase


class HistoryViewController: BaseController {
    
    var attendanceViewController: AttendanceViewController?
    
    @IBOutlet weak var historyView: HistoryView!
    
    var attendancesData: [String:[[String:String]]] = [:]
    
    let showMoreButtonTotal = 1
    
    var maximumLimit: Int = 5
    var currentItem: Int = 0
    var lastDate = Attendance.getDateIDNow()
    var handler: UInt?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    func getUserHistoryLimited(by limit: Int){
        self.handler = User.getAttendanceHistory(by: limit,offset: lastDate) { [weak self] (attendances) in
            

            
            let orderedDateKey: [String] = Array(attendances.keys).sorted(by: { (s1, s2) -> Bool in
                return Int(s1)! > Int(s2)!
            })
            self?.lastDate = String(Int(orderedDateKey.last!)! - 1)
            
            orderedDateKey.map({ (s1) -> String in
                let monthKey = String(s1[s1.index(s1.startIndex, offsetBy: 4)...s1.index(s1.startIndex, offsetBy: 5)])
                
                self?.historyView.orderedMonth.append(monthKey)
                
                if self?.historyView.attendancesData["\(monthKey)"] == nil{
                    self?.historyView.attendancesData.updateValue([], forKey: monthKey)
                }
                guard var attendance = attendances["\(s1)"] as? [String:String] else {return ""}
                attendance.updateValue(s1, forKey: "date")
                self?.historyView.attendancesData["\(monthKey)"]?.append(attendance)
                
                return ""
            })
            
            
            self?.historyView.orderedMonth = (self?.historyView.orderedMonth.unique.reversed())!
            
            DispatchQueue.main.async {
                self?.historyView.historyTable.reloadData()
            }
        }
        
    }
    
    func showMoreButtonTapped() {
        
        getUserHistoryLimited(by: maximumLimit)
    }
    
    @IBAction func closeButton(){
        attendanceViewController?.disableInteractivePlayerTransitioning = true
        self.dismiss(animated: true) { [unowned self] in
            self.attendanceViewController?.disableInteractivePlayerTransitioning = false
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserHistoryLimited(by: maximumLimit)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let h = handler else {return}
        historyView = nil
        attendanceViewController = nil
        Database.database().reference().removeObserver(withHandle: h)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        

    }
}

