//
//  StatsView.swift
//  GymNote
//
//  Created by Rafał Swat on 22/07/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI
import SwiftUICharts

struct StatsView: View {
    
    var sampleData = [33.0, 24, 22, 1, 3, 88, 66, 25, 15, 17, 24]
    
    var body: some View {
        VStack {
            LineView(data: sampleData,
                     title: "Chart1",
                     legend: "Legend...")
                .padding()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2)
            List {
                ForEach(0...15, id: \.self) { idx in
                    Text("Statistic number \(idx): bla bla")
                }
            }.offset(x: 0, y: 70)
            
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}
