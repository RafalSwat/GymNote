//
//  ExercisesListView.swift
//  GymNote
//
//  Created by Rafał Swat on 01/03/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct ExercisesListView: View {
    
    @Binding var finishTyping: Bool
    @Binding var selectedComponents: [TrainingsComponent] // Exercise conform as selected
    @State var choosenComponents = [TrainingsComponent]() // Exercise selected but not conform
    @State var addExerciseMode = false
    @State var searchText = ""
    @State var showCreatedByUserOnly = false
    
    @State var listOfComponents = [
        TrainingsComponent(exercise: Exercise(id: "5AA41935-1D78-42FD-9A8A-F80CDF76AB7C", name: "Squats", createdByUser: false),
                           numberOfSeries: 1, orderInList: 1, isCheck: false),
        TrainingsComponent(exercise: Exercise(id: "CE1A2ED7-E760-4523-B280-F75426DD7F4A", name: "Deadlifts", createdByUser: false),
                           numberOfSeries: 1, orderInList: 1, isCheck: false),
        TrainingsComponent(exercise: Exercise(id: "01B57CEA-7A36-441A-9094-A66349C3ABC6", name: "Jump rope", createdByUser: false),
                           numberOfSeries: 1, orderInList: 1, isCheck: false),
        TrainingsComponent(exercise: Exercise(id: "61C6036D-2E94-4CD1-AEB9-6AF140EC30EA", name: "Dumbbell jump squat", createdByUser: false),
                           numberOfSeries: 1, orderInList: 1, isCheck: false),
        TrainingsComponent(exercise: Exercise(id: "AC181865-0D1B-4366-ACDF-5B5353E2997E", name: "Bench press", createdByUser: false),
                           numberOfSeries: 1, orderInList: 1, isCheck: false),
        TrainingsComponent(exercise: Exercise(id: "F45A4713-46B0-4C39-AE36-7996FDEBD1ED", name: "Dips", createdByUser: false),
                           numberOfSeries: 1, orderInList: 1, isCheck: false),
        TrainingsComponent(exercise: Exercise(id: "35C52F7D-2FA9-48E7-B14B-75398008C370", name: "Chin-ups", createdByUser: false),
                           numberOfSeries: 1, orderInList: 1, isCheck: false),
        TrainingsComponent(exercise: Exercise(id: "424FD6CB-A94C-4DD4-AC4F-3AD58A2FAF46", name: "Pull-ups", createdByUser: false),
                           numberOfSeries: 1, orderInList: 1, isCheck: false),
        TrainingsComponent(exercise: Exercise(id: "59140E5A-740B-4FAD-892D-5E816290DC79", name: "Overhead press", createdByUser: false),
                           numberOfSeries: 1, orderInList: 1, isCheck: false),
        TrainingsComponent(exercise: Exercise(id: "C3FB49BE-E369-4D8E-9F51-A14B9A6EF9E0", name: "Reverse grip", createdByUser: false),
                           numberOfSeries: 1, orderInList: 1, isCheck: false),
        TrainingsComponent(exercise: Exercise(id: "1B828797-2EA9-4023-A06F-A7FC5F0AEBE8", name: "Close grip bench press", createdByUser: false),
                           numberOfSeries: 1, orderInList: 1, isCheck: false),
        TrainingsComponent(exercise: Exercise(id: "0E146666-A55E-4C83-854A-609A5CBE2462", name: "Close grip pull-up", createdByUser: false),
                           numberOfSeries: 1, orderInList: 1, isCheck: false),
        TrainingsComponent(exercise: Exercise(id: "E74597A5-AA8C-4505-BB5F-3047394FB089", name: "Dumbbell curl", createdByUser: false),
                           numberOfSeries: 1, orderInList: 1, isCheck: false),
        TrainingsComponent(exercise: Exercise(id: "8494FBCA-3773-474F-BB6D-77256BEF4CAF", name: "Wrist Curls", createdByUser: false),
                           numberOfSeries: 1, orderInList: 1, isCheck: false),
        TrainingsComponent(exercise: Exercise(id: "CE2F9401-A50B-4D89-884E-45E5A8195B26", name: "Sit-ups", createdByUser: false),
                           numberOfSeries: 1, orderInList: 1, isCheck: false)
    ]
    
    
    
    
    func conformExercise() {
        selectedComponents += choosenComponents
        for index in self.selectedComponents.indices { 
            selectedComponents[index].exerciseOrderInList = index
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if (addExerciseMode) {
                    AddUserExerciseView(showAddView: self.$addExerciseMode, list: self.$listOfComponents)
                }
                HStack {
                    SearchBar(text: $searchText)
                }
                
                List {

                    ForEach(self.listOfComponents.filter {
                        // search mechanics: If searchText is empty, then give it all list.
                        //                   If some elements of the list contains searchText show only them
                        
                                self.searchText.isEmpty ? true : $0.exercise.exerciseName.localizedStandardContains(self.searchText)}, id: \.self) { trainingComponent in
                            // row display exercise name from array,
                            // and add exercise to selected array base on Exercise model property: "isChcek".
                            // "isCheck" is a Bool that changes according to the "contains" method.
                            
                        ExerciseListRow(exerciseName: trainingComponent.exercise.exerciseName,
                                        isCheck: self.choosenComponents.contains(trainingComponent),
                                        createdbyUser: trainingComponent.exercise.exerciseCreatedByUser) {
                                if self.choosenComponents.contains(trainingComponent) {
                                    self.choosenComponents.removeAll(where: { $0 == trainingComponent })
                                }
                                else {
                                    self.choosenComponents.append(trainingComponent)
                                }
                            }.padding(.horizontal, 2)
                    }
                }
                Spacer()
                
                AddButton(addButtonImage: Image(systemName: "checkmark.square"),
                          addButtonText: "add selected exercises",
                          action: self.conformExercise,
                          fromColor: Color.orange,
                          toColor: Color.red,
                          addingMode: $finishTyping)
                    .padding()
            }
            .navigationBarTitle(Text("List of Exercises"), displayMode: .inline)
            .navigationBarItems(
                leading: ExitButton(donePresenting: $finishTyping),
                trailing: AddBarItem(showAddView: $addExerciseMode)
            )
        }
    }
}


