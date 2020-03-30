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

class Training {
    
    var trainingID = UUID().uuidString
    var trainingName: String
    var trainingSubscription: String
    var initialDate: String
    var listOfExercises: [Exercise]
    
    init(name: String,
         subscription: String,
         date: String,
         exercises: [Exercise]) {
        
        self.trainingName = name
        self.trainingSubscription = subscription
        self.initialDate = date
        self.listOfExercises = exercises
    }
    
    
    
    
    
}
