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
    @State var showMenu: Bool = false
    @State var show = false
    
    var body: some View {
        
        return GeometryReader { geometry in
            NavigationView {
                ZStack(alignment: .topTrailing) {
                    
                    if !show {
                        Indicator()
                        Button("DUPA", action: {
                            //print("\(self.session.userSession!.userStatistics[0].exercise.exerciseName)")
                            self.show.toggle()
                        })
                        
                    } else {
                    
                    VStack {
                        
                        if self.chosenStats != nil {
                            LineChartView(stats: self.chosenStats!, chartCase: .repetition)
                                .transition(.scale)
                                .padding(.bottom, 20)
                        }
                        List {
                            ForEach(self.session.userSession!.userStatistics, id: \.exercise.exerciseID) { exerciseStats in
                                Button(action: { withAnimation {
                                    var counter = 0
                                    self.chosenStats = nil
                                    self.chosenIndex = self.session.userSession!.userStatistics.firstIndex(of: exerciseStats)
                                    self.chartTitle = self.session.userSession!.userStatistics[self.chosenIndex!].exercise.exerciseName
                                    for singleExerciseData in exerciseStats.exerciseData {
                                        self.session.downloadSeriesFromDB(userID: (self.session.userSession?.userProfile.userID)!,
                                                                          exerciseDataID: singleExerciseData.exerciseDataID, completion: { finishUpload in
                                                                            if finishUpload {
                                                                                counter += 1
                                                                                if counter == exerciseStats.exerciseData.count {
                                                                                    let stats = LineChartModelView(data:  self.session.userSession!.userStatistics[self.chosenIndex!],
                                                                                                                          chartCase: .repetition)
                                                                                    
                                                                                    self.setupStats(stats: stats)
                                                                                    self.chosenStats = stats
                                                                                }
                                                                            }
                                                                          })
                                    }
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
                    if showMenu {
                        ChartMenuView(displayMode: .repetition)
                            .frame(width: 200, height: 300)
                            .background(LinearGradient(gradient: Gradient(colors:[Color.customLight, Color.customDark]), startPoint: .bottomLeading, endPoint: .topTrailing))
                            .cornerRadius(10)
                            .shadow(color: Color.customShadow, radius: 5)
                            .transition(
                                AnyTransition.scale(scale: 0.01)
                                    .combined(with: AnyTransition.offset(x: geometry.size.width/2,
                                                                         y: -geometry.size.height/2))
                            )
                        
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
                    if self.session.userSession?.userStatistics.count == 0 {
                        self.session.downloadUserStatisticsFromDB(userID: (session.userSession?.userProfile.userID)!)
                    }
                }
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
struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 14.0, *) {
            ChartView()
        } else {
            // Fallback on earlier versions
        }
    }
}


