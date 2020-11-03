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
    var exerciseNumberOfSeries: Int
    var exerciseDate: Date
    var exerciseSeries: [Series]
    
    
    //test init
    init() {
        self.exerciseDataID = UUID().uuidString
        self.exerciseNumberOfSeries = 1
        self.exerciseDate = Date()
        self.exerciseSeries = [Series(repeats: 1, weight: 1)]
    }
    
    init(dataID: String,
         numberOfSeries: Int,
         date: Date,
         series: [Series]) {
        
        self.exerciseDataID = dataID
        self.exerciseNumberOfSeries = numberOfSeries
        self.exerciseDate = date
        self.exerciseSeries = series

    }
}

