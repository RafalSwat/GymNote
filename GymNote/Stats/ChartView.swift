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
    @StateObject var listOfExerciseStatistic: ObservableArray<ExerciseStatistics> = ObservableArray(array: [ExerciseStatistics]()).observeChildrenChanges()
    
    @State var stats = [ExerciseStatistics]()
    @State var chosenStats: LineChartModelView?
    @State var chosenIndex: Int?
    @State var chartTitle = "Stats"
    @State var statsLoadedSuccessfully: Bool? = nil
    @State var didAppear = false
    
    @State var showMenu: Bool = false
    @State var displayMode: ChartCase = .repetition
    @State var displayValue: ChartDisplayedValues = .average
    @State var showTrendLine: Bool = false
    @State var minMaxBares: Bool = true
    @State var startDate = Date()
    @State var endDate = Date()
    @State var dateRange: ClosedRange<Date> = Date()...Date()
    @State var showBasicInfo = false
    
    @State var showExerciseDetails = false
    
    var body: some View {
        
        return GeometryReader { geometry in
            NavigationView {
                ZStack(alignment: .topTrailing) {
                    if self.statsLoadedSuccessfully == nil {
                        Indicator()
                    } else if self.statsLoadedSuccessfully == false {
                        Text("There are no statistics to display yet. Do the training and record your performance first. Good luck!")
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                            
                    } else {
                        VStack {
                            if showMenu && self.chosenStats != nil {
                                ChartMenuView(displayMode: self.$displayMode,
                                              displayValue: self.$displayValue,
                                              showTrendLine: self.$showTrendLine,
                                              minMaxBares: self.$minMaxBares,
                                              showStatsFromDate: self.$startDate,
                                              showStatsToDate: self.$endDate,
                                              dateRange: self.$dateRange,
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
                                    .padding(.trailing, 20)
                            }
                            ScrollView {
                                ForEach(listOfExerciseStatistic.array, id: \.exercise.exerciseID) { exerciseStats in
                                    ChartViewListRowView(exerciseStats: exerciseStats,
                                                         chosenStats: self.$chosenStats,
                                                         displayMode: self.$displayMode,
                                                         chosenIndex: self.$chosenIndex,
                                                         startDate: self.$startDate,
                                                         endDate: self.$endDate,
                                                         dateRange: self.$dateRange,
                                                         chartTitle: self.$chartTitle,
                                                         showBasicInfo: self.$showBasicInfo,
                                                         chartCase: self.$displayMode)
                                }
                                .padding(.top, 5)
                                .padding(.horizontal, 3)
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
                    self.didAppear = false
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
                if finishedLoadingStats && self.session.userSession?.userStatistics.count == 0 {
                    self.statsLoadedSuccessfully = false
                } else if finishedLoadingStats && self.session.userSession?.userStatistics.count != 0 {
                    self.listOfExerciseStatistic.array = self.session.userSession!.userStatistics
                    self.statsLoadedSuccessfully = true
                }
            })
        } else {
            self.listOfExerciseStatistic.array = self.session.userSession?.userStatistics ?? [ExerciseStatistics]()
            self.statsLoadedSuccessfully = true
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


