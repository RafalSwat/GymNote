//
//  ChartMenuView.swift
//  GymNote
//
//  Created by Rafał Swat on 08/09/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct ChartMenuView: View {
    
    var displayMode: ChartCase
    @State var showTrendLine: Bool = false
    
    var body: some View {
        VStack {
            Button(action: {
                print("weight pressed!")
            }) {
                HStack {
                    Text("Weight")
                    Spacer()
                    
                    if(displayMode == .weight) {
                        DualColorCheckmark()
                    }
                }}
            Divider()
            Button(action: {
                print("reps pressed!")
            }) {
                HStack {
                    Text("Reats")
                    Spacer()
                    
                    if(displayMode == .repetition) {
                        DualColorCheckmark()
                    }
                }
            }
            
            Divider()
            Toggle(isOn: self.$showTrendLine) {
                Text("Trend LIne")
            }
            
            
            
            Divider()
            Button(action: {
                print("time pressed!")
            }) {
                HStack {
                    Text("----picker----")
                    Spacer()
                    
                    if(displayMode == .repetition) {
                        DualColorCheckmark()
                    }
                }
            }
            
            
        }.font(.caption)
    }
}

struct ChartMenuView_Previews: PreviewProvider {
    
    static var prevDisplayMode: ChartCase = .weight
    static var prevShowTrendLine: Bool = false
    
    static var previews: some View {
        ChartMenuView(displayMode: prevDisplayMode, showTrendLine: prevShowTrendLine)
    }
}
