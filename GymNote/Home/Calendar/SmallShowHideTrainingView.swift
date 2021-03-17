//
//  SmallShowHideTrainingView.swift
//  GymNote
//
//  Created by Rafał Swat on 09/03/2021.
//  Copyright © 2021 Rafał Swat. All rights reserved.
//

import SwiftUI

struct SmallShowHideTrainingView: View {
    
    @EnvironmentObject var session: FireBaseSession
    @State private var showDetails = false
    @ObservedObject var listOfTrainingSessions: ObservableArray<Training>
    var training: Training
    var date: Date
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.showDetails.toggle()
                }, label: {
                    HStack {
                        if showDetails {
                            Image(systemName: "eye.slash")
                                .foregroundColor(.orange)
                                .font(.title)
                        } else {
                            Image(systemName: "eye")
                                .foregroundColor(.orange)
                                .font(.title)
                        }
                        
                        
                        Text(training.trainingName)
                            .multilineTextAlignment(.leading)
                            .font(.title)
                            .foregroundColor(.orange)
                            
                        Spacer()
                    }.shadow(color: .black, radius: 1, x: -1, y: 1)
                }).buttonStyle(BorderlessButtonStyle())
                ChaveronDeleteComplexButtons(deleteAction: {
                    deleteTraining()
                })
            }
            HStack {
                Text("      ")
                    .font(.largeTitle)
                Text(training.trainingDescription)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
            }
            if showDetails {
                TrainingDetails(training: training)
            }
        }
    }
    
    func deleteTraining() {
        if let id = self.session.userSession?.userProfile.userID {
            self.session.deleteDayOfTraining(userID: id, training: training, forDay: date) { (removedSuccessfully, des) in
                if removedSuccessfully {
                    //
                }
            }
            if let dateIdx = training.trainingDates.firstIndex(where: {$0 == self.date}) {
                if let trainingIdx = (self.session.userSession?.userTrainings.firstIndex(where: {$0 == training})) {
                let numbersOfTrainingSessions = self.session.userSession?.userTrainings[trainingIdx].trainingDates.count
                    if !(self.session.userSession?.userTrainings[trainingIdx].trainingDates.isEmpty)! {
                        self.session.userSession?.userTrainings[trainingIdx].trainingDates.remove(at: dateIdx)
                    }
                    
                    if numbersOfTrainingSessions!-1 ==  self.session.userSession?.userTrainings[trainingIdx].trainingDates.count {
                        self.listOfTrainingSessions.array = self.session.userSession!.userTrainings
                    } else {
                        print("dupa")
                    }
                }

            }
        }
        
        if var stats = self.session.userSession?.userStatistics {
            var exercisesIDs = [String]()
            for exercise in training.listOfExercises {
                exercisesIDs.append(exercise.exercise.exerciseID)
            }
            if exercisesIDs.count == training.listOfExercises.count {
                for id in exercisesIDs {
                    if !stats.isEmpty {
                        if let statIndex = stats.firstIndex(where: {$0.exercise.exerciseID == id}) {
                            if let dataIndex = stats[statIndex].exerciseData.firstIndex(where: {$0.exerciseDate == date}) {
                                if stats[statIndex].exerciseData.count == 1 {
                                    stats.remove(at: statIndex)
                                    self.session.userSession?.userStatistics = stats
                                } else {
                                    stats[statIndex].exerciseData.remove(at: dataIndex)
                                    self.session.userSession?.userStatistics = stats
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

