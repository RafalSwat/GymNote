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
    
    @State var showWarning = true
    @State var warningMessage = ""

    var body: some View {
        VStack {
            if editMode {
                EditTrainingView(training: $draftTraining)
                    .onAppear {
                        self.draftTraining = self.training
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
            trailing: EditModeButton(editMode: $editMode, editAction: {
                self.training = self.draftTraining
                self.session.addTrainingToFBR(userTrainings: self.session.userSession!.userTrainings, training: self.training)
            }))
            .onDisappear {
                self.session.uploadTrainings(userID: self.session.userSession!.userProfile.userID) {  uploadedTrainings in
                    self.session.userSession?.userTrainings.listOfTrainings = uploadedTrainings
            }
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
