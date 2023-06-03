//
//  File.swift
//  
//
//  Created by PEXAVC on 12/15/20.
//

import Foundation

extension String {
    func asDate() -> Date? {
        return Calendar.nyDateFormatter.date(from: self)
    }
}

extension Date {
    var asString: String {
        return Calendar.nyDateFormatter.string(from: self)
    }
    
    func dateComponents() -> (year: Int, month: Int, day: Int) {
        let calendar = Calendar.nyCalendar

        let day = calendar.component(.day, from: self)
        let month = calendar.component(.month, from: self)
        let year = calendar.component(.year, from: self)
        
        return(year, month, day)
    }
    func timeComponents() -> (hour: Int, minute: Int, seconds: Int) {
        let time = Calendar.nyTimeFormatter.string(from: self)
        let components = time.components(separatedBy: ":")
        var hour: Int = 0
        var minute: Int = 0
        var seconds: Int = 0
        if components.count == 3 {
            hour = Int(components[0]) ?? 0
            minute = Int(components[1]) ?? 0
            seconds = Int(components[2]) ?? 0
        }
        return (hour, minute, seconds)
    }
    
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
}

extension Calendar {
    static var nyTimezone: TimeZone {
        return TimeZone(identifier: "America/New_York") ?? .current
    }
    
    static var nyCalendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = Calendar.nyTimezone
        
        return calendar
    }
    
    static var nyDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = Calendar.nyTimezone
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }
    
    static var nyTimeFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = Calendar.nyTimezone
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter
    }
}

extension Double {
    func date() -> Date {
        let unixDate: Double = self
        let date = Date.init(timeIntervalSince1970: TimeInterval(unixDate))
        return date
    }
}
