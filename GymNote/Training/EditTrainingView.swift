//
//  EditTrainingView.swift
//  GymNote
//
//  Created by Rafał Swat on 20/06/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct EditTrainingView: View {
    
    @Binding var training: Training
    @State var addMode = false
    
    var body: some View {
        VStack {
            List {
                Section(header: Text("Basic info")) {
                    VStack {
                        HStack {
                            Text("Training name:")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                            TextField("Enter your name: ", text: $training.trainingName)
                                .font(.title)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        HStack {
                            Text("Subscription:")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                            TextField("Enter your name: ", text: $training.trainingSubscription)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }.padding(.vertical)
                }
                Section(header: Text("List of exercises")) {
                    ForEach(0..<training.listOfExercises.count, id: \.self) { index in
                        EditExerciseView(exercise: self.$training.listOfExercises[index])
                    }
                }
            }
            .listStyle(GroupedListStyle())
            
            AddButton(addingMode: $addMode)
                .padding(5)
                .sheet(isPresented: $addMode) {
                    ExercisesListView(finishTyping: self.$addMode, selectedExercises: self.$training.listOfExercises)
                }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle(Text("Edit Mode"), displayMode: .inline)
    }
}

struct EditTrainingView_Previews: PreviewProvider {
    
    @State static var prevTraining = Training()
    
    static var previews: some View {
        NavigationView {
            EditTrainingView(training: $prevTraining)
        }
    }
}
