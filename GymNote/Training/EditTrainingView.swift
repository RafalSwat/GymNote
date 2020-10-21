//
//  EditTrainingView.swift
//  GymNote
//
//  Created by Rafał Swat on 20/06/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct EditTrainingView: View {
    
    @ObservedObject var training: Training
    @State var addMode = false
    @State var editMode = EditMode.inactive
    
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
                            TextField("Enter name... ", text: $training.trainingName)
                                .font(.title)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(maxWidth: UIScreen.main.bounds.width/1.75)
                        }
                        HStack {
                            Text("Description:")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                            TextField("Enter your description... ", text: $training.trainingDescription)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(maxWidth: UIScreen.main.bounds.width/1.75)
                        }
                        
                    }.padding(.vertical)
                }
                Section(header: HStack{
                    Text("List of exercises")
                        .padding(.bottom, 5)
                    Spacer()
                    Button(action: {
                        if self.editMode == .inactive {
                            self.editMode = .active
                        } else {
                            self.editMode = .inactive
                        }
                    }, label: {
                        if self.editMode == .inactive {
                            Image(systemName: "list.number")
                                .font(.system(size: 20))
                                .padding(.bottom, 5)
                                .padding(.trailing, 8)
                            
                        } else {
                            Image(systemName: "checkmark.square")
                                .font(.system(size: 20))
                                .padding(.bottom, 5)
                                .padding(.trailing, 8)
                        }
                        
                    })
                }) {

                    ForEach(training.listOfExercises, id: \.exerciseID) { exercise in
                        EditExerciseView(exercise: exercise,
                                         editMode: $editMode)
                            .onLongPressGesture{
                                if self.editMode == .inactive {
                                    self.editMode = .active
                                } else {
                                    self.editMode = .inactive
                                }
                            }
                        
                    }
                    .onMove { (source: IndexSet, destination: Int) -> Void in
                        self.training.listOfExercises.move(fromOffsets: source, toOffset: destination)
                        
                        for index in 0..<training.listOfExercises.count {
                            self.training.listOfExercises[index].exerciseOrderInList = index
                        }
                        
                    }
                    
                }
            }
            .listStyle(GroupedListStyle())
            
            AddButton(addingMode: $addMode)
                .padding()
                .sheet(isPresented: $addMode) {
                    ExercisesListView(finishTyping: self.$addMode, selectedExercises: self.$training.listOfExercises)
                }
                
        }
        .environment(\.editMode, $editMode)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle(Text("Edit Mode"), displayMode: .inline)
    }
    
    func relocate(from source: IndexSet, to destination: Int) {
        training.listOfExercises.move(fromOffsets: source, toOffset: destination)
    }
}

struct EditTrainingView_Previews: PreviewProvider {
    
    @State static var prevTraining = Training()
    
    static var previews: some View {
        NavigationView {
            EditTrainingView(training: prevTraining)
        }
    }
}
