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
    
    var attendancesData: [String:[[String:String]]] = [:]
    var orderedMonth:[String] = []
    
    let months:[String] = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    var availableMonth: [String] = []
    
    let showMoreButtonTotal = 1
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let history: UIView = UINib.loadView(with: Identifier.history, self)
        
        historyTable.dataSource = self
        
        
        self.historyTable.register(UINib(nibName: "HistoryCell", bundle: nil), forCellReuseIdentifier: "historyCell")
        self.historyTable.register(UINib(nibName: "HistoryCellShowMore", bundle: nil), forCellReuseIdentifier: "historyCellShowMore")
        self.historyTable.tableFooterView = UIView() 
        
        self.addSubview(history)

    }
    
}

extension HistoryView: UITableViewDataSource{
    
    func refreshAvailableMonth(){
        for att in attendancesData{
            let monthKey: String = att.key
            availableMonth.append(monthKey)
        }
        availableMonth.reverse()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return orderedMonth.count + showMoreButtonTotal
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < attendancesData.count{
            return months[Int(orderedMonth[section])! - 1]
        }
        return ""
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < attendancesData.count{
            return (attendancesData["\(orderedMonth[section])"]?.count)!
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section < attendancesData.count{
            let cell = historyTable.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryCell
            
            
            cell.attendanceData = self.attendancesData["\(orderedMonth[indexPath.section])"]![indexPath.row]
            
            return cell
        }else{
            let cell = historyTable.dequeueReusableCell(withIdentifier: "historyCellShowMore", for: indexPath) as! HistoryCellShowMore
            
            return cell
        }
        
        
        
    }
    
    @IBAction func showMoreHistory(){
        let parentVC = self.parentViewController as! HistoryViewController
        parentVC.showMoreButtonTapped()
    }
    
    
}

