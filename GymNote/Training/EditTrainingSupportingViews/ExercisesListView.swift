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
    @Binding var selectedExercises: [Exercise] // Exercise conform as selected
    @State var choosenExercise = [Exercise]() // Exercise selected but not conform
    @State var addExerciseMode = false
    @State var searchText = ""
    @State var showCreatedByUserOnly = false
    
    @State var listOfExercises = [
        Exercise(id: "5AA41935-1D78-42FD-9A8A-F80CDF76AB7C", name: "Squats", numberOfSeries: 1),
        Exercise(id: "CE1A2ED7-E760-4523-B280-F75426DD7F4A", name: "Deadlifts", numberOfSeries: 1),
        Exercise(id: "01B57CEA-7A36-441A-9094-A66349C3ABC6", name: "Jump rope",numberOfSeries: 1),
        Exercise(id: "61C6036D-2E94-4CD1-AEB9-6AF140EC30EA", name: "Dumbbell jump squat", numberOfSeries: 1),
        Exercise(id: "AC181865-0D1B-4366-ACDF-5B5353E2997E", name: "Bench press", numberOfSeries: 1),
        Exercise(id: "F45A4713-46B0-4C39-AE36-7996FDEBD1ED", name: "Dips", numberOfSeries: 1),
        Exercise(id: "35C52F7D-2FA9-48E7-B14B-75398008C370", name: "Chin-ups", numberOfSeries: 1),
        Exercise(id: "424FD6CB-A94C-4DD4-AC4F-3AD58A2FAF46", name: "Pull-ups", numberOfSeries: 1),
        Exercise(id: "59140E5A-740B-4FAD-892D-5E816290DC79", name: "Overhead press", numberOfSeries: 1),
        Exercise(id: "C3FB49BE-E369-4D8E-9F51-A14B9A6EF9E0", name: "Reverse grip", numberOfSeries: 1),
        Exercise(id: "1B828797-2EA9-4023-A06F-A7FC5F0AEBE8", name: "Close grip bench press",numberOfSeries: 1),
        Exercise(id: "0E146666-A55E-4C83-854A-609A5CBE2462", name: "Close grip pull-up", numberOfSeries: 1),
        Exercise(id: "E74597A5-AA8C-4505-BB5F-3047394FB089", name: "Dumbbell curl", numberOfSeries: 1),
        Exercise(id: "8494FBCA-3773-474F-BB6D-77256BEF4CAF", name: "Wrist Curls", numberOfSeries: 1),
        Exercise(id: "CE2F9401-A50B-4D89-884E-45E5A8195B26", name: "Sit-ups", numberOfSeries: 1)
    ]
    
    
    
    
    func conformExercise() {
        selectedExercises += choosenExercise
        for index in self.selectedExercises.indices { 
            selectedExercises[index].exerciseOrderInList = index
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if (addExerciseMode) {
                    AddUserExerciseView(showAddView: self.$addExerciseMode, list: self.$listOfExercises)
                }
                HStack {
                    SearchBar(text: $searchText)
                }
                
                List {

                    ForEach(self.listOfExercises.filter {
                        // search mechanics: If searchText is empty, then give it all list.
                        //                   If some elements of the list contains searchText show only them
                        
                        self.searchText.isEmpty ? true : $0.exerciseName.localizedStandardContains(self.searchText)}, id: \.exerciseID) { exercise in
                            // row display exercise name from array,
                            // and add exercise to selected array base on Exercise model property: "isChcek".
                            // "isCheck" is a Bool that changes according to the "contains" method.
                            
                            ExerciseListRow(exerciseName: exercise.exerciseName,
                                            isCheck: self.choosenExercise.contains(exercise),
                                            createdbyUser: exercise.exerciseCreatedByUser) {
                                if self.choosenExercise.contains(exercise) {
                                    self.choosenExercise.removeAll(where: { $0 == exercise })
                                }
                                else {
                                    self.choosenExercise.append(exercise)
                                }
                            }
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

struct ExercisesListView_Previews: PreviewProvider {
    
    @State static var prevFinishTyping = true
    @State static var prevSelectedExercise = [Exercise(name: "aa exercise1"),
                                              Exercise(name: "ab exercise2")]
    
    static var previews: some View {
        ExercisesListView(finishTyping: $prevFinishTyping,
                          selectedExercises: $prevSelectedExercise)
                           
    }
}

