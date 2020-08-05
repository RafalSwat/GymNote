//
//  Exercise.swift
//  GymNote
//
//  Created by Rafał Swat on 01/03/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import Foundation

class Exercise: Hashable, Identifiable {
    
    var exerciseID: String
    var exerciseName: String
    var exerciseSeries: [Series]
    var exerciseIsCheck: Bool
    var exerciseNumberOfSeries: Int
    
    init(name: String) {
        
        self.exerciseID = UUID().uuidString
        self.exerciseName = name
        self.exerciseSeries = [Series]()
        self.exerciseIsCheck = false
        self.exerciseNumberOfSeries = 1
    }
    
    init(name: String,
         isCheck: Bool) {
        
        self.exerciseID = UUID().uuidString
        self.exerciseName = name
        self.exerciseSeries = [Series]()
        self.exerciseIsCheck = isCheck
        self.exerciseNumberOfSeries = 1
    }
    init(id: String,
         name: String,
         numberOfSeries: Int) {
        
        self.exerciseID = id
        self.exerciseName = name
        self.exerciseSeries = [Series]()
        self.exerciseIsCheck = false
        self.exerciseNumberOfSeries = numberOfSeries
    }
    
    init(id: String,
         name: String,
         series: [Series],
         isCheck: Bool,
         numberOfSeries: Int) {
        
        self.exerciseID = id
        self.exerciseName = name
        self.exerciseSeries = series
        self.exerciseIsCheck = isCheck
        self.exerciseNumberOfSeries = numberOfSeries
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
struct Series {
    var exerciseRepeats: Int
    var exerciseWeight: Int?
    
    init(repeats: Int, weight: Int) {
        self.exerciseRepeats = repeats
        self.exerciseWeight = weight
    }
    init(repeats: Int) {
        self.exerciseRepeats = repeats
        self.exerciseWeight = 0
    }
    init() {
        self.exerciseRepeats = 1
        self.exerciseWeight = 0
    }
}
