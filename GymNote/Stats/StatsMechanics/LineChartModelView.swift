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
    @Published var dateFrom: Date
    @Published var dateTo: Date
    
    @Published var dataDates = [Date]()
    @Published var datesInRange = [Date]()
    
    @Published var dataAsDouble = [StatsAsDoubles]()
    
    @Published var repsOnAverage = [Double]()
    @Published var weightsOnAverage = [Double]()
    
    @Published var repsHightestValue = [Double]()
    @Published var repsLowestValue = [Double]()
    @Published var weightsHightestValue = [Double]()
    @Published var weightsLowestValue = [Double]()
    
    @Published var numberOfHorizontalLines = 10
    @Published var numberOfVerticalLines = 0
    @Published var numberOfValuesOnChart = 0
    
    @Published var maxRepsValue: Double = 0
    @Published var minRepsValue: Double = 0
    @Published var stepRepsMultiplier: Double = 0
    @Published var maxWeightValue: Double = 0
    @Published var minWeightValue: Double = 0
    @Published var stepWeightMultiplier: Double = 0
    
    
    
    
    init(data: ExerciseStatistics,
         chartCase: ChartCase,
         fromDate: Date,
         toDate: Date) {
        self.data = data
        self.chartCase = chartCase
        self.dateFrom = fromDate
        self.dateTo = toDate
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
        var maxRepeat = repeats.max()!
        var minRepeat = repeats.min()!
        var maxWeight = weights.max()!
        var minWeight = weights.min()!
        
        if maxRepeat == minRepeat {
            maxRepeat += 1
            minRepeat -= 1
        }
        if maxWeight == minWeight {
            maxWeight += 1
            minWeight -= 1
        }

        let minDate = self.datesInRange.min()
        let minDoubleDate = Double(Calendar.current.ordinality(of: .day, in: .year, for: minDate!)!)
        
        let repeatRange = maxRepeat - minRepeat
        let weightRange = maxWeight - minWeight
        let dateRange = self.datesInRange.count //Double(dates.count)
        
        var normalizeRepeats = [Double]()
        var normalizeWeights = [Double]()
        var normalizeDates = [Double]()
        
        for index in 0..<averageValuesOfRepeats.count {
            let normalizeRepeat = (averageValuesOfRepeats[index] - minRepeat)/repeatRange
            let normalizeWeight = (averageValuesOfWeights[index] - minWeight)/weightRange
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
        var max = maxValue
        var min = minValue
        if max == min {
            max += 1
            min -= 1
        }
        let range = max - min
        let normalizeValue = (value - min)/range
        return normalizeValue
    }
    
    func setupDatesRange() {
        var dates = [Date]()
        
        for elementOfData in self.data.exerciseData {
            let date = elementOfData.exerciseDate
            if date >= self.dateFrom && date <= self.dateTo {
                dates.append(elementOfData.exerciseDate)
            }
        }
        
        self.dataDates = dates.sorted()
        self.datesInRange = DateConverter().fillUpArrayWithDates(startDate: self.dateFrom,
                                                                 endDate: self.dateTo)
    }

    func setupAverageValues() {
        
        var repeatsOnAverage = [Double]()
        var weightsOnAverage = [Double]()
        
        for index in 0..<self.data.exerciseData.count {
            
            var repeatSum = 0
            var weigthtSum = 0
            for series in self.data.exerciseData[index].exerciseSeries {
                repeatSum += series.exerciseRepeats
                weigthtSum += series.exerciseWeight ?? 1
            }
            let averageRepeat = Double(repeatSum)/Double(self.data.exerciseData[index].exerciseSeries.count)
            let averageWeight = Double(weigthtSum)/Double(self.data.exerciseData[index].exerciseSeries.count)
            
            repeatsOnAverage.append(averageRepeat)
            weightsOnAverage.append(averageWeight)
        }
        self.repsOnAverage = repeatsOnAverage
        self.weightsOnAverage = weightsOnAverage
    }
    
    func setupMinAndMaxValues() {
        
        var repsMinValues = [Double]()
        var repsMaxValues = [Double]()
        
        var weightsMinValues = [Double]()
        var weightsMaxValues = [Double]()
        
        for index in 0..<self.data.exerciseData.count {
            var repsAllValues = [Double]()
            var weightsAllValues = [Double]()
            
            for seriesIndex in 0..<self.data.exerciseData[index].exerciseSeries.count {
                repsAllValues.append(Double(self.data.exerciseData[index].exerciseSeries[seriesIndex].exerciseRepeats))
                weightsAllValues.append(Double(self.data.exerciseData[index].exerciseSeries[seriesIndex].exerciseWeight ?? 0))
            }
            
            
            let repsMinValue = repsAllValues.min() ?? 1
            let repsMaxValue = repsAllValues.max()!
            let weightMinValue = weightsAllValues.min() ?? 1
            let weightMaxValue = weightsAllValues.max()!
            
            repsMinValues.append(repsMinValue)
            repsMaxValues.append(repsMaxValue)
            weightsMinValues.append(weightMinValue)
            weightsMaxValues.append(weightMaxValue)
        }
        self.repsHightestValue = repsMaxValues
        self.repsLowestValue = repsMinValues
        self.weightsHightestValue = weightsMaxValues 
        self.weightsLowestValue = weightsMinValues
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
        
        var arrayOfRepsValues = [Double]()
        var arrayOfWeightValues = [Double]()
        
        for element in self.data.exerciseData {
            for index in 0..<element.exerciseSeries.count{
                arrayOfRepsValues.append(Double(element.exerciseSeries[index].exerciseRepeats))
                arrayOfWeightValues.append(Double(element.exerciseSeries[index].exerciseWeight ?? 0))
            }
        }
        var maxReps = arrayOfRepsValues.max()!
        var minReps = arrayOfRepsValues.min()!
        if maxReps == minReps {
            maxReps += 1
            minReps -= 1
        }
        let rangeReps = maxReps - minReps
        let stepReps = rangeReps/10
        
        
        var maxWeights = arrayOfWeightValues.max()!
        var minWeights = arrayOfWeightValues.min()!
        if maxWeights == minWeights {
            maxWeights += 1
            minWeights -= 1
        }
        let rangeWeights = maxWeights - minWeights
        let stepWeights = rangeWeights/10
        
        self.maxRepsValue = maxReps
        self.minRepsValue = minReps
        self.stepRepsMultiplier = stepReps
        self.maxWeightValue = maxWeights
        self.minWeightValue = minWeights
        self.stepWeightMultiplier = stepWeights
    }
    
    func setupDataForTrendLine(xValues: [CGFloat], yValues: [CGFloat]) -> StartEndPoits {
        if xValues.count == yValues.count {
            var sumX = 0.0
            var sumY = 0.0
            for x in xValues {
                sumX += Double(x)
            }
            for y in xValues {
                sumY += Double(y)
            }
            let averageX = sumX/Double(xValues.count)
            let averageY = sumY/Double(yValues.count)
            
            var fractionSumX = [Double]()
            var fractionSumY = [Double]()
            var productXY = [Double]()
            var squareX = [Double]()
            for index in 0..<xValues.count {
                fractionSumX.append(Double(xValues[index]) - averageX)
                fractionSumY.append(Double(yValues[index]) - averageY)
                productXY.append(fractionSumX[index] * fractionSumY[index])
                
                let deviationX = (Double(xValues[index]) - averageX)
                squareX.append(deviationX * deviationX)
            }
            var nominator = 0.0
            var denominator = 0.0
            for index in 0..<productXY.count {
                nominator += productXY[index]
                denominator += squareX[index]
            }
            let a = nominator / denominator
            let b = averageY - a * averageX
            
            let startPointY = a * Double(xValues.first!) + b
            let endPointY = a * Double(xValues.last!) + b
        
            let startEndPoint = StartEndPoits(startPoint: CGFloat(startPointY), endPoint: CGFloat(endPointY))
            return startEndPoint
        } else {
            print("Error: number of values x is NOT equal to numbers of values y!")
            fatalError()
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
class StartEndPoits {
    var startPoint: CGFloat
    var endPoint: CGFloat
    
    init(startPoint: CGFloat,
         endPoint: CGFloat) {
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
}

enum ChartCase {
    case repetition
    case weight
}

enum ChartDisplayedValues {
    case greatest
    case average
}
