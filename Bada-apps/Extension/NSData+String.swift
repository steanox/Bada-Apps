//
//  NSData+String.swift
//  Central Mega Kencana
//
//  Created by Handy Handy on 08/03/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import Foundation

extension NSData {
    
    var toHexString: String? {
        let buf = bytes.assumingMemoryBound(to: UInt8.self)
        let charA = UInt8(UnicodeScalar("a").value)
        let char0 = UInt8(UnicodeScalar("0").value)
        
        func itoh(_ value: UInt8) -> UInt8 {
            return (value > 9) ? (charA + value - 10) : (char0 + value)
        }
        
        let hexLen = length * 2
        let ptr = UnsafeMutablePointer<UInt8>.allocate(capacity: hexLen)
        
        for i in 0 ..< length {
            ptr[i*2] = itoh((buf[i] >> 4) & 0xF)
            ptr[i*2+1] = itoh(buf[i] & 0xF)
        }
        
        return String(bytesNoCopy: ptr, length: hexLen, encoding: .utf8, freeWhenDone: true)
    }
}

extension String {
    
    func toData() -> Data? {
        var data = Data(capacity: self.count / 2)
        
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSMakeRange(0, utf16.count)) { match, flags, stop in
            let byteString = (self as NSString).substring(with: match!.range)
            var num = UInt8(byteString, radix: 16)!
            data.append(&num, count: 1)
        }
        
        guard data.count > 0 else { return nil }
        
        return data
    }
    
    func toString() -> String {
        
        let regex = try! NSRegularExpression(pattern: "(0x)?([0-9A-Fa-f]{2})", options: .caseInsensitive)
        let textNS = self as NSString
        let matchesArray = regex.matches(in: textNS as String, options: [], range: NSMakeRange(0, textNS.length))
        let characters = matchesArray.map {
            Character(UnicodeScalar(UInt32(textNS.substring(with: $0.range(at: 2)), radix: 16)!)!)
        }
        
        return String(characters)
    }
    
    //The format for this function should be yyyyMMdd
    func dateIDtoDateString()->String{
        var dateID = self
 
        let year = (dateID[..<dateID.index(dateID.startIndex, offsetBy: 4)]),
            month = (dateID[dateID.index(dateID.startIndex, offsetBy: 4)...dateID.index(dateID.startIndex, offsetBy: 5)]),
            day = (dateID[dateID.index(dateID.startIndex, offsetBy: 6)...])
 
        
        var dateComponent = DateComponents()
        
        dateComponent.year = Int(year)
        dateComponent.month = Int(month)
        dateComponent.day = Int(day)! + 1 //Somehow the date object substract the day by 1

        let calendar = Calendar(identifier: .gregorian)
        let formatter = DateFormatter()

        let date = calendar.date(from: dateComponent)
        formatter.dateFormat = "EEEE, MMM d yyyy"
        return formatter.string(from: date!)
        
        
    }
    
}
