//
//  Exercise.swift
//  GymNote
//
//  Created by Rafał Swat on 01/03/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import Foundation

struct Exercise: Hashable {
    var exerciseName: String
    var exerciseSeries: Int
    var exerciseRepeats: Int
    var exerciseWeight: Int?
    var exerciseIsCheck: Bool
    
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

    init(name: String,
         series: Int,
         repeats: Int,
         weight: Int?,
         isCheck: Bool) {
        
        self.exerciseName = name
        self.exerciseSeries = series
        self.exerciseRepeats = repeats
        self.exerciseWeight = weight
        self.exerciseIsCheck = isCheck
    }
    
    init(name: String, isCheck: Bool) {
        self.exerciseName = name
        self.exerciseSeries = 1
        self.exerciseRepeats = 10
        self.exerciseWeight = 0
        self.exerciseIsCheck = isCheck
    }
    
    init(name: String) {
        self.exerciseName = name
        self.exerciseSeries = 1
        self.exerciseRepeats = 10
        self.exerciseWeight = 0
        self.exerciseIsCheck = false
    }
    
    static let `default` = Self(
        name: "",
        series: 4,
        repeats: 10,
        weight: 0,
        isCheck: false
    )

}