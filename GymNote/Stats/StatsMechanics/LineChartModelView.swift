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
    @Published var chartCase: ChartCase
    
    @Published var dataDates = [Date]()
    @Published var datesInRange = [Date]()
    
    @Published var dataAsDouble = [StatsAsDoubles]()
    @Published var dataValesAverage = [Double]()
    
    @Published var dataHightestValue = [Double]()
    @Published var dataLowestValue = [Double]()
    
    @Published var numberOfHorizontalLines = 10
    @Published var numberOfVerticalLines = 0
    @Published var numberOfValuesOnChart = 0
    
    @Published var maxYValue: Double = 0
    @Published var minYValue: Double = 0
    @Published var stepMultiplier: Double = 0
    
    
    init(data: ExerciseStatistics, chartCase: ChartCase) {
        self.data = data
        self.chartCase = chartCase
    }

    func normalizeData() {
        
        var repeats = [Double]()
        var weights = [Double]()
        var dates = [Double]()
        
        var averageValuesOfRepeats = [Double]()
        var averageValuesOfWeights = [Double]()
        
        for dataIndex in 0..<self.data.exerciseData.count {
            
            let dateAsDouble = Double(Calendar.current.ordinality(of: .day, in: .year, for: data.exerciseData[dataIndex].exerciseDate)!)
            
            var tempRepeatSum = 0.0
            var tempWeightSum = 0.0
            var averageRepeatValue = 0.0
            var averageWeightValue = 0.0
            
            for seriesIndex in 0..<self.data.exerciseData[dataIndex].exerciseSeries.count {
                tempRepeatSum += Double(self.data.exerciseData[dataIndex].exerciseSeries[seriesIndex].exerciseRepeats)
                tempWeightSum += Double(self.data.exerciseData[dataIndex].exerciseSeries[seriesIndex].exerciseWeight ?? 0)
                
                repeats.append(Double(self.data.exerciseData[dataIndex].exerciseSeries[seriesIndex].exerciseRepeats))
                weights.append(Double(self.data.exerciseData[dataIndex].exerciseSeries[seriesIndex].exerciseWeight ?? 0))
            }
            
            averageRepeatValue = tempRepeatSum/Double(self.data.exerciseData[dataIndex].exerciseSeries.count)
            averageWeightValue = tempWeightSum/Double(self.data.exerciseData[dataIndex].exerciseSeries.count)
            averageValuesOfRepeats.append(Double(averageRepeatValue))
            averageValuesOfWeights.append(Double(averageWeightValue))
            dates.append(dateAsDouble)
        }
        let maxRepeat = repeats.max()
        let minRepeat = repeats.min()
        let maxWeight = weights.max()
        let minWeight = weights.min()

        let minDate = self.datesInRange.min()
        let minDoubleDate = Double(Calendar.current.ordinality(of: .day, in: .year, for: minDate!)!)
        
        let repeatRange = maxRepeat! - minRepeat!
        let weightRange = maxWeight! - minWeight!
        let dateRange = self.datesInRange.count //Double(dates.count)
        
        var normalizeRepeats = [Double]()
        var normalizeWeights = [Double]()
        var normalizeDates = [Double]()
        
        for index in 0..<averageValuesOfRepeats.count {
            let normalizeRepeat = (averageValuesOfRepeats[index] - minRepeat!)/repeatRange
            let normalizeWeight = (averageValuesOfWeights[index] - minWeight!)/weightRange
            let normalizeDate = (dates[index] - minDoubleDate)/Double(dateRange)
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
        
        self.dataDates = dates.sorted()
        self.datesInRange = DateConverter().fillUpArrayWithDates(startDate: min, endDate: max)
        
        
    }

    func setupAverageValues() {
        
        var arryOfAveragesValues = [Double]()
        
        for index in 0..<self.data.exerciseData.count {
            if chartCase == .repetition {
                var sum = 0
                for series in self.data.exerciseData[index].exerciseSeries {
                    sum += series.exerciseRepeats
                }
                let averageValue = Double(sum)/Double(self.data.exerciseData[index].exerciseSeries.count)
                arryOfAveragesValues.append(averageValue)
            } else if chartCase == .weight {
                var sum = 0
                for series in self.data.exerciseData[index].exerciseSeries {
                    sum += series.exerciseWeight ?? 0
                }
                let averageValue = Double(sum)/Double(self.data.exerciseData[index].exerciseSeries.count)
                arryOfAveragesValues.append(averageValue)
            }
        }
        self.dataValesAverage = arryOfAveragesValues
    }
    func setupMinAndMaxValues() {
        
        var arrayOfMinValues = [Double]()
        var arrayOfMaxValues = [Double]()
        
        for index in 0..<self.data.exerciseData.count {
            var arrayOfValues = [Double]()
            
            if chartCase == .weight {
                for seriesIndex in 0..<self.data.exerciseData[index].exerciseSeries.count {
                    arrayOfValues.append(Double(self.data.exerciseData[index].exerciseSeries[seriesIndex].exerciseWeight ?? 0))
                }
            } else if chartCase == .repetition {
                for seriesIndex in 0..<self.data.exerciseData[index].exerciseSeries.count {
                    arrayOfValues.append(Double(self.data.exerciseData[index].exerciseSeries[seriesIndex].exerciseRepeats))
                }
            }
            
            let minValue = arrayOfValues.min() ?? 0
            let maxValue = arrayOfValues.max()!
            arrayOfMinValues.append(minValue)
            arrayOfMaxValues.append(maxValue)
        }
        self.dataLowestValue = arrayOfMinValues
        self.dataHightestValue = arrayOfMaxValues
    }
    
    
    func evaluateNumberOfVerticalLines() {
        if self.datesInRange.count != 0 {
            self.numberOfVerticalLines = self.datesInRange.count
        }
        
    }
    func evaluateNumberOfValuesOnChart() {
        if self.dataDates.count != 0 {
            self.numberOfValuesOnChart = self.dataDates.count
        }
    }
    
    func setupRangeOfValues() {
        
        var arrayOfvalues = [Double]()
        
        if self.chartCase == .repetition {
            for element in self.data.exerciseData {
                for index in 0..<element.exerciseSeries.count{
                    arrayOfvalues.append(Double(element.exerciseSeries[index].exerciseRepeats))
                }
            }
        } else if self.chartCase == .weight {
            for element in self.data.exerciseData {
                for index in 0..<element.exerciseSeries.count{
                    arrayOfvalues.append(Double(element.exerciseSeries[index].exerciseWeight ?? 0))
                }
            }
        } else {
            fatalError("Error: can not find chart case! (reps/weights)")
        }
        let max = arrayOfvalues.max()!
        let min = arrayOfvalues.min()!
        let range = max - min
        let step = range/10
        
        self.maxYValue = max
        self.minYValue = min
        self.stepMultiplier = step
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


