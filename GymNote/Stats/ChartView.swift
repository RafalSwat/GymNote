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
    //@State var dataRange: ClosedRange<Date> = Date()...Date()
    @State var showBasicInfo = false
    
    @State var showExerciseDetails = false
    
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
                                              //dataRange: self.$dataRange,
                                              choosenStas: self.$chosenStats,
                                              showBasicInfo: self.$showBasicInfo)
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
                            ScrollView {
                                ForEach(self.session.userSession?.userStatistics ?? [ExerciseStatistics](), id: \.exercise.exerciseID) { exerciseStats in
                                    ChartViewListRowView(exerciseStats: exerciseStats,
                                                         chosenStats: self.$chosenStats,
                                                         displayMode: self.$displayMode,
                                                         chosenIndex: self.$chosenIndex,
                                                         startDate: self.$startDate,
                                                         endDate: self.$endDate,
                                                         //dataRange: self.$dataRange,
                                                         chartTitle: self.$chartTitle,
                                                         showBasicInfo: self.$showBasicInfo)
                                }.padding(.top, 5)
                            }
                            
                            
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


//Button(action: { withAnimation {
//    self.chosenStats = nil
//    self.chooseIndex(stats: exerciseStats)
//    self.setupTitle()
//    self.setupSeriesForGivenStats(statistics: exerciseStats,
//                                  chartCase: self.displayMode)
//}
//}) {
//    VStack {
//    HStack {
//        if exerciseStats.exercise.exerciseCreatedByUser {
//            Image(systemName: "hammer")
//        }
//        Text("\(exerciseStats.exercise.exerciseName)")
//        Spacer()
//    }
//        if chosenStats != nil {
//            ExerciseDetailsView(showExercieDetails: self.$showExerciseDetails)
//        }
//    }
//}
