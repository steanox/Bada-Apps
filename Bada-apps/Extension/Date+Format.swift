//
//  Date.swift
//  Bada-apps
//
//  Created by Handy Handy on 08/03/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import Foundation

extension Date {
    
    func current() -> String {
        let calendar = Calendar.current
        let dateComponents = calendar.component(.day, from: self)
        let numberFormatter = NumberFormatter()
        
        numberFormatter.numberStyle = .ordinal
        let day = numberFormatter.string(from: dateComponents as NSNumber)

        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = Identifier.formatDay
        let dayName = dayFormatter.string(from: self)
        
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = Identifier.formatMonthYear
        let monthYearName = yearFormatter.string(from: self)
        
        guard let days = day else { return "" }
        return "\(dayName) \(days) \(monthYearName)"
    }
    
    typealias ClockInterval = ((Int?) -> Void)
    
    func clockTime(_ completion: @escaping ClockInterval) {
        let bdDate = BDDate()
        bdDate.getCurrent { (currentDate) in

            let dateFormatter = DateFormatter()
            //"2018-03-13 20:40:48"
            dateFormatter.dateFormat = "\"yyyy-MM-dd HH:mm:ss\""
            guard let currDate = dateFormatter.date(from: currentDate) else {return}

            let indexStartOfDate = currentDate.index(currentDate.startIndex, offsetBy: 12)
            let indexEndOfDate = currentDate.index(currentDate.endIndex, offsetBy: -7)
            let currentHour: Int = Int(currentDate[indexStartOfDate..<indexEndOfDate])!

            if currentHour < 9  {
                let clockIn = "09:00:00"
                let clockInTime = clockIn.toTime()
                let diff = Calendar.current.dateComponents([.second], from: currDate, to: clockInTime).second
                completion(diff)
            }else if currentHour < 18 {
                let clockOut = "18:00:00"
                let clockOutTime = clockOut.toTime()
                let diff = Calendar.current.dateComponents([.second], from: currDate, to: clockOutTime).second
                completion(diff)
            }else {
//              9jam = 32400
                let clock = "23:59:59"
                let clockTime = clock.toTime()
                let diff = Calendar.current.dateComponents([.second], from: currDate, to: clockTime).second! + 32400
                completion(diff)
            }
        }
    }

    
}


extension String {
    
    func getDate() -> String {
        let dateFormatter = DateFormatter()
        //2018-03-13 20:40:48
        dateFormatter.dateFormat = "\"yyyy-MM-dd HH:mm:ss\""
        
        guard let date = dateFormatter.date(from: self) else {return ""}
        
        let calendar = Calendar.current
        let dateComponents = calendar.component(.day, from: date)
        let numberFormatter = NumberFormatter()
        
        numberFormatter.numberStyle = .ordinal
        let day = numberFormatter.string(from: dateComponents as NSNumber)
        
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = Identifier.formatDay
        let dayName = dayFormatter.string(from: date)
        
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = Identifier.formatMonthYear
        let monthYearName = yearFormatter.string(from: date)
        
        guard let days = day else { return "" }
        return "\(dayName) \(days) \(monthYearName)"
    }
    
    func toTime() -> Date {
        let dateFormatter = DateFormatter()
        //20:40:48
        dateFormatter.dateFormat = "HH:mm:ss"
        
        guard let date = dateFormatter.date(from: self) else {return Date()}
        
        return date
    }
    
}


