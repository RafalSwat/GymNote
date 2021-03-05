//
//  Series.swift
//  GymNote
//
//  Created by Rafał Swat on 18/11/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import Foundation
import SwiftUI

struct Series {
    var seriesID: String
    var orderInSeries: Int
    var exerciseRepeats: Int
    var exerciseWeight: Int?
    
    init() {
        self.seriesID = UUID().uuidString
        self.orderInSeries = 0
        self.exerciseRepeats = 1
        self.exerciseWeight = 0
    }
    init(repeats: Int) {
        self.seriesID = UUID().uuidString
        self.orderInSeries = 0
        self.exerciseRepeats = repeats
        self.exerciseWeight = 0
    }
    init(repeats: Int, weight: Int) {
        self.seriesID = UUID().uuidString
        self.orderInSeries  = 0
        self.exerciseRepeats = repeats
        self.exerciseWeight = weight
    }
    init(id: String, order: Int, repeats: Int, weight: Int) {
        self.seriesID = id
        self.orderInSeries = order
        self.exerciseRepeats = repeats
        self.exerciseWeight = weight
    }
}
