//
//  ExerciseStatistics.swift
//  GymNote
//
//  Created by Rafał Swat on 07/08/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import Foundation
import SwiftUI

class ExerciseStatistics: Equatable, ObservableObject {
    
    var exerciseID: String
    var exerciseName: String
    var exerciseCreatedByUser: Bool
    var exerciseData: [ExerciseData]
    
    //test init
    init() {
        self.exerciseID = UUID().uuidString
        self.exerciseName = "My Exercise"
        self.exerciseCreatedByUser = false
        self.exerciseData = [ExerciseData]()
    }
    
    init(id: String,
         name: String,
         data: [ExerciseData]) {
        
        self.exerciseID = id
        self.exerciseName = name
        self.exerciseCreatedByUser = false
        self.exerciseData = data
    }
    
    init(id: String,
         name: String,
         createdByUser: Bool,
         data: [ExerciseData]) {
        
        self.exerciseID = id
        self.exerciseName = name
        self.exerciseCreatedByUser = createdByUser
        self.exerciseData = data
    }
    
    public static func == (lhs: ExerciseStatistics, rhs: ExerciseStatistics) -> Bool {
        return lhs.exerciseID == rhs.exerciseID
    }

}
