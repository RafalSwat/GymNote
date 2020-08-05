//
//  Training.swift
//  GymNote
//
//  Created by Rafał Swat on 27/03/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class Training: Hashable {

    var trainingID: String
    var trainingName: String
    var trainingDescription: String
    var initialDate: String
    var listOfExercises: [Exercise]
    
    init() {
        self.trainingID = UUID().uuidString
        self.trainingName = ""//"My Training"
        self.trainingDescription = ""//My Little Description"
        self.initialDate = "01-Jan-2020"
        self.listOfExercises = [Exercise]()
    }
    init(id: String,
         name: String,
         description: String,
         date: String) {
        
        self.trainingID = id
        self.trainingName = name
        self.trainingDescription = description
        self.initialDate = date
        self.listOfExercises = [Exercise]()
    }
    
    init(id: String,
         name: String,
         description: String,
         date: String,
         exercises: [Exercise]) {
        
        self.trainingID = id
        self.trainingName = name
        self.trainingDescription = description
        self.initialDate = date
        self.listOfExercises = exercises
    }
    
    //MARK: String is a built-in type, which means it is hashable by default
    func hash(into hasher: inout Hasher) {
        return hasher.combine(trainingName)
    }
    
    //MARK: Hashable inherits from Equatable so our struct must implemented requirements for both
    //We must implemented func that compare two var, to chceck if there are equal or not (Equatable protocol)
    public static func == (lhs: Training, rhs: Training) -> Bool {
        return lhs.trainingName == rhs.trainingName
    }
    
    
    
}
