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

class Training: Hashable, ObservableObject {

    @Published var trainingID: String
    @Published var trainingName: String
    @Published var trainingDescription: String
    @Published var initialDate: String
    @Published var listOfExercises: [TrainingsComponent]
    
    init() {
        self.trainingID = UUID().uuidString
        self.trainingName = ""//"My Training"
        self.trainingDescription = ""//My Little Description"
        self.initialDate = DateConverter.dateFormat.string(from: Date())
        self.listOfExercises = [TrainingsComponent]()
    }
    init(id: String,
         name: String,
         description: String,
         date: String) {
        
        self.trainingID = id
        self.trainingName = name
        self.trainingDescription = description
        self.initialDate = date
        self.listOfExercises = [TrainingsComponent]()
    }
    
    init(id: String,
         name: String,
         description: String,
         date: String,
         exercises: [TrainingsComponent]) {
        
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
