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
    var buttonColors = [Color.orange, Color.red]
    
    
    @State var listOfExercises = [
        Exercise(name: "aa exercise1"),
        Exercise(name: "ab exercise2"),
        Exercise(name: "abc exercise3"),
        Exercise(name: "abcd exercise3"),
        Exercise(name: "abcde exercise4"),
        Exercise(name: "abcdef exercise5"),
        Exercise(name: "mmmo exercise6"),
        Exercise(name: "exercise7"),
        Exercise(name: "exercise8"),
        Exercise(name: "exercise9"),
        Exercise(name: "exercise10"),
        Exercise(name: "exercise11")]
    
    func conformExercise() {
        selectedExercises += choosenExercise
    }
    
    
    var body: some View {
        NavigationView {
            VStack {
                if (addExerciseMode) {
                    AddUserExerciseView(showAddView: self.$addExerciseMode, list: self.$listOfExercises)
                }
                
                
                SearchBar(text: $searchText)
                
                List(self.listOfExercises.filter {
                    // search mechanics: If searchText is empty, then give it all list.
                    //                   If some elements of the list contains searchText show only them
                    
                    self.searchText.isEmpty ? true : $0.exerciseName.localizedStandardContains(self.searchText)
                }, id: \.self) { exercise in
                    // row display exercise name from array,
                    // and add exercise to selected array base on Exercise model property: "isChcek".
                    // "isCheck" is a Bool that changes according to the "contains" method.
                    
                    ExerciseListRow(exerciseName: exercise.exerciseName, isCheck: self.choosenExercise.contains(exercise)) {
                        if self.choosenExercise.contains(exercise) {
                            self.choosenExercise.removeAll(where: { $0 == exercise })
                        }
                        else {
                            self.choosenExercise.append(exercise)
                        }
                    }
                }
                
                
                Spacer()

                AddButton(addButtonText: "add selected exercises", action: self.conformExercise, fromColor: buttonColors[0], toColor: buttonColors[1], addingMode: $finishTyping)
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

