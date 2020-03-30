//
//  UserTrainings.swift
//  GymNote
//
//  Created by Rafał Swat on 27/03/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class UserTrainnings {
    
    var userID: String
    var listOfTrainings: [Training]
    
    init(id: String,
         trainings: [Training]) {
        
        self.userID = id
        self.listOfTrainings = trainings
    }
}
