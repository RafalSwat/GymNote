//
//  ExercisesListView.swift
//  GymNote
//
//  Created by Rafał Swat on 01/03/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct ExercisesListView: View {
    
    @State var finishTyping = false
    @State var isCheck = false
    @State var searchText = ""
    
    let listOfExercises = [
        Exercise(name: "exercise1"),
        Exercise(name: "exercise2"),
        Exercise(name: "exercise3"),
        Exercise(name: "exercise3"),
        Exercise(name: "exercise4"),
        Exercise(name: "exercise5"),
        Exercise(name: "exercise6"),
        Exercise(name: "exercise7"),
        Exercise(name: "exercise8"),
        Exercise(name: "exercise9"),
        Exercise(name: "exercise10"),
        Exercise(name: "exercise11")]
    
    var listOfChoosenExercises: [Exercise] = []
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText)
            
            List(listOfExercises, id: \.exerciseName) { exercise in
                ExerciseListRow(exercise: exercise)
            }
            Spacer()
            AddButton(addButtonText: "add selected exercises", addingMode: $finishTyping)
                .padding()
        }.navigationBarTitle(Text("List of Exercises"))
        
    }
}

struct ExercisesListView_Previews: PreviewProvider {
    static var previews: some View {
        ExercisesListView()
    }
}
