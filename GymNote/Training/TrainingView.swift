//
//  TrainingView.swift
//  GymNote
//
//  Created by Rafał Swat on 20/06/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
struct TrainingView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var session: FireBaseSession
    @StateObject var trainingStats: ObservableArray<ExerciseStatistics> = ObservableArray(array: [ExerciseStatistics]())
    @State var setOfArraysOfReps = [[String]]()
    @State var setOfArraysOfWeights = [[String]]()
    var training: Training
    let dataString = DateConverter.dateFormat.string(from: Date())
    
    @State var conform = false
    
    @Binding var showWarning: Bool
    @Binding var alertTitle: String
    @Binding var alertMessage: String
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                List {
                    ZStack {
                        Rectangle()
                            .fill(LinearGradient(gradient: Gradient(colors: [.customDark, .customLight]), startPoint: .bottomLeading, endPoint: .topTrailing))
                            .cornerRadius(10)
                            .shadow(color: Color.customShadow, radius: 5)
                        HStack {
                        VStack(alignment: .leading) {
                            Text(training.trainingName)
                                .font(.largeTitle)
                                .padding(.horizontal)
                                .padding(.bottom)
                                .shadow(radius: 4)
                            
                            Text(training.trainingDescription)
                                .padding(.horizontal)
                            Text("Created at: \(training.initialDate)")
                                .padding(.horizontal)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }.padding()
                }
                    if !self.setOfArraysOfReps.isEmpty {
                        ForEach(0..<training.listOfExercises.count, id: \.self) { exerciseIndex in
                            ExerciseView(trainingComponent: training.listOfExercises[exerciseIndex],
                                         conform: self.$conform,
                                         arrayOfReps: self.$setOfArraysOfReps[exerciseIndex],
                                         arrayOfWeights: self.$setOfArraysOfWeights[exerciseIndex])
                                .padding()
                                .background(LinearGradient(gradient: Gradient(colors: [.customLight, .customSuperLight]), startPoint: .leading, endPoint: .trailing))
                                .cornerRadius(10)
                                .shadow(color: Color.customShadow, radius: 3)
                        }
                    }
                    
                    
                    Button(action: {
                        self.conform = true
                    }) {
                        HStack {
                            Image(systemName: "checkmark.circle")
                                .font(.largeTitle)
                            Spacer()
                            Text("Confirm finished training")
                            Spacer()
                        }.padding()
                    }
                    .buttonStyle(RectangularButtonStyle())
                    .padding(.vertical)
                    
                    
                }
                .listStyle(PlainListStyle())
                .navigationBarTitle(conform ? Text("") : Text(training.trainingName), displayMode: .inline)
                .navigationBarHidden(conform)
                .animation(.default)
                .gesture(DragGesture().onChanged{ _ in
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                })
                .onAppear {
                    self.initializationOfSetOfArrays()
                }
            }
            .disabled(conform)
            if conform || showWarning {
                Color.black.opacity(0.7)
            }
            
            if self.conform {
                ActionAlert(showAlert: $conform,
                            title: (alertTitle == "Warning" ? "Confirmation" : alertTitle),
                            message: (alertMessage == "" ? "Do you want to finish typing your training and save data to statistics?" : alertMessage),
                            firstButtonTitle: "Yes",
                            secondButtonTitle: "Cancel",
                            action: {
                                self.saveTrainingToStatistics()
                                self.presentationMode.wrappedValue.dismiss()
                            })
                    .shadow(color: Color.customShadow, radius: 5)
            }
            
        }
        
    }
    func initializationOfSetOfArrays() {
        for index in 0..<training.listOfExercises.count {
            
            var tempRepsSeries = [String]()
            var tempWeightsSeries = [String]()
            
            for _ in 0..<training.listOfExercises[index].exerciseNumberOfSeries {
                tempRepsSeries.append("")
                tempWeightsSeries.append("")
            }
            self.setOfArraysOfReps.append(tempRepsSeries)
            self.setOfArraysOfWeights.append(tempWeightsSeries)
        }
    }
    func saveTrainingToStatistics() {
        
        self.saveAsStatistics()
        if !self.trainingStats.array.isEmpty {
            for index in 0..<self.trainingStats.array.count {
                self.saveStatisticToDataBase(statsToSave: self.trainingStats.array[index])
                self.addStatisticToUserData(statsToAdd: self.trainingStats.array[index])
            }
        } else {
            self.showWarning = true
            self.alertTitle = "Error"
            self.alertMessage = "Unknow error..."
        }
    }
    
    func saveAsStatistics() {
        var tempArrayOfStats = [ExerciseStatistics]()
        
        for exerciseIndex in 0..<training.listOfExercises.count {
            
            var tempSeries = [Series]()
            
            for seriesIndex in 0..<training.listOfExercises[exerciseIndex].exerciseNumberOfSeries {
                tempSeries.append(Series(id: UUID().uuidString,
                                         order: Int(seriesIndex),
                                         repeats: Int(setOfArraysOfReps[exerciseIndex][seriesIndex]) ?? 1,
                                         weight: Int(setOfArraysOfWeights[exerciseIndex][seriesIndex]) ?? 1))
            }
            let currentDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) ?? Date()
            
            let tempExerciseData = ExerciseData(dataID: UUID().uuidString,
                                                date: currentDate,
                                                series: tempSeries)
            let temExerciseStats = ExerciseStatistics(exercise: Exercise(id: training.listOfExercises[exerciseIndex].exercise.exerciseID,
                                                                         name: training.listOfExercises[exerciseIndex].exercise.exerciseName,
                                                                         createdByUser: training.listOfExercises[exerciseIndex].exercise.exerciseCreatedByUser),
                                                      data: [tempExerciseData])
            tempArrayOfStats.append(temExerciseStats)
        }
        self.trainingStats.array = tempArrayOfStats
    }
    func saveStatisticToDataBase(statsToSave: ExerciseStatistics) {
        self.session.uploadUserStatisticsToDB(userID: (self.session.userSession?.userProfile.userID)!,
                                              statistics: statsToSave,
                                              completion: { errorOccur, error in
                                                self.showWarning = errorOccur
                                                if let errorDescription =  error {
                                                    self.alertTitle = "DataBase Error"
                                                    self.alertMessage = errorDescription
                                                }
                                              })
    }
    func addStatisticToUserData(statsToAdd: ExerciseStatistics) {
        if self.session.userSession?.userStatistics.count != 0 {
            if let index = self.session.userSession?.userStatistics.firstIndex(where: { $0.exercise.exerciseID == statsToAdd.exercise.exerciseID }) {
                self.session.userSession?.userStatistics[index].exerciseData.append(contentsOf: statsToAdd.exerciseData)
            }
        }
    }
}

struct TrainingView_Previews: PreviewProvider {
    
    static var prevTraining = Training()
    @State static var prevShow = false
    @State static var prevString = "Test Message"
    
    static var previews: some View {
        NavigationView {
            if #available(iOS 14.0, *) {
                TrainingView(training: prevTraining,
                             showWarning: $prevShow,
                             alertTitle: $prevString,
                             alertMessage: $prevString)
            } else {
                // Fallback on earlier versions
            }
        }
    }
}
