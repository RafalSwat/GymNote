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
    
    var body: some View {
        VStack {
            if !self.stats.isEmpty {
                LineChartView(stats: stats)
            }
        }
        .onAppear {
            self.setupStats()
        }
    }
    
    func setupStats() {
        
        for i in 0..<10 {
            let statistic = TempStats(date: i + 1, weight: Double.random(in: 0..<20))
            self.stats.append(statistic)
        }
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

