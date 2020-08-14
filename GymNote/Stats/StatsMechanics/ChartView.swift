//
//  ChartView.swift
//  GymNote
//
//  Created by Rafał Swat on 11/08/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct ChartView: View {
    
    @State var stats = [TempStats]()
    @State var points = [CGPoint]()
    
    var body: some View {
        VStack {
            if !self.points.isEmpty {
                LineChartView(stats: stats)
            }
        }
        .onAppear {
            self.setupStats()
            self.setupPoints()
        }
    }
    
    func setupStats() {
        
        for i in 0..<10 {
            let statistic = TempStats(date: i + 1, weight: Double.random(in: 0..<20))
            self.stats.append(statistic)
        }
    }
    
    func setupPoints() {
        for index in 0..<self.stats.count{
            let point = setupPoint(statistic: self.stats[index])
            self.points.append(point)
        }
    }
    
    func setupPoint(statistic: TempStats) -> CGPoint {
        let xRatio = self.widthMultiplier(availablewidth: UIScreen.main.bounds.width/1.1, count: self.stats.count)
        let yRatio = self.heightMultiplier(availableHeight: UIScreen.main.bounds.height/2, range: 20) // <--- maxValue + 3 - (for now best idea)
        
        //let xPoint = self.relativeXFormDate(date: statistic.date, multiplier: xRatio)
        let xPoint = self.relativeX(x: Double(statistic.date), multiplier: xRatio)
        let yPoint = self.relativeY(y: statistic.weight, multiplier: yRatio)
        
        let point = CGPoint(x: xPoint, y: UIScreen.main.bounds.height/2 - yPoint)
        
        return point
    }
    
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
struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
    }
}


class TempStats {
    var id: String
    //var date: Date
    var date: Int
    var weight: Double
    
    init(date: Int,
         weight: Double) {
        
        self.id = UUID().uuidString
        self.date = date
        self.weight = weight
    }
    
    init(id: String,
         date: Int,
         weight: Double) {
        
        self.id = id
        self.date = date
        self.weight = weight
    }
}

