//
//  UserTrainings.swift
//  GymNote
//
//  Created by Rafał Swat on 01/03/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import Foundation

struct UserTrainings {
    
    var userID: String
    var programName: String
    var programCreateDate: Date
    
    var exercises: [Exercise] = []
    
    init(id: String,
         name: String,
         date: Date) {
        
        self.userID = id
        self.programName = name
        self.programCreateDate = date
    }
}
