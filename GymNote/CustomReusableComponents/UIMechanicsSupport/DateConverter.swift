//
//  DateConverter.swift
//  GymNote
//
//  Created by Rafał Swat on 20/02/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import Foundation

class DateConverter {
    
    static let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        return formatter
    }()
    static let shortDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        return formatter
    }()
    static let fullDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        return formatter
    }()
    
    static func convertFromString(dateString: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        if let dateTypeDate = formatter.date(from: dateString) {
            return dateTypeDate
        } else {
            print("Error: Data Converter Error: finds nil during converting String --> Date! - .default format")
            return Date()
        }
    }
    static func convertFromStringFull(dateString: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        if let dateTypeDate = formatter.date(from: dateString) {
            return dateTypeDate
        } else {
            print("Error: Data Converter Error: finds nil during converting String --> Date! - .full format")
            return Date()
        }
    }
    static func convertFromStringShort(dateString: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        if let dateTypeDate = formatter.date(from: dateString) {
            return dateTypeDate
        } else {
            print("Error: Data Converter Error: finds nil during converting String --> Date! - .short format")
            return Date()
        }
    }

    
    func fillUpArrayWithDates(startDate: Date, endDate: Date) -> [Date] {

        var dates:[Date] = []
        let interval = Double(3600*24)   //one day
        
        //MARK: for chart aesthetics the range will be greater
        let start = startDate.timeIntervalSinceReferenceDate - interval
        let end = endDate.timeIntervalSinceReferenceDate + interval
        
        var currentDate = Date(timeIntervalSinceReferenceDate: start)

        while currentDate.timeIntervalSinceReferenceDate < end {
            dates.append(currentDate)
            currentDate = currentDate.addingTimeInterval(interval)
        }
        dates.append(currentDate)
        return dates
        
    }
    
}
extension Date {

    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

}
