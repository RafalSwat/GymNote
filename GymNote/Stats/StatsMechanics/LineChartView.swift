//
//  LineChartView.swift
//  GymNote
//
//  Created by Rafał Swat on 12/08/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct LineChartView: View {
    
    var stats: [TempStats]
    var datesRange: [Date]
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

                        let points = self.convertDataToPoints(stats: self.stats, maxHeight: reader.size.height/2, maxWidth: reader.size.width)
  
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
                        
                        Text("\(self.stats[self.choosenIndex].weight, specifier: "%.2f")")
                            .offset(x: self.dotLocation.x-8, y: self.dotLocation.y-25)
                        
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
                                                                             maxValue: Double(self.datesRange.count),
                                                                             minValue: Double(0),
                                                                             maxWidth: reader.size.width)
                                let xEndPoint = self.estimateXLocalization(value: Double(self.datesRange.count),
                                                                          maxValue: Double(self.datesRange.count),
                                                                          minValue: Double(0),
                                                                          maxWidth: reader.size.width)
                                
                                p.move(to: CGPoint(x: CGFloat(xStartPoint),
                                                   y: CGFloat(yPoint)))
                                p.addLine(to: CGPoint(x: CGFloat(xEndPoint),
                                                      y: CGFloat(yPoint)))
                            }
                            .stroke(Color.secondary, lineWidth: 1)
                        }
                    }
                    
                    //setup vertical lines to grid
                    ForEach(1..<self.datesRange.count + 1) { iterator in
                        Group {
                            Path { p in
                                let xPoint = self.estimateXLocalization(value: Double(iterator),
                                                                        maxValue: Double(self.datesRange.count + 1),
                                                                        minValue: Double(1),
                                                                        maxWidth: reader.size.width)
                                p.move(to: CGPoint(x: xPoint,
                                                   y: 0))
                                p.addLine(to: CGPoint(x: Int(xPoint),
                                                      y: Int((reader.size.height)/2)))
                                
                            }
                            .stroke(Color.secondary, lineWidth: 1)
                        }
                    }
                    //setup decription for x axis
                    ForEach(0..<self.datesRange.count) { index in
                        Text("\(DateConverter.shortDateFormat.string(from: self.datesRange[index]))")
                            .rotationEffect(.degrees(-60))
                            .offset(x: self.estimateXLocalization(value: Double(index),
                                                                  maxValue: Double(self.datesRange.count),
                                                                  minValue: Double(0),
                                                                  maxWidth: reader.size.width) - CGFloat(self.datesRange.count),
                                    y: CGFloat(Int((reader.size.height)/2))+20)
                            .foregroundColor(Color.secondary)
                            .font(.system(size: 9))
                    }
                    
                        //setup description for y axis
                        ForEach(0..<10) { index in
                            Text("\(self.estimateYAxisDescription(line: 9-index), specifier: "%.1f")")
                                .offset(x: self.estimateXLocalization(value: Double(0),
                                                                      maxValue: Double(self.stats.count),
                                                                      minValue: Double(0),
                                                                      maxWidth: reader.size.width)-10,
                                        y: self.estimateYLocalization(value: Double(index+1),
                                                                      maxValue: Double(10),
                                                                      minValue: Double(1),
                                                                      maxHeight: reader.size.height)-5)
                                .foregroundColor(Color.secondary)
                                .font(.system(size: 13))
                        }
                    
