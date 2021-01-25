//
//  Exercise.swift
//  GymNote
//
//  Created by Rafał Swat on 01/03/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import Foundation
import Combine

class Exercise: Hashable, Identifiable, ObservableObject {
    
    var exerciseID: String
    var exerciseName: String
    var exerciseCreatedByUser: Bool
    
    init(id: String,
         name: String,
         createdByUser: Bool) {
        
        self.exerciseID = id
        self.exerciseName = name
        self.exerciseCreatedByUser = createdByUser
    }
    init() {
        self.exerciseID = "1"
        self.exerciseName = "my exercise"
        self.exerciseCreatedByUser = false
    }
    
    
    
    //MARK: String is a built-in type, which means it is hashable by default
    //    public var hashValue: Int {
    //        return exerciseName.hashValue
    //    }
    func hash(into hasher: inout Hasher) {
        return hasher.combine(exerciseName)
    }
    
    
    //MARK: Hashable inherits from Equatable so our struct must implemented requirements for both
    //We must implemented func that compare two var, to chceck if there are equal or not (Equatable protocol)
    public static func == (lhs: Exercise, rhs: Exercise) -> Bool {
        return lhs.exerciseName == rhs.exerciseName
    }
    
}
