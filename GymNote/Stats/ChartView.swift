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
                            LineChartView(stats: self.chosenStats!, chartCase: .weight)
                                .transition(.scale)
                                .padding(.bottom, 20)
                        }
                        List {
                            ForEach(self.session.userSession!.userStatistics, id: \.exercise.exerciseID) { exerciseStats in
                                Button(action: { withAnimation {
                                    var counter = 0
                                    self.chosenIndex = self.session.userSession!.userStatistics.firstIndex(of: exerciseStats)
                                    self.chartTitle = self.session.userSession!.userStatistics[self.chosenIndex!].exercise.exerciseName
                                    for singleExerciseData in exerciseStats.exerciseData {
                                        self.session.downloadSeriesFromDB(userID: (self.session.userSession?.userProfile.userID)!,
                                                                          exerciseDataID: singleExerciseData.exerciseDataID, completion: { finishUpload in
                                                                            if finishUpload {
                                                                                counter += 1
                                                                                if counter == exerciseStats.exerciseData.count {
                                                                                    self.chosenStats = LineChartModelView(data: self.session.userSession!.userStatistics[self.chosenIndex!])
                                                                                    self.setupDataToChart()
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
                        ChartMenuView(displayMode: .weight)
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
        
        let listOfExercises = [TrainingsComponent(exercise: Exercise(id: "5AA41935-1D78-42FD-9A8A-F80CDF76AB7C", name: "Squats", createdByUser: false),
                                                  numberOfSeries: 1, orderInList: 1, isCheck: false),
                               TrainingsComponent(exercise: Exercise(id: "CE1A2ED7-E760-4523-B280-F75426DD7F4A", name: "Deadlifts", createdByUser: false),
                                                  numberOfSeries: 1, orderInList: 1, isCheck: false),
                               TrainingsComponent(exercise: Exercise(id: "01B57CEA-7A36-441A-9094-A66349C3ABC6", name: "Jump rope", createdByUser: false),
                                                  numberOfSeries: 1, orderInList: 1, isCheck: false),
                               TrainingsComponent(exercise: Exercise(id: "61C6036D-2E94-4CD1-AEB9-6AF140EC30EA", name: "Dumbbell jump squat", createdByUser: false),
                                                  numberOfSeries: 1, orderInList: 1, isCheck: false),
                               TrainingsComponent(exercise: Exercise(id: "AC181865-0D1B-4366-ACDF-5B5353E2997E", name: "Bench press", createdByUser: false),
                                                  numberOfSeries: 1, orderInList: 1, isCheck: false),
                               TrainingsComponent(exercise: Exercise(id: "F45A4713-46B0-4C39-AE36-7996FDEBD1ED", name: "Dips", createdByUser: false),
                                                  numberOfSeries: 1, orderInList: 1, isCheck: false),
                               TrainingsComponent(exercise: Exercise(id: "35C52F7D-2FA9-48E7-B14B-75398008C370", name: "Chin-ups", createdByUser: false),
                                                  numberOfSeries: 1, orderInList: 1, isCheck: false),
                               TrainingsComponent(exercise: Exercise(id: "424FD6CB-A94C-4DD4-AC4F-3AD58A2FAF46", name: "Pull-ups", createdByUser: false),
                                                  numberOfSeries: 1, orderInList: 1, isCheck: false),
                               TrainingsComponent(exercise: Exercise(id: "59140E5A-740B-4FAD-892D-5E816290DC79", name: "Overhead press", createdByUser: false),
                                                  numberOfSeries: 1, orderInList: 1, isCheck: false),
                               TrainingsComponent(exercise: Exercise(id: "C3FB49BE-E369-4D8E-9F51-A14B9A6EF9E0", name: "Reverse grip", createdByUser: false),
                                                  numberOfSeries: 1, orderInList: 1, isCheck: false),
                               TrainingsComponent(exercise: Exercise(id: "1B828797-2EA9-4023-A06F-A7FC5F0AEBE8", name: "Close grip bench press", createdByUser: false),
                                                  numberOfSeries: 1, orderInList: 1, isCheck: false),
                               TrainingsComponent(exercise: Exercise(id: "0E146666-A55E-4C83-854A-609A5CBE2462", name: "Close grip pull-up", createdByUser: false),
                                                  numberOfSeries: 1, orderInList: 1, isCheck: false),
                               TrainingsComponent(exercise: Exercise(id: "E74597A5-AA8C-4505-BB5F-3047394FB089", name: "Dumbbell curl", createdByUser: false),
                                                  numberOfSeries: 1, orderInList: 1, isCheck: false),
                               TrainingsComponent(exercise: Exercise(id: "8494FBCA-3773-474F-BB6D-77256BEF4CAF", name: "Wrist Curls", createdByUser: false),
                                                  numberOfSeries: 1, orderInList: 1, isCheck: false),
                               TrainingsComponent(exercise: Exercise(id: "CE2F9401-A50B-4D89-884E-45E5A8195B26", name: "Sit-ups", createdByUser: false),
                                                  numberOfSeries: 1, orderInList: 1, isCheck: false)]
        
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
                let singleData = ExerciseData(dataID: UUID().uuidString,
                                              date: dummyDates[i],
                                              series: series)
                exerciseData.append(singleData)
            }
            let singleStatistic = ExerciseStatistics(exercise: Exercise(id: listOfExercises[index].exercise.exerciseID,
                                                                        name: listOfExercises[index].exercise.exerciseName,
                                                                        createdByUser: listOfExercises[index].exercise.exerciseCreatedByUser),
                                                     data: exerciseData)
            exerciseStatistic.append(singleStatistic)
        }
        self.stats = exerciseStatistic
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


