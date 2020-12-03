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
    
    @State var dotLocation: CGPoint = .zero
    @State var horizontalLineLocation: CGPoint = .zero
    @State var showDotChart = false
    @State var choosenIndex: Int = 0
    
    var lineGradient = Gradient(colors: [Color.yellow,
                                         Color.orange,
                                         Color.red])
    
    
    
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
                        
                        Text("\(self.stats.dataValesAverage[self.choosenIndex], specifier: "%.2f")")
                            .offset(x: self.dotLocation.x-8, y: self.dotLocation.y-25)
                        Text("\(DateConverter.shortDateFormat.string(from: self.stats.data.exerciseData[self.choosenIndex].exerciseDate))")
                            .offset(x: self.dotLocation.x-20,
                                    y: CGFloat(Int((reader.size.height)))+10)
                            .foregroundColor(Color.secondary)
                            .font(.caption)
                    }
                    //setup horizontal lines
                    ForEach(0..<self.stats.numberOfHorizontalLines+1, id: \.self) { iterator in
                        Group {
                            Path { p in
                                let yPoint = self.estimateYLocalization(value: (Double(iterator+1) * self.stats.stepMultiplier),
                                                                        maxValue: Double(11 * self.stats.stepMultiplier),
                                                                        minValue: Double(1 * self.stats.stepMultiplier),
                                                                        maxHeight: reader.size.height)
                                let xStartPoint = self.estimateXLocalization(value: Double(1),
                                                                             maxValue: Double(self.stats.numberOfVerticalLines+1),
                                                                             minValue: Double(1),
                                                                             maxWidth: reader.size.width)
                                let xEndPoint = self.estimateXLocalization(value: Double(self.stats.numberOfVerticalLines),
                                                                           maxValue: Double(self.stats.numberOfVerticalLines+1),
                                                                           minValue: Double(1),
                                                                           maxWidth: reader.size.width)
                                
                                p.move(to: CGPoint(x: xStartPoint,
                                                   y: yPoint))
                                p.addLine(to: CGPoint(x: xEndPoint,
                                                      y: yPoint))
                            }
                            .stroke(Color.secondary, lineWidth: 1)
                        }
                    }
                    // setup description to y axis
                    ForEach(0..<self.stats.numberOfHorizontalLines+1, id: \.self) { index in
                        let xPoint = self.estimateXLocalization(value: Double(1),
                                                                maxValue: Double(self.stats.datesInRange.count+1),
                                                                minValue: Double(1),
                                                                maxWidth: reader.size.width)-35
                        let yPoint = self.estimateYLocalization(value: Double(Double(index+1) * self.stats.stepMultiplier),
                                                                maxValue: Double(11 * self.stats.stepMultiplier),
                                                                minValue: Double(1 * self.stats.stepMultiplier),
                                                                maxHeight: reader.size.height)-5
                        Text("\(self.estimateYAxisDescription(line: index), specifier: "%.1f")")
                            .offset(x: xPoint,
                                    y: yPoint)
                            .foregroundColor(Color.secondary)
                            .font(.system(size: 13))
                    }
                    
                    //setup vertical lines to grid
                    ForEach(0..<self.stats.numberOfVerticalLines, id: \.self) { iterator in
                        Group {
                            Path { p in
                                let xPoint = self.estimateXLocalization(value: Double(iterator+1),
                                                                        maxValue: Double(self.stats.numberOfVerticalLines+1),
                                                                        minValue: Double(1),
                                                                        maxWidth: reader.size.width)
                                
                                let yStartPoint = self.estimateYLocalization(value: Double(11 * self.stats.stepMultiplier),
                                                                        maxValue: Double(11 * self.stats.stepMultiplier),
                                                                        minValue: Double(1 * self.stats.stepMultiplier),
                                                                        maxHeight: reader.size.height)
                                
                                let yEndPoint = self.estimateYLocalization(value: Double(1 * self.stats.stepMultiplier),
                                                                           maxValue: Double(11 * self.stats.stepMultiplier),
                                                                           minValue: Double(1 * self.stats.stepMultiplier),
                                                                           maxHeight: reader.size.height)
                                
                                
                                p.move(to: CGPoint(x: xPoint,
                                                   y: yStartPoint))
                                p.addLine(to: CGPoint(x: xPoint,
                                                      y: yEndPoint))
                                
                            }
                            .stroke(Color.secondary, lineWidth: 1)
                        }
                    }
                    ForEach(0..<self.stats.numberOfValuesOnChart, id: \.self) { iterator in
                        //Setup min max bars
                        //if let indexX = self.stats.datesInRange.firstIndex(of: self.stats.dataDates[iterator]) {
                        if let indexX = self.stats.datesInRange.firstIndex(where:
                                                                            { (Calendar.current.compare($0, to: self.stats.dataDates[iterator], toGranularity: .day)) == .orderedSame }) {
                        
                            Path { p in
                                let xPoint = self.estimateXLocalization(value: Double(indexX+1),
                                                                        maxValue: Double(self.stats.datesInRange.count+1),
                                                                        minValue: Double(1),
                                                                        maxWidth: reader.size.width)

                                let yStartPoint = self.estimateYLocalization(value: self.stats.dataHightestValue[iterator],
                                                                             maxValue: self.stats.maxYValue,
                                                                             minValue: self.stats.minYValue,
                                                                             maxHeight: reader.size.height)
                                let yEndPoint = self.estimateYLocalization(value: self.stats.dataLowestValue[iterator],
                                                                           maxValue: self.stats.maxYValue,
                                                                           minValue: self.stats.minYValue,
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
                                self.choosenIndex = 0
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
        
        let shiftX = maxWidth - chartWidth
        
        for index in 0..<data.count {
            let point = CGPoint(x: xPoints[index]+shiftX, y: maxHeight-yPoints[index])
            points.append(point)
        }
        return points
        
    }
    
    func estimateXLocalization(value: Double, maxValue: Double, minValue: Double, maxWidth: CGFloat) -> CGFloat {
        let chartWidth = maxWidth/1.2
        let shiftX = maxWidth - chartWidth
        let normalizeX = self.stats.normalizePoint(value: value,
                                                   maxValue: maxValue,
                                                   minValue: minValue)
        let scaleX = CGFloat(normalizeX) * chartWidth
        let xPoint = scaleX + CGFloat(shiftX)
        return xPoint
    }
    
    func estimateYLocalization(value: Double, maxValue: Double, minValue: Double, maxHeight: CGFloat) -> CGFloat {
        let normalizeY = self.stats.normalizePoint(value: value,
                                                   maxValue: maxValue,
                                                   minValue: minValue)
        let yPoint = CGFloat(normalizeY) * maxHeight
        return maxHeight - yPoint
    }
    
    func estimateYAxisDescription(line: Int) -> Double {
        return self.stats.minYValue + (Double(line) * self.stats.stepMultiplier)
    }
    
    func getClosestDataPoint(point: CGPoint, width:CGFloat, height: CGFloat) -> CGPoint {
        let points = self.convertDataToPoints(data: self.stats.dataAsDouble, maxHeight: height, maxWidth: width)
        var pointsX = [CGFloat]()
        
        for point in points {
            pointsX.append(point.x)
        }
        
        let locationValueX = point.x
        let closestValue = ArrayQuery().closestValue(array: pointsX.sorted(), target: locationValueX)
        
        let index = pointsX.firstIndex(of: closestValue)
        
        if (index! >= 0 && index! < points.count) {
            return CGPoint(x: points[index!].x, y: points[index!].y)
        }
        return .zero
    }
    
    func getDataAssociatedWithpoint(at point: CGPoint, width: CGFloat, height: CGFloat) -> Int {
        let points = self.convertDataToPoints(data: self.stats.dataAsDouble, maxHeight: height, maxWidth: width)
        var pointsX = [CGFloat]()
        for point in points {
            pointsX.append(point.x)
        }
        let indexX = pointsX.firstIndex(of: point.x) ?? 0

        return indexX
    }
}



struct LineChartView_Previews: PreviewProvider {
    
    static var prevStats = LineChartModelView(data: ExerciseStatistics(exercise: Exercise(), data: [ExerciseData]()), chartCase: .repetition)
    
    static var previews: some View {
        LineChartView(stats: prevStats, chartCase: .weight)
    }
}

