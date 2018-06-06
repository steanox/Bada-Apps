//
//  History.swift
//  Bada-apps
//
//  Created by Handy Handy on 07/03/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit


class HistoryViewController: BaseController {
    
    var attendanceViewController: AttendanceViewController?
    
    @IBOutlet weak var historyView: HistoryView!
    
    var attendanceData: [[String:String]] = []
    
    let showMoreButtonTotal = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        User.getAttendanceHistory(limit: 10) { (attendance) in
            self.historyView.attendanceData.append(attendance)
            self.historyView.attendanceData.sort(by: { (first, second) -> Bool in
                return Int(first["date"]!)! > Int(second["date"]!)!
            })
            DispatchQueue.main.async {
                self.historyView.historyTable.reloadData()
            }
            
        }
    }
    
    @IBAction func buttonTapped() {
        attendanceViewController?.disableInteractivePlayerTransitioning = true
        self.dismiss(animated: true) { [unowned self] in
            self.attendanceViewController?.disableInteractivePlayerTransitioning = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        

    }
}

//extension HistoryViewController: UITableViewDataSource{
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return attendanceData.count + showMoreButtonTotal
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        if indexPath.row < attendanceData.count{
//            let cell = historyListTable.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
//            guard var dateID = attendanceData[indexPath.row]["date"] else { return UITableViewCell()}
//            let date = dateID.dateIDtoDateString()
//
//            cell.textLabel?.text = dateID.dateIDtoDateString()
//
//            let checkInTime = attendanceData[indexPath.row]["checkInTime"] ?? "-"
//            let checkOutTime =  attendanceData[indexPath.row]["checkOutTime"] ?? "-"
//            cell.detailTextLabel?.text = "Checkin time: \(checkInTime) - Checkout time: \(checkOutTime)"
//
//            return cell
//        }else{
//            let cell = historyListTable.dequeueReusableCell(withIdentifier: "HistoryCellShowMore", for: indexPath)
//
//            return cell
//        }
//
//
//
//    }
//
//    @IBAction func showMoreHistory(){
//        print("asd")
//    }
//}
