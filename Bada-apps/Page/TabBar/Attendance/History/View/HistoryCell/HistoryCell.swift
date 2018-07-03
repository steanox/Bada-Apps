//
//  HistoryCell.swift
//  Bada-apps
//
//  Created by octavianus on 06/06/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit

class HistoryCell:UITableViewCell{
    
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var checkInTimeLabel: UILabel!
    @IBOutlet weak var checkOutTimeLabel: UILabel!
    

    var attendanceData: [String:String]! {
        didSet{
            mainTitleLabel.text = attendanceData["date"]?.dateIDtoDateString()

            let checkInTime = attendanceData["checkInTime"] ?? "-"
            checkInTimeLabel.text = "\(checkInTime)"

            let checkOutTime =  attendanceData["checkOutTime"] ?? "-"
            checkOutTimeLabel.text = "\(checkOutTime)"
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
