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
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    List {
                        ForEach(self.listOfTrainings.array, id: \.trainingID) { training in
                            TrainingRow(listOfTrainings: self.listOfTrainings,
                                        training: training,
                                        showAlert: $showAlert,
                                        selectedTraining: $trainingToRemove)
                            
                        }
                        
                    }
                    .listStyle(GroupedListStyle())
                    .onAppear {
                        if let list = self.session.userSession?.userTrainings {
                            self.listOfTrainings.array = list
                        }
                    }
                    AddButton(addButtonText: "Add New Training",
                              action: {},
                              addingMode: self.$passageToAddTraining)
                        .padding()
                    
                    NavigationLink(destination: TrainingHost(editMode: true, training: Training()), isActive: self.$passageToAddTraining, label: { EmptyView() })
                }
                .navigationBarTitle("Training List")
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

func deleteTraining(trainingToRemove: Training) {
    if let indexOfTrainingToRemove = self.session.userSession?.userTrainings.firstIndex(of: trainingToRemove) {
        self.removeTrainingFromDB(at: indexOfTrainingToRemove, trainingToRemove: trainingToRemove)
        self.session.userSession?.userTrainings.remove(at: indexOfTrainingToRemove)
        self.listOfTrainings.array.remove(at: indexOfTrainingToRemove)
    }
}

func removeTrainingFromDB(at index: Int, trainingToRemove: Training) {
    if let userID = self.session.userSession?.userProfile.userID {
        self.session.deleteTrainingFromDB(userID: userID, training: trainingToRemove) { errorOccur, errorDescription in
            if errorOccur {
                print(errorDescription ?? "Unknow error occur during removing training!")
            }
            
        }
    }
}

}



struct NoteView_Previews: PreviewProvider {
    
    static var prevListOfTrainings = [Training(id: UUID().uuidString,
                                               name: "My Training",
                                               description: "My litte subscription",
                                               date: "01-Jan-2020",
                                               exercises: [TrainingsComponent(exercise: Exercise(), numberOfSeries: 1, orderInList: 1)])]
    
    static var previews: some View {
        NavigationView {
            if #available(iOS 14.0, *) {
                NoteView()
            } else {
                // Fallback on earlier versions
            }
        }
    }
}
