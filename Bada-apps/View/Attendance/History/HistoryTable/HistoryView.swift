//
//  HistoryView.swift
//  Bada-apps
//
//  Created by octavianus on 06/06/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit


class HistoryView:UIView{
    
    @IBOutlet weak var historyTable:UITableView!
    
    var attendanceData: [[String:String]] = []
    
    let showMoreButtonTotal = 1
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let history: UIView = UINib.loadView(with: Identifier.history, self)
        
        historyTable.dataSource = self
        
        
        self.historyTable.register(UINib(nibName: "HistoryCell", bundle: nil), forCellReuseIdentifier: "historyCell")
        self.historyTable.register(UINib(nibName: "HistoryCellShowMore", bundle: nil), forCellReuseIdentifier: "historyCellShowMore")
        
        self.addSubview(history)

    }
    
}

extension HistoryView: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.attendanceData.count + showMoreButtonTotal
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < attendanceData.count{
            let cell = historyTable.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryCell
            guard var dateID = attendanceData[indexPath.row]["date"] else { return UITableViewCell()}
            let date = dateID.dateIDtoDateString()
            
            cell.mainTitle.text = dateID.dateIDtoDateString()

//
//            let checkInTime = attendanceData[indexPath.row]["checkInTime"] ?? "-"
//            let checkOutTime =  attendanceData[indexPath.row]["checkOutTime"] ?? "-"
//            cell.detailTextLabel?.text = "Checkin time: \(checkInTime) - Checkout time: \(checkOutTime)"
            
            return cell
        }else{
            let cell = historyTable.dequeueReusableCell(withIdentifier: "historyCellShowMore", for: indexPath)
            
            return cell
        }
        
        
        
    }
    
    @IBAction func showMoreHistory(){
        print("asd")
    }
    
    
}

