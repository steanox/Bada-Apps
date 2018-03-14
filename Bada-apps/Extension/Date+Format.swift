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
    
}


