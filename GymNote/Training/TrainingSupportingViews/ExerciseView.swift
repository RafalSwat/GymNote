//
//  ExerciseView.swift
//  GymNote
//
//  Created by Rafał Swat on 20/06/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct ExerciseView: View {
    
    var exercise: Exercise
    
    @State var repeats = [String]()
    @State var weights = [String]()
    @State var weight = ""
    @State var rep = ""
    
    var body: some View {
        VStack {
            HStack {
                Text(exercise.exerciseName)
                Spacer()
                Text("repeats")
                Text("weight")
            }
            
            ForEach (0 ..< self.weights.count, id: \.self) { index in
                HStack {
                    Spacer()
                    SeriesTextFields(repeats: self.$repeats,
                                     weights: self.$weights,
                                     index: index,
                                     reps: self.rep,
                                     weight: self.weight)
                    
                }
            }
            
        }
        .onAppear() {
            self.repeats = Array(repeating: "", count: self.exercise.exerciseNumberOfSerises)
            self.weights = Array(repeating: "", count: self.exercise.exerciseNumberOfSerises)
        }
    }
}

struct ExerciseView_Previews: PreviewProvider {
    
    static var prevExercise = Exercise(name: "My Exercise")
    
    static var previews: some View {
        ExerciseView(exercise: prevExercise)
    }
}
