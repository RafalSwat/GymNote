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
    
    var exercise: Exercise
    var exerciseData: [ExerciseData]
    
    init(exercise: Exercise,
         data: [ExerciseData]) {
        self.exercise = exercise
        self.exerciseData = data
    }
    
    
    public static func == (lhs: ExerciseStatistics, rhs: ExerciseStatistics) -> Bool {
        return lhs.exercise.exerciseID == rhs.exercise.exerciseID
    }

}
