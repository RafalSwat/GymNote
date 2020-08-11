//
//  TrainingHost.swift
//  GymNote
//
//  Created by Rafał Swat on 21/06/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct TrainingHost: View {
    
    @EnvironmentObject var session: FireBaseSession
    @Environment(\.presentationMode) var presentationMode
    @State var editMode = false
    @State var training: Training
    @State var draftTraining = Training()
    
    @State var showWarning = false
    @State var warningMessage = ""

    var body: some View {
        VStack {
            if editMode {
                ZStack {
                    EditTrainingView(training: $draftTraining)
                        .onAppear {
                            self.draftTraining = self.training
                    }
                    if showWarning {
                        WarningAlert(showAlert: $showWarning,
                                     title: "Warning",
                                     message: warningMessage,
                                     buttonTitle: "Ok",
                                     action: {})
                            
                    }
                }
            } else {
                TrainingView(training: training)
            }
        }
        .navigationBarItems(
            leading: CancelEditModeButton(editMode: $editMode, cancelAction: {
                self.draftTraining = self.training
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
    func saveTrainingInTheDB() {
        if draftTraining.listOfExercises.isEmpty {
            self.warningMessage = "You can`t confirm training without any exercises! Please, add some exercises to your program."
            self.showWarning = true
        } else if draftTraining.trainingName == "" {
            draftTraining.trainingName = DateConverter.dateFormat.string(from: Date())
            if let id = self.session.userSession?.userProfile.userID {
                self.training = self.draftTraining
                self.session.uploadTrainingToDB(userID: id, training: training, completion: { errorOccur, error in
                    // if error during saving occur then edit mode must be true (user stays in EditMode util tapped cancel)
                    self.editMode = errorOccur
                    self.showWarning = errorOccur
                    if let errorDescription =  error {
                        self.warningMessage = errorDescription
                    }
                })
                checkIfTrainingIsAlreadySavedThenSaved(training: training)
            }
        } else {
            if let id = self.session.userSession?.userProfile.userID {
                self.training = self.draftTraining
                self.session.uploadTrainingToDB(userID: id, training: training, completion: { errorOccur, error in
                    // if error during saving occur then edit mode must be true (user stays in EditMode util tapped cancel)
                    self.editMode = errorOccur
                    self.showWarning = errorOccur
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
            TrainingHost(training: prevTraining)
        }
    }
}
