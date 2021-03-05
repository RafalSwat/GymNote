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
    @Binding var dateRange: ClosedRange<Date>
    @Binding var choosenStas: LineChartModelView?
    @Binding var showBasicInfo: Bool
    @Binding var showDeleteStatsWarning: Bool
    
    @State var copyChosenStatsFullRange: LineChartModelView?
    
    
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
                    HStack {
                        ZStack {
                            Rectangle()
                                .fill(LinearGradient(gradient: Gradient(colors: [.customLight, .customDark]), startPoint: .bottomLeading, endPoint: .topTrailing))
                                .cornerRadius(10)
                                .shadow(color: Color.customShadow, radius: 3)
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
                        }
                        .id(0)
                        .padding()
                        }
                        
                        ZStack {
                            Rectangle()
                                .fill(LinearGradient(gradient: Gradient(colors: [.customLight, .customDark]), startPoint: .bottomLeading, endPoint: .topTrailing))
                                .cornerRadius(10)
                                .shadow(color: Color.customShadow, radius: 3)
                        VStack {
                            Toggle(isOn: self.$showTrendLine) {
                                Text("Trend line")
                            }.toggleStyle(CheckmarkToggleStyle())
                            Divider()
                            Toggle(isOn: self.$minMaxBares) {
                                Text("Min-Max Bars")
                            }.toggleStyle(CheckmarkToggleStyle())
                            Divider()
                            Toggle(isOn: self.$showBasicInfo) {
                                Text("Basic info")
                            }.toggleStyle(CheckmarkToggleStyle())
                        }
                        .id(1)
                        .font(.footnote)
                        .frame(width: 170)
                        .padding()
                        }
                        
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
                                        Text("Apply data changes")
                                            .font(.system(size: 13, weight: .semibold, design: .default))
                                            .padding(3)
                                        Spacer()
                                    }
                                }
                                .buttonStyle(SmallRectangularButtonStyle())
                                .frame(minWidth: 150, maxWidth: .infinity)
                                .padding(.bottom, 5)
                                
                                HStack {
                                    Text("Stats from:")
                                        .font(.subheadline)
                                        .foregroundColor(Color.customShadow)
                                    DatePicker("", selection: $showStatsFromDate,
                                               in: self.dateRange,
                                               displayedComponents: .date)
                                        .shadow(color: Color.black, radius: 1)
                                }
                                HStack {
                                    Text("Stats to:    ")
                                        .font(.subheadline)
                                        .foregroundColor(Color.customShadow)
                                    DatePicker("", selection: $showStatsToDate,
                                               in: self.showStatsFromDate...self.dateRange.upperBound,
                                               displayedComponents: .date)
                                        .shadow(color: Color.black, radius: 1)
                                }
                            }
                            .padding()
                        }
                        .id(2)
                        
                        ZStack {
                            Rectangle()
                                .fill(LinearGradient(gradient: Gradient(colors: [.customLight, .customDark]), startPoint: .bottomLeading, endPoint: .topTrailing))
                                .cornerRadius(10)
                                .shadow(color: Color.customShadow, radius: 3)
                            VStack {
                                Text("Romeve all statistic for given exercise:")
                                    .font(.subheadline)
                                    .foregroundColor(Color.customShadow)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                    .padding(.top)
                                
                                Button(action: {
                                    self.showDeleteStatsWarning = true
                                }) {
                                    HStack {
                                        Spacer()
                                        Image(systemName: "xmark.bin" )
                                            .font(.caption)
                                            .padding(.horizontal,3)
                                        
                                        Text("delete statistic")
                                            .font(.system(size: 13, weight: .semibold, design: .default))
                                            .padding(3)
                                        Spacer()
                                    }
                                }
                                .buttonStyle(SmallRectangularButtonStyle(fromColor: .darkRed, toColor: .red))
                                .frame(minWidth: 150, maxWidth: .infinity)
                                .padding()
                            }
                        }
                        .id(3)
                        
                    }
                    .padding()
        }
        .onAppear {
            self.copyChosenStatsFullRange = self.choosenStas
        }
        
    }
    
    func applyNewDataRangeToStats() {
        if self.copyChosenStatsFullRange != nil {
            var exercisesData = [ExerciseData]()
            for singleData in self.self.copyChosenStatsFullRange!.data.exerciseData {
                let date = singleData.exerciseDate
                if date >= showStatsFromDate && date <= showStatsToDate {
                    exercisesData.append(singleData)
                }
            }
            if !exercisesData.isEmpty {
                let exercise = self.choosenStas!.data.exercise
                let exerciseStats = ExerciseStatistics(exercise: exercise,
                                                       data: exercisesData)
                let newStats = LineChartModelView(data: exerciseStats,
                                                  chartCase: self.displayMode,
                                                  fromDate: showStatsFromDate,
                                                  toDate: showStatsToDate)
                self.setupStats(stats: newStats)
                self.choosenStas = newStats
            }
        } 
    }
    
    func setupStats(stats: LineChartModelView) {
        stats.setupDatesRange()
        stats.normalizeData()
        stats.setupAverageValues()
        stats.setupMinAndMaxValues()
        stats.evaluateNumberOfVerticalLines()
        stats.evaluateNumberOfValuesOnChart()
        stats.setupRangeOfValues()
    }
    
}


