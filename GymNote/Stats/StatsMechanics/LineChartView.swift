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
    @State var yForOffset = 0
    @State var dotLocation: CGPoint = .zero
    @State var horizontalLineLocation: CGPoint = .zero
    @State var showDotChart = false
    
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
                    //setup horizontal lines to grid
                    //ForEach(0..<self.stats.count) { counterY in
                    if self.showDotChart {
                        Group {
                            Path { p in
                                
                                p.move(to: CGPoint(x: 10,
                                                   y: self.dotLocation.y))
                                p.addLine(to: CGPoint(x: reader.size.width - 10,
                                                      y: self.dotLocation.y))
                            }
                            .stroke(Color.secondary, lineWidth: 1)
                        }
                    }
                    //setup vertical lines to grid
                    ForEach(0..<self.stats.count + 1) { counterX in
                        Group {
                            Path { p in
                                let xPoint = Int(reader.size.width/1.1)/self.stats.count*counterX
                                p.move(to: CGPoint(x: xPoint,
                                                   y: 0))
                                p.addLine(to: CGPoint(x: xPoint,
                                                      y: Int((reader.size.height)/2)))
                            }
                            .stroke(Color.secondary, lineWidth: 1)
                        }
                    }
                    ForEach(1..<self.stats.count) { index in
                        Text("\(self.stats[index-1].date)")
                            .offset(x: CGFloat(Int(reader.size.width/1.1)/self.stats.count*index),
                                    y: CGFloat(Int((reader.size.height)/2)))
                    }
                    
                    Path { p in
                        p.addRect(CGRect(x: 10,
                                         y: 0,
                                         width: (reader.size.width - 20),
                                         height: reader.size.height/2))
                    }
                    .stroke(Color.secondary, lineWidth: 4)
                    
                    if self.showDotChart {
                        ChartDot()
                            .offset(x: self.dotLocation.x, y: self.dotLocation.y)
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
            let xRatio = self.widthMultiplier(availablewidth: maxWidth/1.1, count: stats.count)
            let yRatio = self.heightMultiplier(availableHeight: maxHeight/2, range: 20) // <--- maxValue + 3 - (for now best idea)
            
            //let xPoint = self.relativeXFormDate(date: statistic.date, multiplier: xRatio)
            let xPoint = self.relativeX(x: Double(stats[index].date), multiplier: xRatio)
            let yPoint = self.relativeY(y: stats[index].weight, multiplier: yRatio)
            
            let point = CGPoint(x: xPoint, y: maxHeight/2 - yPoint)
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
}



struct LineChartView_Previews: PreviewProvider {
    
    static var prevStats = [TempStats]()
    
    
    static var previews: some View {
        LineChartView(stats: prevStats)
    }
}
