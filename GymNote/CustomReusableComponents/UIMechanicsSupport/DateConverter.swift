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
    
    func convertFromString(dateString: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        if let dateTypeDate = formatter.date(from: dateString) {
            return dateTypeDate
        } else {
            print("Error: Data Converter Error: finds nil during converting!")
            return Date()
        }
        
    }
    
}
