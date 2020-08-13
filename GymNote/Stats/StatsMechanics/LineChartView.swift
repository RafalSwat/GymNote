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
    //var points: [CGPoint]
    var lineGradient = Gradient(colors: [Color.yellow,
                                         Color.orange,
                                         Color.red])
    @State var yForOffset = CGFloat(((Int(UIScreen.main.bounds.height)/2)/20) * 0)
    
    var body: some View {
        ZStack {
            GeometryReader { reader in

                Path { p in
                    let points = self.convertStatsToPoints(stats: stats, maxWidth: reader.size.width, maxHeight: reader.size.height)
                    p.move(to: self.points[0])
                    for index in 1..<self.points.count {
                        p.addLine(to: self.points[index])
                    }
                }
                .stroke(LinearGradient(gradient: self.lineGradient,
                                       startPoint: UnitPoint(x: 0.0, y: 1.0),
                                       endPoint: UnitPoint(x: 0.0, y: 0.0)),
                        lineWidth: 3)
                ForEach(0..<21) { counterY in
                    Group {
                        Path { p in
                            let yPoint = CGFloat(((Int(reader.size.height)/2)/20) * counterY)
                            p.move(to: CGPoint(x: 10,
                                               y: yPoint))
                            p.addLine(to: CGPoint(x: reader.size.width - 10,
                                                  y: yPoint))
                        }
                        .stroke(Color.secondary, lineWidth: 1)
                    }
                }
                ForEach(1..<self.points.count + 1) { counterX in
                    Group {
                        Path { p in
                            let xPoint = (Int(reader.size.width/1.1)/self.points.count*counterX)
                            p.move(to: CGPoint(x: xPoint,
                                               y: 0))
                            p.addLine(to: CGPoint(x: xPoint,
                                                  y: Int((reader.size.height)/2)))
                        }
                        .stroke(Color.secondary, lineWidth: 1)
                    }
                }
                Path { p in
                    p.addRect(CGRect(x: 10,
                                     y: 0,
                                     width: (reader.size.width - 20),
                                     height: reader.size.height/2))
                }
                .stroke(Color.secondary, lineWidth: 4)
            }
        }
    }
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
    
    
    
    
    //MARK: support functions
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
}



struct LineChartView_Previews: PreviewProvider {
    
    static var prevData = [CGPoint(x: 50, y: 250),
                           CGPoint(x: 80, y: 260),
                           CGPoint(x: 110, y: 250),
                           CGPoint(x: 140, y: 300),
                           CGPoint(x: 170, y: 210),
                           CGPoint(x: 200, y: 180),
                           CGPoint(x: 230, y: 230),
                           CGPoint(x: 260, y: 350)]
    
    
    static var previews: some View {
        LineChartView(points: prevData)
    }
}
