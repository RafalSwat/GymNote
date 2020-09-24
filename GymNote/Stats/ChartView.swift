//
//  ChartView.swift
//  GymNote
//
//  Created by Rafał Swat on 11/08/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct ChartView: View {
    @State var stats = [ExerciseStatistics]()
    @State var chosenStats: LineChartModelView?
    @State var chosenIndex: Int?
    @State var chartTitle = "Stats"
    @State var showMenu: Bool = false
    
    var body: some View {
        
            let drag = DragGesture()
                .onEnded {
                    if $0.translation.width < -100 {
                        withAnimation {
                            self.showMenu = false
                        }
                    }
            }
            
            return GeometryReader { geometry in
                NavigationView {
                ZStack(alignment: .leading) {
                    VStack {
                        if self.chosenStats != nil {
                            LineChartView(stats: self.chosenStats!, chartCase: .weight)
                                .transition(.scale)
                                .padding(.bottom, 20)
                        }
                        List {
                            ForEach(self.stats, id: \.exerciseID) { exercise in
                                Button(action: { withAnimation {
                                    self.chosenStats = LineChartModelView(data: exercise)
                                    self.setupDataToChart()
                                    self.chosenIndex = self.stats.firstIndex(of: exercise)
                                    self.chartTitle = self.stats[self.chosenIndex!].exerciseName}
                                }) {
                                    HStack {
                                        if exercise.exerciseCreatedByUser {
                                            Image(systemName: "hammer")
                                        }
                                        Text("\(exercise.exerciseName)")
                                    }
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                        .onAppear {
                            self.setupStats()
                        }
                    }
                    .offset(x: self.showMenu ? geometry.size.width/2 : 0)
                    .transition(.move(edge: .leading))
                    if self.showMenu {
                        ChartMenuView(displayMode: .weight)
                            .frame(width: geometry.size.width/2)
                            .transition(.move(edge: .leading))
                    }
                }
                .padding(.top)
                .navigationBarTitle(Text(self.chartTitle), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    withAnimation { self.showMenu.toggle() }
                }) {
                    Image(systemName: "line.horizontal.3")
                        .font(.title)
                    
                })
                .gesture(drag)
            }
        }
    }
    func setupDataToChart() {
        self.chosenStats!.setupDatesRange()
        self.chosenStats!.normalizeData()
        self.chosenStats!.getAverage(chartCase: .weight)
        self.chosenStats!.getAverage(chartCase: .weight)
        self.chosenStats!.getMinAndMax(chartCase: .weight)
    }
    func setupStats() {
        let dateControver = DateConverter()
        let dummyDates = [dateControver.convertFromString(dateString: "10 Aug 2020"),
                          dateControver.convertFromString(dateString: "11 Aug 2020"),
                          dateControver.convertFromString(dateString: "12 Aug 2020"),
                          dateControver.convertFromString(dateString: "13 Aug 2020"),
                          dateControver.convertFromString(dateString: "14 Aug 2020"),
                          dateControver.convertFromString(dateString: "15 Aug 2020"),
                          dateControver.convertFromString(dateString: "16 Aug 2020"),
                          dateControver.convertFromString(dateString: "17 Aug 2020"),
                          dateControver.convertFromString(dateString: "18 Aug 2020"),
                          dateControver.convertFromString(dateString: "19 Aug 2020"),
                          dateControver.convertFromString(dateString: "20 Aug 2020"),
                          dateControver.convertFromString(dateString: "21 Aug 2020"),
                          dateControver.convertFromString(dateString: "22 Aug 2020")]
        
        let listOfExercises = [Exercise(id: "5AA41935-1D78-42FD-9A8A-F80CDF76AB7C", name: "Squats", numberOfSeries: 1),
                               Exercise(id: "CE1A2ED7-E760-4523-B280-F75426DD7F4A", name: "Deadlifts", numberOfSeries: 1),
                               Exercise(id: "01B57CEA-7A36-441A-9094-A66349C3ABC6", name: "Jump rope",numberOfSeries: 1),
                               Exercise(id: "61C6036D-2E94-4CD1-AEB9-6AF140EC30EA", name: "Dumbbell jump squat", numberOfSeries: 1),
                               Exercise(id: "AC181865-0D1B-4366-ACDF-5B5353E2997E", name: "Bench press", numberOfSeries: 1),
                               Exercise(id: "F45A4713-46B0-4C39-AE36-7996FDEBD1ED", name: "Dips", numberOfSeries: 1),
                               Exercise(id: "35C52F7D-2FA9-48E7-B14B-75398008C370", name: "Chin-ups", numberOfSeries: 1),
                               Exercise(id: "424FD6CB-A94C-4DD4-AC4F-3AD58A2FAF46", name: "Pull-ups", numberOfSeries: 1),
                               Exercise(id: "59140E5A-740B-4FAD-892D-5E816290DC79", name: "Overhead press", numberOfSeries: 1),
                               Exercise(id: "C3FB49BE-E369-4D8E-9F51-A14B9A6EF9E0", name: "Reverse grip", numberOfSeries: 1),
                               Exercise(id: "1B828797-2EA9-4023-A06F-A7FC5F0AEBE8", name: "Close grip bench press",numberOfSeries: 1),
                               Exercise(id: "0E146666-A55E-4C83-854A-609A5CBE2462", name: "Close grip pull-up", numberOfSeries: 1),
                               Exercise(id: "E74597A5-AA8C-4505-BB5F-3047394FB089", name: "Dumbbell curl", numberOfSeries: 1),
                               Exercise(id: "8494FBCA-3773-474F-BB6D-77256BEF4CAF", name: "Wrist Curls", numberOfSeries: 1),
                               Exercise(id: "CE2F9401-A50B-4D89-884E-45E5A8195B26", name: "Sit-ups", numberOfSeries: 1)]
        
        var exerciseStatistic = [ExerciseStatistics]()
        
        for index in 0..<5 {
            var exerciseData = [ExerciseData]()
            
            for i in 0..<5 {
                var series = [Series]()
                
                for j in 0..<3 {
                    let singleSeries = Series(repeats: 8+j,
                                              weight: Int.random(in: 0..<20))
                    series.append(singleSeries)
                }
                let singleData = ExerciseData(numberOfSeries: 3,
                                              date: dummyDates[i],
                                              series: series)
                exerciseData.append(singleData)
            }
            let singleStatistic = ExerciseStatistics(id: listOfExercises[index].exerciseID,
                                                     name: listOfExercises[index].exerciseName,
                                                     data: exerciseData)
            exerciseStatistic.append(singleStatistic)
        }
        self.stats = exerciseStatistic
    }
    
    
}
struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
    }
}


