//
//  LineChartView.swift
//  GymNote
//
//  Created by Rafał Swat on 12/08/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct LineChartView: View {
    
    @ObservedObject var stats: LineChartModelView
    @State var chartCase: ChartCase
    var lineGradient = Gradient(colors: [Color.yellow,
                                         Color.orange,
                                         Color.red])
    @State var dotLocation: CGPoint = .zero
    @State var horizontalLineLocation: CGPoint = .zero
    @State var showDotChart = false
    @State var choosenIndex: Int = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                GeometryReader { reader in
                    Path { p in
                        
                        let points = self.convertDataToPoints(data: self.stats.dataAsDouble, maxHeight: reader.size.height, maxWidth: reader.size.width)
                        
                        p.move(to: points[0])
                        for index in 1..<points.count {
                            p.addLine(to: points[index])
                        }
                    }
                    .stroke(LinearGradient(gradient: self.lineGradient,
                                           startPoint: UnitPoint(x: 0.0, y: 1.0),
                                           endPoint: UnitPoint(x: 0.0, y: 0.0)),
                                           lineWidth: 3)
                    if self.showDotChart {
                        ChartDot()
                            .offset(x: self.dotLocation.x-2, y: self.dotLocation.y-3)
                        
                        Text("\(self.stats.dataWeightsOnAverage[self.choosenIndex], specifier: "%.2f")")
                            .offset(x: self.dotLocation.x-8, y: self.dotLocation.y-25)
                        Text("\(DateConverter.shortDateFormat.string(from: self.stats.data.exerciseData[self.choosenIndex].exerciseDate))")
                            .offset(x: self.dotLocation.x-20,
                                    y: CGFloat(Int((reader.size.height)))+10)
                            .foregroundColor(Color.secondary)
                            .font(.caption)
                    }
                    //setup horizontal lines
                    ForEach(0..<10) { iterator in
                        Group {
                            Path { p in
                                let yPoint = self.estimateYLocalization(value: Double(iterator+1),
                                                                        maxValue: Double(10),
                                                                        minValue: Double(1),
                                                                        maxHeight: reader.size.height)
                                let xStartPoint = self.estimateXLocalization(value: Double(1),
                                                                             maxValue: Double(self.stats.datesInRange.count),
                                                                             minValue: Double(0),
                                                                             maxWidth: reader.size.width)
                                let xEndPoint = self.estimateXLocalization(value: Double(self.stats.datesInRange.count),
                                                                           maxValue: Double(self.stats.datesInRange.count),
                                                                           minValue: Double(0),
                                                                           maxWidth: reader.size.width)
                                p.move(to: CGPoint(x: CGFloat(xStartPoint),
                                                   y: CGFloat(yPoint)))
                                p.addLine(to: CGPoint(x: CGFloat(xEndPoint),
                                                      y: CGFloat(yPoint)))
                            }                               .stroke(Color.secondary, lineWidth: 1)
                        }
                    }
                    
                    //setup vertical lines to grid
                    ForEach(1..<self.stats.datesInRange.count + 1) { iterator in
                        Group {
                            Path { p in
                                let xPoint = self.estimateXLocalization(value: Double(iterator),
                                                                        maxValue: Double(self.stats.datesInRange.count + 1),
                                                                        minValue: Double(1),
                                                                        maxWidth: reader.size.width)
                                p.move(to: CGPoint(x: xPoint,
                                                   y: 0))
                                p.addLine(to: CGPoint(x: Int(xPoint),
                                                      y: Int((reader.size.height))))
                                
                            }
                            .stroke(Color.secondary, lineWidth: 1)
                            
                            //Setup min max bars
                            //FIXME: The bars are setup in a loop base on datesInRange, so there could be a problem when
                            Path { p in
                                let xPoint = self.estimateXLocalization(value: Double(iterator),
                                                                        maxValue: Double(self.stats.datesInRange.count + 1),
                                                                        minValue: Double(1),
                                                                        maxWidth: reader.size.width)
                                let yStartPoint = self.estimateYLocalization(value: self.stats.dataLowestValueOfWeights[iterator-1],
                                                                             maxValue: self.getMaxValue(data: self.stats.data),
                                                                             minValue: self.getMinValue(data: self.stats.data),
                                                                             maxHeight: reader.size.height)
                                let yEndPoint = self.estimateYLocalization(value: self.stats.dataHightestValueOfWeights[iterator-1],
                                                                           maxValue: self.getMaxValue(data: self.stats.data),
                                                                           minValue: self.getMinValue(data: self.stats.data),
                                                                           maxHeight: reader.size.height)
                                p.move(to: CGPoint(x: xPoint,
                                                   y: yStartPoint))
                                p.addLine(to: CGPoint(x: xPoint,
                                                      y: yEndPoint))
                                
                                p.move(to: CGPoint(x: xPoint-3,
                                                   y: yStartPoint))
                                p.addLine(to: CGPoint(x: xPoint+3,
                                                      y: yStartPoint))
                                p.move(to: CGPoint(x: xPoint-3,
                                                   y: yEndPoint))
                                p.addLine(to: CGPoint(x: xPoint+3,
                                                      y: yEndPoint))
                                
                            }.stroke(Color.red, lineWidth: 1.5)
                        }
                    }
                    
                    ForEach(0..<10) { index in
                        Text("\(self.estimateYAxisDescription(line: index), specifier: "%.1f")")
                            .offset(x: self.estimateXLocalization(value: Double(1),
                                                                  maxValue: Double(self.stats.datesInRange.count + 1),
                                                                  minValue: Double(1),
                                                                  maxWidth: reader.size.width)-35,
                                    y: self.estimateYLocalization(value: Double(index+1),
                                                                  maxValue: Double(10),
                                                                  minValue: Double(1),
                                                                  maxHeight: reader.size.height)-5)
                            .foregroundColor(Color.secondary)
                            .font(.system(size: 13))
                    }
                }
            }
            .gesture(DragGesture()
            .onChanged({ value in
                self.showDotChart = true
                withAnimation {
                    self.dotLocation = self.getClosestDataPoint(point: value.location,
                                                                width: geometry.size.width,
                                                                height: geometry.size.height)
                    self.horizontalLineLocation = self.getClosestDataPoint(point: value.location,
                                                                           width: geometry.size.width,
                                                                           height: geometry.size.height)
                    self.choosenIndex = self.getDataAssociatedWithpoint(at: self.dotLocation,
                                                                        width: geometry.size.width,
                                                                        height: geometry.size.height)
                }
            })
                .onEnded({ value in
                    self.showDotChart = false
                    withAnimation {
                        self.dotLocation = self.getClosestDataPoint(point: value.location,
                                                                    width: geometry.size.width,
                                                                    height: geometry.size.height)
                        self.horizontalLineLocation = self.getClosestDataPoint(point: value.location,
                                                                               width: geometry.size.width,
                                                                               height: geometry.size.height)
                    }
                })
            )
        }

        
    }
    
    
    func convertDataToPoints(data: [StatsAsDoubles], maxHeight: CGFloat, maxWidth: CGFloat) -> [CGPoint] {
        var yPoints = [CGFloat]()
        var xPoints = [CGFloat]()
        var points = [CGPoint]()
        
        let chartWidth = maxWidth/1.2
        
        for index in 0..<data.count {
            if self.chartCase == .repetition {
                let convertValueY = maxHeight * CGFloat(data[index].repeatsAsDouble)
                yPoints.append(convertValueY)
            } else if self.chartCase == .weight {
                let convertValueY = maxHeight * CGFloat(data[index].weightsAsDouble)
                yPoints.append(convertValueY)
            }
        }
        for index in 0..<data.count {
            let convertValueX = chartWidth * CGFloat(data[index].dateAsDouble)
            xPoints.append(convertValueX)
        }
        for index in 0..<data.count {
            let point = CGPoint(x: xPoints[index]+(maxWidth-chartWidth), y: maxHeight-yPoints[index])
            points.append(point)
        }
        return points
    }
    
    func estimateXLocalization(value: Double, maxValue: Double, minValue: Double, maxWidth: CGFloat) -> CGFloat {
        let chartWidth = maxWidth/1.2
        let shiftX = maxWidth - chartWidth
        let normalizeX = self.stats.normalizePoint(value: value,
                                             maxValue: Double(self.stats.datesInRange.count + 1),
                                             minValue: Double(1))
        let scaleX = CGFloat(normalizeX) * chartWidth
        let xPoint = scaleX + CGFloat(shiftX)
        return xPoint
    }
    
    func estimateYLocalization(value: Double, maxValue: Double, minValue: Double, maxHeight: CGFloat) -> CGFloat {
        let chartHeight = maxHeight
        let normalizeY = self.stats.normalizePoint(value: value,
                                                   maxValue: maxValue,
                                                   minValue: minValue)
        let yPoint = CGFloat(normalizeY) * chartHeight
        return maxHeight - yPoint
    }
    
    func estimateYAxisDescription(line: Int) -> Double {
        var values = [Double]()
        
        for dataIndex in 0..<self.stats.data.exerciseData.count {
            for seriesIndex in 0..<self.stats.data.exerciseData[dataIndex].exerciseNumberOfSeries {
                if self.chartCase == .weight {
                    values.append(Double(self.stats.data.exerciseData[dataIndex].exerciseSeries[seriesIndex].exerciseWeight ?? 0))
                } else if self.chartCase == .repetition {
                    values.append(Double(self.stats.data.exerciseData[dataIndex].exerciseSeries[seriesIndex].exerciseRepeats))
                }
            }
        }
        let maxValue = values.max()
        let minValue = values.min()
        let range = maxValue! - minValue!
        let shift = range/9
        
        let value = minValue! + (Double(line) * shift)
        
        return value
        
    }
    
    func getClosestDataPoint(point: CGPoint, width:CGFloat, height: CGFloat) -> CGPoint {
        let points = self.convertDataToPoints(data: self.stats.dataAsDouble, maxHeight: height, maxWidth: width)
        var pointsX = [CGFloat]()
        var pointsY = [CGFloat]()
        
        for point in points {
            pointsY.append(point.y)
            pointsX.append(point.x)
        }
        
        let locationValueX = point.x
        let closestValue = ArrayQuery().closestValue(array: pointsX, target: locationValueX)
        
        let index = pointsX.firstIndex(of: closestValue)
        
        if (index! >= 0 && index! < points.count) {
            return CGPoint(x: points[index!].x-3, y: points[index!].y)
        }
        return .zero
    }
    
    func getDataAssociatedWithpoint(at point: CGPoint, width: CGFloat, height: CGFloat) -> Int {
        let points = self.convertDataToPoints(data: self.stats.dataAsDouble, maxHeight: height, maxWidth: width)
        var pointsY = [CGFloat]()
        for pointY in points {
            pointsY.append(pointY.y)
        }
        
        let index = pointsY.firstIndex(of: point.y) ?? 0
        return index
    }
    
    func getMaxValue(data: ExerciseStatistics) -> Double {
        
        var arrayOfvalues = [Double]()
        
        if self.chartCase == .repetition {
            for element in data.exerciseData {
                for index in 0..<element.exerciseSeries.count{
                    arrayOfvalues.append(Double(element.exerciseSeries[index].exerciseRepeats))
                }
            }
        } else if self.chartCase == .weight {
            for element in data.exerciseData {
                for index in 0..<element.exerciseSeries.count{
                    arrayOfvalues.append(Double(element.exerciseSeries[index].exerciseWeight ?? 0))
                }
            }
        } else {
            fatalError("Error: can not find chart case! (reps/weights)")
        }
        let maxValue = arrayOfvalues.max()!
        return maxValue
    }
    func getMinValue(data: ExerciseStatistics) -> Double {
        
        var arrayOfvalues = [Double]()
        
        if self.chartCase == .repetition {
            for element in data.exerciseData {
                for index in 0..<element.exerciseSeries.count{
                    arrayOfvalues.append(Double(element.exerciseSeries[index].exerciseRepeats))
                }
            }
        } else if self.chartCase == .weight {
            for element in data.exerciseData {
                for index in 0..<element.exerciseSeries.count{
                    arrayOfvalues.append(Double(element.exerciseSeries[index].exerciseWeight ?? 0))
                }
            }
        } else {
            fatalError("Error: can not find chart case! (reps/weights)")
        }
        let maxValue = arrayOfvalues.min()!
        return maxValue
    }
}



struct LineChartView_Previews: PreviewProvider {
    
    static var prevStats = LineChartModelView(data: ExerciseStatistics())

    static var previews: some View {
        LineChartView(stats: prevStats, chartCase: .weight)
    }
}

