//
//  TrainingSession.swift
//  GymNote
//
//  Created by Rafał Swat on 03/03/2021.
//  Copyright © 2021 Rafał Swat. All rights reserved.
//

import Foundation
import SwiftUI

class TrainingSession: ObservableObject {
    
    var trainingID: String
    var trainingName: String
    var trainingDescription: String
    var trainingDates: [Date]
    
    init(trainingID: String,
         trainingName: String,
         trainingDescription: String,
         trainingDates: [Date]) {
        
        self.trainingID = trainingID
        self.trainingName = trainingName
        self.trainingDescription = trainingDescription
        self.trainingDates = trainingDates
    }
    
}
