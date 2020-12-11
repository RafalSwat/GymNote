//
//  ChartView.swift
//  GymNote
//
//  Created by Rafał Swat on 11/08/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
struct ChartView: View {
    
    @EnvironmentObject var session: FireBaseSession
    @State var stats = [ExerciseStatistics]()
    @State var chosenStats: LineChartModelView?
    @State var chosenIndex: Int?
    @State var chartTitle = "Stats"
    @State var statsLoadedSuccessfully = false
    @State var didAppear = false
    
    @State var showMenu: Bool = false
    @State var displayMode: ChartCase = .repetition
    @State var displayValue: ChartDisplayedValues = .average
    @State var showTrendLine: Bool = false
    @State var minMaxBares: Bool = true
    @State var startDate = Date()
    @State var endDate = Date()
    
    var body: some View {
        
        return GeometryReader { geometry in
            NavigationView {
                ZStack(alignment: .topTrailing) {
                    if !self.statsLoadedSuccessfully {
                        Indicator()
                    } else {
                        VStack {
                            if showMenu {
                                ChartMenuView(displayMode: self.$displayMode,
                                              displayValue: self.$displayValue,
                                              showTrendLine: self.$showTrendLine,
                                              minMaxBares: self.$minMaxBares,
                                              showStatsFromDate: self.$startDate,
                                              showStatsToDate: self.$endDate,
                                              choosenStas: self.$chosenStats)
                                    .frame(height: 130)
                                    .background(LinearGradient(gradient: Gradient(colors:[Color.orange, Color.red]),
                                                               startPoint: .bottomLeading, endPoint: .topTrailing))
                                    .shadow(color: Color.customShadow, radius: 5)
                                    .transition(
                                        AnyTransition.scale(scale: 0.01)
                                            .combined(with: AnyTransition.offset(x: geometry.size.width/2,
                                                                                 y: -geometry.size.height/2))
                                    )
                                    .padding(.bottom, 30)
                            }
                            
                            if self.chosenStats != nil {
                                LineChartView(stats: self.chosenStats!,
                                              chartCase: self.$displayMode,
                                              minMaxBares: self.$minMaxBares,
                                              displayValue: self.$displayValue,
                                              showTrendLine: self.$showTrendLine)
                                    .transition(.scale)
                                    .padding(.bottom, 20)
                            }
                            List {
                                ForEach(self.session.userSession?.userStatistics ?? [ExerciseStatistics](), id: \.exercise.exerciseID) { exerciseStats in
                                    Button(action: { withAnimation {
                                        self.chosenStats = nil
                                        self.chooseIndex(stats: exerciseStats)
                                        self.setupTitle()
                                        self.setupSeriesForGivenStats(statistics: exerciseStats,
                                                                      chartCase: self.displayMode)
                                    }
                                    }) {
                                        HStack {
                                            if exerciseStats.exercise.exerciseCreatedByUser {
                                                Image(systemName: "hammer")
                                            }
                                            Text("\(exerciseStats.exercise.exerciseName)")
                                        }
                                    }
                                }
                            }
                            .listStyle(PlainListStyle())
                        }
                    }
                }
                .padding(.top)
                .navigationBarTitle(Text(self.chartTitle), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    withAnimation(.spring()) { self.showMenu.toggle() }
                }) {
                    Image(systemName: "line.horizontal.3")
                        .font(.title)
                })
                .onAppear {
                    if !didAppear {
                        self.setupUserStatisticsIfNeeded()
                        self.didAppear = true
                    }
                }
            }
        }
    }
    func setupUserStatisticsIfNeeded() {
        if self.session.userSession?.userStatistics.count == 0 {
            self.session.downloadUserStatisticsFromDB(userID: (session.userSession?.userProfile.userID)!, completion: { finishedLoadingStats in
                self.statsLoadedSuccessfully = finishedLoadingStats
            })
        }
    }
    func chooseIndex(stats: ExerciseStatistics) {
        self.chosenIndex = self.session.userSession!.userStatistics.firstIndex(of: stats)
    }
    func setupTitle() {
        if self.chosenIndex != nil {
            self.chartTitle = self.session.userSession!.userStatistics[self.chosenIndex!].exercise.exerciseName
        } else {
            self.chartTitle = ""
        }
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
        stats.normalizeData()
        stats.setupAverageValues()
        stats.setupMinAndMaxValues()
        stats.evaluateNumberOfVerticalLines()
        stats.evaluateNumberOfValuesOnChart()
        stats.setupRangeOfValues()
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
    }
}
struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 14.0, *) {
            ChartView()
        } else {
            // Fallback on earlier versions
        }
    }
}