//                    Path { p in
//                        p.addRect(CGRect(x: 5,
//                                         y: 0,
//                                         width: (reader.size.width - 10),
//                                         height: reader.size.height/2 + 60))
//                    }
//                    .stroke(Color.secondary, lineWidth: 4)
                }
            }
            .gesture(DragGesture()
            .onChanged({ value in
                self.showDotChart = true
                withAnimation {
                    self.dotLocation = self.getClosestDataPoint(point: value.location,
                                                                width: geometry.size.width,
                                                                height: geometry.size.height/2)
                    self.horizontalLineLocation = self.getClosestDataPoint(point: value.location,
                                                                           width: geometry.size.width,
                                                                           height: geometry.size.height/2)
                    self.choosenIndex = self.getDataAssociatedWithpoint(at: self.dotLocation,
                                                                        width: geometry.size.width,
                                                                        height: geometry.size.height/2)
                }
            })
                .onEnded({ value in
                    self.showDotChart = false
                    withAnimation {
                        self.dotLocation = self.getClosestDataPoint(point: value.location,
                                                                    width: geometry.size.width,
                                                                    height: geometry.size.height/2)
                        self.horizontalLineLocation = self.getClosestDataPoint(point: value.location,
                                                                               width: geometry.size.width,
                                                                               height: geometry.size.height/2)
                    }
                })
            )
        }
    }
    //MARK: function that is responsible for normalization the data
    func normalizeData(data: [TempStats]) -> [DoubleData] {
        var values = [Double]()
        var dates = [Double]()
        
        for index in 0..<data.count {
            
            let dataAsDouble = Double(Calendar.current.ordinality(of: .day, in: .year, for: stats[index].date)!)
            
            values.append(data[index].weight)
            dates.append(dataAsDouble)
        }
        let maxValue = values.max()
        let minValue = values.min()
        
        //let maxDate = dates.max()
        let minDate = dates.min()
        
        let rangeValue = maxValue! - minValue!
        let rangeDates = Double(self.datesRange.count)
        
        var normalizeValues = [Double]()
        var normalizeDates = [Double]()
        
        for index in 0..<values.count {
            let normlizeValue = (values[index] - minValue!)/rangeValue
            let normalizeDate = (dates[index] - minDate!)/rangeDates
            normalizeValues.append(normlizeValue)
            normalizeDates.append(normalizeDate)
        }
        var doubleData = [DoubleData]()
        for index in 0..<values.count {
            let elementOfDoubleData = DoubleData(data: normalizeDates[index],
                                                 value: normalizeValues[index])
            doubleData.append(elementOfDoubleData)
        }
        return doubleData
    }
    func normalizePoint(value: Double, maxValue: Double, minValue: Double) -> Double {
        let range = maxValue - minValue
        let normalizeValue = (value - minValue)/range
        return normalizeValue
    }
    
    func convertDataToPoints(stats: [TempStats], maxHeight: CGFloat, maxWidth: CGFloat) -> [CGPoint] {
        let data = normalizeData(data: stats)
        var yPoints = [CGFloat]()
        var xPoints = [CGFloat]()
        var points = [CGPoint]()
        
        let chartWidth = maxWidth/1.2
        
        for index in 0..<data.count {
            let convertValueY = maxHeight * CGFloat(data[index].valueAsDouble)
            yPoints.append(convertValueY)
        }
        for index in 0..<stats.count {
            let convertValueX = chartWidth * CGFloat(data[index].dateAsDouble)
            xPoints.append(convertValueX)
        }
        for index in 0..<stats.count {
            let point = CGPoint(x: xPoints[index]+(maxWidth-chartWidth), y: maxHeight-yPoints[index])
            points.append(point)
        }
        return points
    }
    
    func estimateXLocalization(value: Double, maxValue: Double, minValue: Double, maxWidth: CGFloat) -> CGFloat {
        let chartWidth = maxWidth/1.2
        let shiftX = maxWidth - chartWidth
        let normalizeX = self.normalizePoint(value: value,
                                             maxValue: Double(self.datesRange.count + 1),
                                             minValue: Double(1))
        let scaleX = CGFloat(normalizeX) * chartWidth
        let xPoint = scaleX + CGFloat(shiftX)
        return xPoint
    }
    
    func estimateYLocalization(value: Double, maxValue: Double, minValue: Double, maxHeight: CGFloat) -> CGFloat {
        let chartHeight = maxHeight/2
        let normalizeY = self.normalizePoint(value: value,
                                             maxValue: maxValue,
                                             minValue: minValue)
        let yPoint = CGFloat(normalizeY) * chartHeight
        return yPoint
    }
    
    func estimateYAxisDescription(line: Int) -> Double {
        var values = [Double]()
        
        for index in 0..<self.stats.count {
            values.append(Double(stats[index].weight))
        }
        let maxValue = values.max()
        let minValue = values.min()
        let range = maxValue! - minValue!
        let shift = range/9
        
        let value = minValue! + (Double(line) * shift)
        
        return value
        
    }
    
    //MARK: function to evaluate closest point on chart to gesture location
    func getClosestDataPoint(point: CGPoint, width:CGFloat, height: CGFloat) -> CGPoint {
        let points = self.convertDataToPoints(stats: self.stats, maxHeight: height, maxWidth: width)
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
    
    //MARK: function return index that is used to extract real value from stats (then the value is print out on chart)
    func getDataAssociatedWithpoint(at point: CGPoint, width: CGFloat, height: CGFloat) -> Int {
        let points = self.convertDataToPoints(stats: self.stats, maxHeight: height, maxWidth: width)
        var pointsY = [CGFloat]()
        for pointY in points {
            pointsY.append(pointY.y)
        }
        
        let index = pointsY.firstIndex(of: point.y) ?? 0
        return index
    }
    
    func findMinValue(for data: [TempStats]) -> Double {
        var valueArray = [Double]()
        for value in data {
            valueArray.append(value.weight)
        }
        return valueArray.min()!
    }
    func findMaxValue(for data: [TempStats]) -> Double {
        var valueArray = [Double]()
        for value in data {
            valueArray.append(value.weight)
        }
        return valueArray.max()!
    }
    
}



struct LineChartView_Previews: PreviewProvider {
    
    static var prevStats = [TempStats]()
    static var prevDatesrange = [Date]()
    
    
    static var previews: some View {
        LineChartView(stats: prevStats, datesRange: prevDatesrange)
    }
}

class DoubleData {
    var dateAsDouble: Double
    var valueAsDouble: Double
    
    init(data: Double,
         value: Double) {
        
        self.dateAsDouble = data
        self.valueAsDouble = value
    }
}
