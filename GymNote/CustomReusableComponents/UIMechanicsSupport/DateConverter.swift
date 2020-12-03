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
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    static let shortDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    
    func convertFromString(dateString: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        if let dateTypeDate = formatter.date(from: dateString) {
            return dateTypeDate
        } else {
            print("Error: Data Converter Error: finds nil during converting!")
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
