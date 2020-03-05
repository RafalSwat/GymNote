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
    @State var isCheck = false
    @State var searchText = ""
    
    let listOfExercises = [
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
    
    var listOfChoosenExercises: [Exercise] = []
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                
                List(self.listOfExercises.filter {
                    self.searchText.isEmpty ? true : $0.exerciseName.localizedStandardContains(self.searchText)
                }, id: \.self) { exercise in
                    ExerciseListRow(exercise: exercise)
                }
                Spacer()
                AddButton(addButtonText: "add selected exercises", addingMode: $finishTyping)
                    .padding()
            }
            .navigationBarTitle(Text("List of Exercises"), displayMode: .inline)
            .navigationBarItems(
                leading: ExitButton(donePresenting: $finishTyping)
            )
        }
        
        
    }
}

struct ExercisesListView_Previews: PreviewProvider {
    
    @State static var prevAddMode = true
    
    static var previews: some View {
        ExercisesListView(finishTyping: $prevAddMode)
    }
}
