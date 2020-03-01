//
//  Exercise.swift
//  GymNote
//
//  Created by Rafał Swat on 01/03/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import Foundation

struct Exercise {
    var exerciseName: String
    var exerciseSeries: Int
    var exerciseRepeats: Int
    var exerciseWeight: Int?
    
    init(name: String,
         series: Int,
         repeats: Int,
         weight: Int?) {
        
        self.exerciseName = name
        self.exerciseSeries = series
        self.exerciseRepeats = repeats
        self.exerciseWeight = weight
    }
    
    static let `default` = Self(
        name: "",
        series: 4,
        repeats: 10,
        weight: 0
    )
}
