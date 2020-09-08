//
//  LineChartModelView.swift
//  GymNote
//
//  Created by Rafał Swat on 31/08/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import Foundation
import SwiftUI

class LineChartModelView: ObservableObject {
    
    @Published var data: ExerciseStatistics
    
    @Published var datesInRange = [Date]()
    @Published var dataAsDouble = [StatsAsDoubles]()
    @Published var dataRepsOnAverage = [Double]()
    @Published var dataWeightsOnAverage = [Double]()
    
    @Published var dataHightestValueOfReps = [Double]()
    @Published var dataLowestValueOfReps = [Double]()
    @Published var dataHightestValueOfWeights = [Double]()
    @Published var dataLowestValueOfWeights = [Double]()
    
    
    init(data: ExerciseStatistics) {
        self.data = data
    }

    func normalizeData() {
        
        var repeats = [Double]()
        var weights = [Double]()
        var dates = [Double]()
        
        var averageValuesOfRepeats = [Double]()
        var averageValuesOfWeights = [Double]()
        
        for dataIndex in 0..<self.data.exerciseData.count {
            
            let dataAsDouble = Double(Calendar.current.ordinality(of: .day, in: .year, for: data.exerciseData[dataIndex].exerciseDate)!)
            
            
            var tempRepeatSum = 0
            var tempWeightSum = 0
            var averageRepeatValue = 0
            var averageWeightValue = 0
            
            for seriesIndex in 0..<self.data.exerciseData[dataIndex].exerciseNumberOfSeries {
                tempRepeatSum += self.data.exerciseData[dataIndex].exerciseSeries[seriesIndex].exerciseRepeats
                tempWeightSum += self.data.exerciseData[dataIndex].exerciseSeries[seriesIndex].exerciseWeight ?? 0
                
                repeats.append(Double(self.data.exerciseData[dataIndex].exerciseSeries[seriesIndex].exerciseRepeats))
                weights.append(Double(self.data.exerciseData[dataIndex].exerciseSeries[seriesIndex].exerciseWeight ?? 0))
            }
            
            averageRepeatValue = Int(tempRepeatSum/self.data.exerciseData[dataIndex].exerciseNumberOfSeries)
            averageWeightValue = Int(tempWeightSum/self.data.exerciseData[dataIndex].exerciseNumberOfSeries)
            averageValuesOfRepeats.append(Double(averageRepeatValue))
            averageValuesOfWeights.append(Double(averageWeightValue))
            dates.append(dataAsDouble)
        }
        let maxRepeat = repeats.max()
        let minRepeat = repeats.min()
        let maxWeight = weights.max()
        let minWeight = weights.min()
        
        
        //let maxDate = dates.max()
        let minDate = dates.min()
        
        let repeatRange = maxRepeat! - minRepeat!
        let weightRange = maxWeight! - minWeight!
        let dateRange = Double(self.datesInRange.count)
        
        var normalizeRepeats = [Double]()
        var normalizeWeights = [Double]()
        var normalizeDates = [Double]()
        
        for index in 0..<averageValuesOfRepeats.count {
            let normalizeRepeat = (averageValuesOfRepeats[index] - minRepeat!)/repeatRange
            let normalizeWeight = (averageValuesOfWeights[index] - minWeight!)/weightRange
            let normalizeDate = (dates[index] - minDate!)/dateRange
            normalizeRepeats.append(normalizeRepeat)
            normalizeWeights.append(normalizeWeight)
            normalizeDates.append(normalizeDate)
        }
        var doubleData = [StatsAsDoubles]()
        for index in 0..<averageValuesOfRepeats.count {
            let elementOfDoubleData = StatsAsDoubles(date: normalizeDates[index],
                                                     repeats: normalizeRepeats[index],
                                                     weights: normalizeWeights[index])
            doubleData.append(elementOfDoubleData)
        }
        self.dataAsDouble = doubleData
    }
    
    func normalizePoint(value: Double, maxValue: Double, minValue: Double) -> Double {
        let range = maxValue - minValue
        let normalizeValue = (value - minValue)/range
        return normalizeValue
    }
    
    func setupDatesRange() {
        var dates = [Date]()
        
        for elementOfData in self.data.exerciseData {
            dates.append(elementOfData.exerciseDate)
        }
        let min = dates.min()!
        let max = dates.max()!
        self.datesInRange = DateConverter().fillUpArrayWithDates(startDate: min, endDate: max)
    }
    
    func getAverage(chartCase: ChartCase) {
        
        var arryOfAveragesValues = [Double]()
        
        for index in 0..<self.data.exerciseData.count {
            if chartCase == .repetition {
                var sum = 0
                for series in self.data.exerciseData[index].exerciseSeries {
                    sum += series.exerciseRepeats
                }
                let averageValue = Double(sum)/Double(self.data.exerciseData[index].exerciseNumberOfSeries)
                arryOfAveragesValues.append(averageValue)
            } else if chartCase == .weight {
                var sum = 0
                for series in self.data.exerciseData[index].exerciseSeries {
                    sum += series.exerciseWeight ?? 0
                }
                let averageValue = Double(sum)/Double(self.data.exerciseData[index].exerciseNumberOfSeries)
                arryOfAveragesValues.append(averageValue)
            }
        }
        if chartCase == .repetition {
            self.dataRepsOnAverage = arryOfAveragesValues
        } else if chartCase == .weight {
            self.dataWeightsOnAverage = arryOfAveragesValues
        }
    }
    func getMinAndMax(chartCase: ChartCase) {
        
        var arrayOfMinValues = [Double]()
        var arrayOfMaxValues = [Double]()
        
        for index in 0..<self.data.exerciseData.count {
            var arrayOfValues = [Double]()
            
            if chartCase == .weight {
                for series in self.data.exerciseData[index].exerciseSeries {
                    arrayOfValues.append(Double(series.exerciseWeight ?? 0))
                }
            } else if chartCase == .repetition {
                for series in self.data.exerciseData[index].exerciseSeries {
                    arrayOfValues.append(Double(series.exerciseWeight ?? 0))
                }
            } else { return }
            
            let minValue = arrayOfValues.min() ?? 0
            let maxValue = arrayOfValues.max()!
            arrayOfMinValues.append(minValue)
            arrayOfMaxValues.append(maxValue)
        }
        
        if chartCase == .weight {
            self.dataLowestValueOfWeights = arrayOfMinValues
            self.dataHightestValueOfWeights = arrayOfMaxValues
        } else if chartCase == .repetition {
            self.dataLowestValueOfReps = arrayOfMinValues
            self.dataHightestValueOfReps = arrayOfMaxValues
        }
    }
    
}

class StatsAsDoubles {
    var dateAsDouble: Double
    var repeatsAsDouble: Double
    var weightsAsDouble: Double
    
    init(date: Double,
         repeats: Double,
         weights: Double) {
        
        self.dateAsDouble = date
        self.repeatsAsDouble = repeats
        self.weightsAsDouble = weights
    }
}

enum ChartCase {
    case repetition
    case weight
}


