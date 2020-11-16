//
//  ExerciseData.swift
//  GymNote
//
//  Created by Rafał Swat on 07/08/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import Foundation
import SwiftUI

struct ExerciseData {
    var exerciseDataID: String
    var exerciseDate: Date
    var exerciseSeries: [Series]
    
    
    //test init
    init() {
        self.exerciseDataID = UUID().uuidString
        self.exerciseDate = Date()
        self.exerciseSeries = [Series(repeats: 1, weight: 1)]
    }
    
    init(dataID: String,
         date: Date,
         series: [Series]) {
        
        self.exerciseDataID = dataID
        self.exerciseDate = date
        self.exerciseSeries = series

    }
}

