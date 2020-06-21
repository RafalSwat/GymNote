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
    @State var selectedExercises = [Exercise]()
    
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
                                
                        }
                        HStack {
                            Text("Subscription:")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                            TextField("Enter your name: ", text: $training.trainingSubscription)
                        }
                    }.padding(.vertical)
                }
                Section(header: Text("List of exercises")) {
                    ForEach(0..<selectedExercises.count, id: \.self) { index in
                        EditExerciseView(exercise: self.$selectedExercises[index])
                    }
                }
            }.listStyle(GroupedListStyle())
            AddButton(addingMode: $addMode)
                .padding()
                .sheet(isPresented: $addMode) {
                        ExercisesListView(finishTyping: self.$addMode, selectedExercises: self.$selectedExercises)
                }
        }.onAppear {
            self.selectedExercises = self.training.listOfExercises
        }
        .navigationBarBackButtonHidden(true)
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
