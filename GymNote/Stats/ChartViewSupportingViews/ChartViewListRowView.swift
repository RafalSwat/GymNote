//
//  ChartViewListRowView.swift
//  GymNote
//
//  Created by Rafał Swat on 12/12/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct ChartViewListRowView: View {
    
    @EnvironmentObject var session: FireBaseSession
    var exerciseStats : ExerciseStatistics
    
    
    @Binding var chosenStats: LineChartModelView?
    @Binding var displayMode: ChartCase
    @Binding var chosenIndex: Int?
    @Binding var startDate: Date
    @Binding var endDate: Date
    @Binding var dateRange: ClosedRange<Date>
    @Binding var chartTitle: String
    @Binding var showBasicInfo: Bool
    @Binding var chartCase: ChartCase
    
    @State var scaleValue: CGFloat = 1
    
    var body: some View {
        VStack {
            HStack {
                if exerciseStats.exercise.exerciseCreatedByUser {
                    Image(systemName: "hammer")
                }
                Text("\(exerciseStats.exercise.exerciseName)")
                Spacer()
            }
            .padding()
            .contentShape(Rectangle())
            .frame(maxWidth: .infinity)
            .background(LinearGradient(gradient: Gradient(colors: [.customDark, .customLight]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(7)
            .shadow(color: Color.customShadow, radius: 3)
            .padding(.horizontal, 3)
            .onTapGesture {
                withAnimation {
                    withAnimation {
                        self.scaleValue = 0.8
                        }

                        withAnimation {
                            self.scaleValue = 1.0
                        }
                    
                    self.chosenStats = nil
                    self.chooseIndex(stats: exerciseStats)
                    self.setupTitle()
                    self.setupSeriesForGivenStats(statistics: exerciseStats,
                                                  chartCase: self.displayMode)
                }
                
            }
            
            if self.showBasicInfo && self.chosenStats?.data.exercise.exerciseID == self.exerciseStats.exercise.exerciseID {
                ExerciseDetailsView(showExercieDetails: self.$showBasicInfo,
                                    chosenStats: self.$chosenStats,
                                    chartCase: self.$chartCase)
            }
        }
        
    }
    func chooseIndex(stats: ExerciseStatistics) {
        self.chosenIndex = self.session.userSession!.userStatistics.firstIndex(of: stats)
    }
    func setupSeriesForGivenStats(statistics: ExerciseStatistics, chartCase: ChartCase) {
        var counter = 0
        for singleExerciseData in statistics.exerciseData {
            self.session.downloadSeriesFromDB(userID: (self.session.userSession?.userProfile.userID)!,
                                              exerciseDataID: singleExerciseData.exerciseDataID, completion: { finishUpload in
                                                if finishUpload {
                                                    counter += 1
                                                    if counter == statistics.exerciseData.count {
                                                        let statsToShow = self.session.userSession!.userStatistics[self.chosenIndex!]
                                                        self.estimateDateRange(statistics: statistics)
                                                        let stats = LineChartModelView(data: statsToShow,
                                                                                       chartCase: chartCase,
                                                                                       fromDate: self.startDate,
                                                                                       toDate: self.endDate)
                                                        self.setupStats(stats: stats)
                                                        self.chosenStats = stats
                                                    }
                                                }
                                              })
        }
    }
    
    
    func setupStats(stats: LineChartModelView) {
        stats.setupDatesRange()
        stats.evaluateNumberOfVerticalLines()
        stats.setupAverageValues()
        stats.setupMinAndMaxValues()
        stats.evaluateNumberOfValuesOnChart()
        stats.setupRangeOfValues()
        stats.normalizeData()
    }
    
    func estimateDateRange(statistics: ExerciseStatistics) {
        var dates = [Date]()
        for singleData in statistics.exerciseData {
            dates.append(singleData.exerciseDate)
        }
        let min = dates.min() ?? Date()
        let max = dates.max() ?? Date()
        
        self.startDate = min
        self.endDate = max
        self.dateRange = min...max
    }
    func setupTitle() {
        if self.chosenIndex != nil {
            self.chartTitle = self.session.userSession!.userStatistics[self.chosenIndex!].exercise.exerciseName
        } else {
            self.chartTitle = ""
        }
    }
}

