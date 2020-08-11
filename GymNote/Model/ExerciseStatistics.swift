//
//  ExerciseStatistics.swift
//  GymNote
//
//  Created by Rafał Swat on 07/08/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import Foundation
import SwiftUI

struct ExerciseStatistics {
    
    var exerciseID: String
    var exerciseName: String
    var exerciseData: [ExerciseData]
    
    //test init
    init() {
        self.exerciseID = UUID().uuidString
        self.exerciseName = "My Exercise"
        self.exerciseData = [ExerciseData()]
    }
    
    init(id: String,
         name: String,
         data: [ExerciseData]) {
        
        self.exerciseID = id
        self.exerciseName = name
        self.exerciseData = data
    }
    
}
