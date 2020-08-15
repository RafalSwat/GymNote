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
                        
                        let points = self.convertStatsToPoints(stats: self.stats, maxWidth: reader.size.width, maxHeight: reader.size.height)
                        
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
                            .offset(x: self.dotLocation.x, y: self.dotLocation.y)
                        
                        Text("\(self.stats[self.choosenIndex].weight, specifier: "%.2f")")
                            .offset(x: self.dotLocation.x-5, y: self.dotLocation.y-20)
                        
                    }
                    //setup horizontal lines
                    ForEach(0..<10) { counterY in
                        Group {
                            Path { p in
                                let yPoint = Int(reader.size.height/2)/10*(counterY+1)
                                
                                p.move(to: CGPoint(x: CGFloat(34),
                                                   y: CGFloat(yPoint)))
                                p.addLine(to: CGPoint(x: CGFloat(reader.size.width - 20),
                                                      y: CGFloat(yPoint)))
                            }
                            .stroke(Color.secondary, lineWidth: 1)
                        }
                    }
                    ForEach(0..<10) { counterY in
                        Text("\(self.evaluteValueForYAxis(for: self.stats) * Double(10-counterY), specifier: "%.1f")")
                            .offset(x: CGFloat(9), y: CGFloat(Int(reader.size.height/20)*(counterY+1))-8)
                            .foregroundColor(Color.secondary)
                            .font(.caption)
                    }
                    //setup vertical lines to grid
                    ForEach(1..<self.stats.count + 1) { counterX in
                        Group {
                            Path { p in
                                let xPoint = Int(reader.size.width-30)/self.stats.count*counterX
                                p.move(to: CGPoint(x: xPoint+10,
                                                   y: 0))
                                p.addLine(to: CGPoint(x: xPoint+10,
                                                      y: Int((reader.size.height)/2)))
                            }
                            .stroke(Color.secondary, lineWidth: 1)
                        }
                    }
                    //setup decription for x axis
                    ForEach(1..<self.stats.count) { index in
                        Text("\(self.stats[index-1].date)")
                            .offset(x: CGFloat(Int(reader.size.width-30)/self.stats.count*index)+5,
                                    y: CGFloat(Int((reader.size.height)/2)))
                            .foregroundColor(Color.secondary)
                            .font(.caption)
                    }
                    Text("\(self.stats.last!.date)")
                        .offset(x: CGFloat(Int(reader.size.width-30)/self.stats.count*10)+5,
                                y: CGFloat(Int((reader.size.height)/2)))
                        .foregroundColor(Color.secondary)
                        .font(.caption)
                    
                    Path { p in
                        p.addRect(CGRect(x: 5,
                                         y: 0,
                                         width: (reader.size.width - 10),
                                         height: reader.size.height/2 + 20))
                    }
                    .stroke(Color.secondary, lineWidth: 4)
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
    
    //MARK: function responsible for representing stats data as points on na graph
    func convertStatsToPoints(stats: [TempStats], maxWidth: CGFloat, maxHeight: CGFloat) -> [CGPoint] {
        var points = [CGPoint]()
        for index in 0..<stats.count {
            let xRatio = self.widthMultiplier(availablewidth: maxWidth-30, count: stats.count)
            let yRatio = self.heightMultiplier(availableHeight: maxHeight/2, range: 20) // <--- maxValue + 3 - (for now best idea)
            
            //let xPoint = self.relativeXFormDate(date: statistic.date, multiplier: xRatio)
            let xPoint = self.relativeX(x: Double(stats[index].date), multiplier: xRatio)
            let yPoint = self.relativeY(y: stats[index].weight, multiplier: yRatio)
            
            let point = CGPoint(x: xPoint+10, y: maxHeight/2 - yPoint)
            points.append(point)
        }
        return points
    }
    
    //MARK: support functions for convert function
    func heightMultiplier(availableHeight: CGFloat, range: Int) -> CGFloat {
        availableHeight / CGFloat(range)
    }
    
    func widthMultiplier(availablewidth: CGFloat, count: Int) -> CGFloat {
        availablewidth / CGFloat(count)
    }
    
    func relativeY(y : Double, multiplier: CGFloat) -> CGFloat {
        CGFloat(y) * multiplier
    }
    func relativeX(x : Double, multiplier: CGFloat) -> CGFloat {
        CGFloat(x) * multiplier
    }
    
    func relativeXFormDate(date: Date, multiplier: CGFloat) -> CGFloat {
        CGFloat(Calendar.current.ordinality(of: .day, in: .year, for: date)!) * multiplier
    }
    
    //MARK: function to evaluate closest point on chart to gesture location
    func getClosestDataPoint(point: CGPoint, width:CGFloat, height: CGFloat) -> CGPoint {
        let points = self.convertStatsToPoints(stats: self.stats, maxWidth: width, maxHeight: height)
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
        let points = self.convertStatsToPoints(stats: self.stats, maxWidth: width, maxHeight: height)
        var pointsY = [CGFloat]()
        for pointY in points {
            pointsY.append(pointY.y)
        }
        
        let index = pointsY.firstIndex(of: point.y) ?? 0
        return index
    }
    
    //MARK: function evaluate shift for each horizontal line description for given data
    func evaluteValueForYAxis(for data: [TempStats]) -> Double {
        var valueArray = [Double]()
        for value in data {
            valueArray.append(value.weight)
        }
        
        let maxY = valueArray.max()
        let minY = valueArray.min()
        
        let range = (maxY! - minY!)
        
        let shift = range/10
        return shift
    }
}



struct LineChartView_Previews: PreviewProvider {
    
    static var prevStats = [TempStats]()
    
    
    static var previews: some View {
        LineChartView(stats: prevStats)
    }
}
