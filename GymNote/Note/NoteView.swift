//
//  NoteView.swift
//  GymNote
//
//  Created by Rafał Swat on 29/05/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
struct NoteView: View {
    
    @EnvironmentObject var session: FireBaseSession
    @State private var passageToAddTraining = false
    @StateObject var listOfTrainings: ObservableArray<Training> = ObservableArray(array: [Training]()).observeChildrenChanges()
    @State var showAlert = false
    @State var trainingToRemove: Training?
    @State var didAppear = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    ScrollView {
                        ForEach(self.listOfTrainings.array, id: \.trainingID) { training in
                            TrainingRow(listOfTrainings: self.listOfTrainings,
                                        training: training,
                                        showAlert: $showAlert,
                                        selectedTraining: $trainingToRemove)
                                .padding(.horizontal, 3)
                            
                        }
                        
                    }
                    .onAppear {
                        if !didAppear {
                            self.setupListOfTrainings()
                            self.didAppear = true
                        } else {
                            self.updateTrainingIfNeeded()
                        }
                    }
                    
                    
                    AddButton(addButtonText: "Add New Training",
                              action: {},
                              addingMode: self.$passageToAddTraining)
                        .padding()
                    
                    NavigationLink(destination: TrainingHost(editMode: true, training: Training()), isActive: self.$passageToAddTraining, label: { EmptyView() })
                }
                .navigationBarTitle("Training List", displayMode: .inline)
                .disabled(showAlert)
                
                if showAlert {
                    Color.black.opacity(0.7)
                }
                
                if showAlert {
                    if let training = self.trainingToRemove {
                        ActionAlert(showAlert: $showAlert,
                                    title: "Warning",
                                    message: "Are you sure you want to delete \(training.trainingName)?",
                                    firstButtonTitle: "Yes",
                                    secondButtonTitle: "No",
                                    action: {
                                        
                                        withAnimation(.easeInOut) {
                                            self.deleteTraining(trainingToRemove: training)
                                        }
                                        
                                        self.showAlert = false
                                    })
                    }
                }
                
                
            }
        }
    }
    func setupListOfTrainings() {
        if let list = self.session.userSession?.userTrainings {
            for training in list {
                if training.isTrainingActive {
                    self.listOfTrainings.array.append(training)
                }
            }
        }
    }
    func updateTrainingIfNeeded() {
        var activeList = [Training]()
        var counter = 0
        if let list = self.session.userSession?.userTrainings {
            for training in list {
                if training.isTrainingActive {
                    activeList.append(training)
                }
                counter += 1
                if counter == list.count {
                    if activeList.count != self.listOfTrainings.array.count {
                        self.listOfTrainings.array = activeList
                    }
                }
            }
            
        }
    }
    
    func deleteTraining(trainingToRemove: Training) {
        if let id = self.session.userSession?.userProfile.userID {
            if let trainingFromUserData = self.session.userSession?.userTrainings.first(where: {$0.trainingID == trainingToRemove.trainingID}) {
                if trainingFromUserData.trainingDates.isEmpty {
                    self.session.deleteTrainingFromDB(userID: id, training: trainingToRemove) { (error, errorDes) in
                        if !error {
                            if let indexList = self.listOfTrainings.array.firstIndex(of: trainingToRemove) {
                                self.listOfTrainings.array.remove(at: indexList)
                            }
                            if let indexSession = self.session.userSession?.userTrainings.firstIndex(of: trainingToRemove) {
                                self.session.userSession?.userTrainings.remove(at: indexSession)
                            }
                        }
                    }
                }
                else {
                    if let indexOfTrainingToRemove = self.session.userSession?.userTrainings.firstIndex(of: trainingToRemove) {
                        self.session.userSession?.userTrainings[indexOfTrainingToRemove].isTrainingActive = false
                        self.trainingToRemove?.isTrainingActive = false
                        self.deactivatetrainingAtDB(trainingToRemove: trainingToRemove)
                    }
                    if let indexList = self.listOfTrainings.array.firstIndex(of: trainingToRemove) {
                        self.listOfTrainings.array.remove(at: indexList)
                    }
                }
            }
        }
    }
    
    func deactivatetrainingAtDB(trainingToRemove: Training) {
        self.session.updateTrainingOnDBs(training: trainingToRemove)
    }
    
}

