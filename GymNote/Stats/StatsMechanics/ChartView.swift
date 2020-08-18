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
    @State var stats2 = [TempStats]()
    @State var datesRange = [Date]()
    
    var body: some View {
        VStack {
            if !self.stats2.isEmpty {
                LineChartView(stats: stats2, datesRange: datesRange)
            }
            
        }
        .onAppear {
            self.setupStats()
            
        }
    }
    
    func setupStats() {
        
//        for i in 0..<10 {
//            let statistic = TempStats(date: i + 1, weight: Double.random(in: 0..<20))
//            self.stats.append(statistic)
//        }
        let dateControver = DateConverter()
        
        self.stats2 = [TempStats(date: dateControver.convertFromString(dateString: "10 Aug 2020"), weight: 11),
                        TempStats(date: dateControver.convertFromString(dateString: "11 Aug 2020"), weight: 15),
//                        TempStats(date: dateControver.convertFromString(dateString: "12 Aug 2020"), weight: 12),
//                        TempStats(date: dateControver.convertFromString(dateString: "13 Aug 2020"), weight: 11),
//                        TempStats(date: dateControver.convertFromString(dateString: "14 Aug 2020"), weight: 9),
//                        TempStats(date: dateControver.convertFromString(dateString: "15 Aug 2020"), weight: 16),
//                        TempStats(date: dateControver.convertFromString(dateString: "16 Aug 2020"), weight: 13),
//                        TempStats(date: dateControver.convertFromString(dateString: "17 Aug 2020"), weight: 6),
//                        TempStats(date: dateControver.convertFromString(dateString: "18 Aug 2020"), weight: 7),
//                        TempStats(date: dateControver.convertFromString(dateString: "19 Aug 2020"), weight: 16),
//                        TempStats(date: dateControver.convertFromString(dateString: "20 Aug 2020"), weight: 16),
//                        TempStats(date: dateControver.convertFromString(dateString: "21 Aug 2020"), weight: 14),
//                        TempStats(date: dateControver.convertFromString(dateString: "22 Aug 2020"), weight: 12),
//                        TempStats(date: dateControver.convertFromString(dateString: "23 Aug 2020"), weight: 10),
                        TempStats(date: dateControver.convertFromString(dateString: "24 Aug 2020"), weight: 8),
                        TempStats(date: dateControver.convertFromString(dateString: "25 Aug 2020"), weight: 12)]
        
        self.extractDatesRange(data: stats2)
    }
    func extractDatesRange(data: [TempStats]) {
        var tempDates = [Date]()
        for index in 0..<data.count {
            let date = data[index].date
            tempDates.append(date)
        }
        let maxDate = tempDates.max()
        let minDate = tempDates.min()
        
        self.datesRange = DateConverter().fillUpArrayWithDates(startDate: minDate!, endDate: maxDate!)
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
    var date: Date
    var weight: Double
    
    init(date: Date,
         weight: Double) {
        
        self.id = UUID().uuidString
        self.date = date
        self.weight = weight
    }
    
    init(id: String,
         date: Date,
         weight: Double) {
        
        self.id = id
        self.date = date
        self.weight = weight
    }
}

