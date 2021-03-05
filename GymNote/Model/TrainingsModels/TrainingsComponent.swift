//
//  TrainingsComponent.swift
//  GymNote
//
//  Created by Rafał Swat on 16/11/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class TrainingsComponent: Hashable, Identifiable, ObservableObject {
    @Published var exercise: Exercise
    @Published var exerciseNumberOfSeries: Int
    @Published var exerciseOrderInList: Int
    @Published var isCheck = false
    
    init(exercise: Exercise,
         numberOfSeries: Int,
         orderInList: Int,
         isCheck: Bool) {
        
        self.exercise = exercise
        self.exerciseNumberOfSeries = numberOfSeries
        self.exerciseOrderInList = orderInList
        self.isCheck = isCheck
    }
    
    init(exercise: Exercise,
         numberOfSeries: Int,
         orderInList: Int) {
        
        self.exercise = exercise
        self.exerciseNumberOfSeries = numberOfSeries
        self.exerciseOrderInList = orderInList
    }
    
    //MARK: String is a built-in type, which means it is hashable by default
    //    public var hashValue: Int {
    //        return exerciseName.hashValue
    //    }
    func hash(into hasher: inout Hasher) {
        return hasher.combine(exercise.exerciseName)
    }
        
        
    //MARK: Hashable inherits from Equatable so our struct must implemented requirements for both
    //We must implemented func that compare two var, to chceck if there are equal or not (Equatable protocol)
    public static func == (lhs: TrainingsComponent, rhs: TrainingsComponent) -> Bool {
        return lhs.exercise.exerciseName == rhs.exercise.exerciseName
    }
}
