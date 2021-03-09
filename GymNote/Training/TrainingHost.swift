//
//  TrainingHost.swift
//  GymNote
//
//  Created by Rafał Swat on 21/06/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
struct TrainingHost: View {
    
    @EnvironmentObject var session: FireBaseSession
    @Environment(\.presentationMode) var presentationMode
    @State var editMode = false
    @ObservedObject var training: Training
    @StateObject var draftTraining = Training()
    
    @State var showWarning = false
    @State var warningTitle = "Warning"
    @State var warningMessage = ""
    
    var body: some View {
        VStack {
            if editMode {
                ZStack {
                    ZStack {
                        
                        EditTrainingView(training: draftTraining)
                            .onAppear {
                                self.assignTrainingToDraftTraining()
                            }
                            .disabled(showWarning)
                            .navigationBarHidden(showWarning)
                        if showWarning {
                            Color.black.opacity(0.7)
                        }
                    }
                    if showWarning {
                        WarningAlert(showAlert: $showWarning,
                                     title: warningTitle,
                                     message: warningMessage,
                                     buttonTitle: "Ok")
                        
                    }
                }
            } else {
                TrainingView(training: training,
                             showWarning: $showWarning,
                             alertTitle: $warningTitle,
                             alertMessage: $warningMessage)
                    
            }
        }
        .navigationBarItems(
            leading: CancelEditModeButton(editMode: $editMode, cancelAction: {
                self.assignTrainingToDraftTraining()
                self.presentationMode.wrappedValue.dismiss()
            }),
            trailing:
                Button(action: {
                    if self.editMode == true {
                        self.saveTrainingInTheDB()
                    } else {
                        self.editMode = true
                    }
                }) {
                    Text(self.editMode == true ? "Done" : "Edit")
                }
        )
    }
    //MARK: Functions
    func assignTrainingToDraftTraining() {
        self.draftTraining.trainingID = self.training.trainingID
        self.draftTraining.trainingName = self.training.trainingName
        self.draftTraining.trainingDescription = self.training.trainingDescription
        self.draftTraining.initialDate = self.training.initialDate
        self.draftTraining.listOfExercises = self.training.listOfExercises
    }
    func assignDraftTrainingToTraining() {
        self.training.trainingID = self.draftTraining.trainingID
        self.training.trainingName = self.draftTraining.trainingName
        self.training.trainingDescription = self.draftTraining.trainingDescription
        self.training.initialDate = self.draftTraining.initialDate
        self.training.listOfExercises = self.draftTraining.listOfExercises
    }
    
    func saveTrainingInTheDB() {
        if draftTraining.listOfExercises.isEmpty {
            self.warningMessage = "You can't confirm training without any exercises! Please, add some exercises to your program."
            withAnimation(.easeInOut) {
                self.showWarning = true
            }
        } else if draftTraining.trainingName == "" {
            draftTraining.trainingName = DateConverter.dateFormat.string(from: Date())
            if let id = self.session.userSession?.userProfile.userID {
                self.assignDraftTrainingToTraining()
                self.session.uploadTrainingToDB(userID: id, training: training, completion: { errorOccur, error in
                    // if error during saving occur then edit mode must be true (user stays in EditMode util tapped cancel)
                    self.editMode = errorOccur
                    withAnimation(.easeInOut) {
                        self.showWarning = errorOccur
                    }
                    if let errorDescription =  error {
                        self.warningMessage = errorDescription
                    }
                })
                checkIfTrainingIsAlreadySavedThenSaved(training: training)
            }
        } else {
            if let id = self.session.userSession?.userProfile.userID {
                self.assignDraftTrainingToTraining()
                self.session.uploadTrainingToDB(userID: id, training: training, completion: { errorOccur, error in
                    // if error during saving occur then edit mode must be true (user stays in EditMode util tapped cancel)
                    self.editMode = errorOccur
                    withAnimation(.easeInOut) {
                        self.showWarning = errorOccur
                    }
                    if let errorDescription =  error {
                        self.warningMessage = errorDescription
                    }
                })
                checkIfTrainingIsAlreadySavedThenSaved(training: training)
            }
        }
    }
    func checkIfTrainingIsAlreadySavedThenSaved(training: Training) {
        if (self.session.userSession?.userTrainings.contains(where: { $0.trainingID == training.trainingID}))! {
            if let index = self.session.userSession?.userTrainings.firstIndex(where: { $0.trainingID == training.trainingID}) {
                self.session.userSession?.userTrainings[index] = training
            } else {
                self.session.userSession?.userTrainings.append(training)
            }
        } else {
            self.session.userSession?.userTrainings.append(training)
        }
    }
    
}

struct TrainingHost_Previews: PreviewProvider {
    
    @State static var prevTraining = Training()
    
    static var previews: some View {
        NavigationView {
            if #available(iOS 14.0, *) {
                TrainingHost(training: prevTraining)
            } else {
                // Fallback on earlier versions
            }
        }
    }
}
