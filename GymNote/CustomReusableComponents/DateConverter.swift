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
}
