//
//  TrainingHost.swift
//  GymNote
//
//  Created by Rafał Swat on 21/06/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct TrainingHost: View {
    
    @State var editMode = false
    @EnvironmentObject var session: FireBaseSession
    @Binding var training: Training
    @State var draftTraining = Training()
    
    
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
                print("cancel action!")
            }),
            trailing: EditModeButton(editMode: $editMode, editAction: {
                print("edit action!")
            }))
        
    }
}

struct TrainingHost_Previews: PreviewProvider {
    
    @State static var prevTraining = Training()
    
    static var previews: some View {
        NavigationView {
            TrainingHost(training: $prevTraining)
        }
    }
}
