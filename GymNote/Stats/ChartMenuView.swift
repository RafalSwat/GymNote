//
//  ChartMenuView.swift
//  GymNote
//
//  Created by Rafał Swat on 08/09/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct ChartMenuView: View {
    
    @Binding var displayMode: ChartCase
    @Binding var displayValue: ChartDisplayedValues
    @Binding var showTrendLine: Bool
    @Binding var minMaxBares: Bool
    @Binding var showStatsFromDate: Date
    @Binding var showStatsToDate: Date
    @Binding var choosenStas: LineChartModelView?
    
    var body: some View {
        VStack {
            Picker(selection: $displayMode, label: Text("Chart case")) {
                Text("repeats").tag(ChartCase.repetition)
                Text("weights").tag(ChartCase.weight)
            }
            .pickerStyle(SegmentedPickerStyle())
            .background(LinearGradient(gradient: Gradient(colors: [.orange, .red]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(7)
            .shadow(color: Color.black, radius: 3)
            .padding(.bottom, 20)
            
            Picker(selection: $displayValue, label: Text("Displayed value")) {
                Text("average").tag(ChartDisplayedValues.average)
                Text("greatest").tag(ChartDisplayedValues.greatest)
            }
            .pickerStyle(SegmentedPickerStyle())
            .background(LinearGradient(gradient: Gradient(colors: [.orange, .red]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(7)
            .shadow(color: Color.black, radius: 3)
            .padding(.bottom, 20)
            
            Divider()
            
            Toggle(isOn: self.$showTrendLine) {
                Text("Trend line")
                    .font(.subheadline)
                    .padding(.leading, 5)
            }.toggleStyle(CheckmarkToggleStyle())
            
            Toggle(isOn: self.$minMaxBares) {
                Text("Min-Max Bars")
                    .font(.subheadline)
                    .padding(.leading, 5)
            }.toggleStyle(CheckmarkToggleStyle())
            
            
            Divider()
            ZStack {
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [.customLight, .customDark]), startPoint: .bottomLeading, endPoint: .topTrailing))
                    .cornerRadius(10)
                    .shadow(color: Color.customShadow, radius: 3)
                VStack {
                    Button(action: {
                        self.applyNewDataRangeToStats()
                    }) {
                        HStack {
                            Spacer()
                            Text("Apply data chages")
                                .font(.system(size: 13, weight: .semibold, design: .default))
                                .padding(3)
                            Spacer()
                        }
                    }
                    .buttonStyle(SmallRectangularButtonStyle())
                    .frame(minWidth: 100, maxWidth: .infinity)
                    
                    HStack {
                        Text("Stats from:")
                            .font(.subheadline)
                            .foregroundColor(Color.customShadow)
                        DatePicker("", selection: $showStatsFromDate, in: showStatsFromDate...showStatsToDate, displayedComponents: .date)
                            .shadow(color: Color.black, radius: 1)
                    }
                    HStack {
                        Text("Stats to:")
                            .font(.subheadline)
                            .foregroundColor(Color.customShadow)
                        DatePicker("", selection: $showStatsToDate, in: showStatsFromDate...showStatsToDate, displayedComponents: .date)
                            .shadow(color: Color.black, radius: 1)
                    }
                }
                .padding()
            }
            Divider()
        }
        .padding()

    }
    
    func applyNewDataRangeToStats() {
        if self.choosenStas != nil {
            var exercisesData = [ExerciseData]()
            for singleData in self.choosenStas!.data.exerciseData {
                let date = singleData.exerciseDate
                if date >= showStatsFromDate && date <= showStatsToDate {
                    exercisesData.append(singleData)
                }
            }
            let exercise = self.choosenStas!.data.exercise
            let exerciseStats = ExerciseStatistics(exercise: exercise,
                                                   data: exercisesData)
            let newStats = LineChartModelView(data: exerciseStats,
                                              chartCase: self.displayMode,
                                              fromDate: showStatsFromDate,
                                              toDate: showStatsToDate)
            self.choosenStas = newStats
        }
    }
    
    
}


