//
//  ExerciseView.swift
//  GymNote
//
//  Created by Rafał Swat on 20/06/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct ExerciseView: View {
    
    @EnvironmentObject var session: FireBaseSession
    var exercise: Exercise
    @Binding var conform: Bool
    
    @State var repeats = [String]()
    @State var weights = [String]()
    @State var weight = ""
    @State var rep = ""
    
    var body: some View {
        
        VStack {
            HStack {
                Text(exercise.exerciseName)
                    .font(.title)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                Text("Series:")
                    .foregroundColor(.secondary)
                Text("\(exercise.exerciseNumberOfSerises)x")
            }
            .padding(.bottom)
            HStack {
                
                Text("repeats")
                    .padding(.leading, 40)
                    .foregroundColor(.secondary)
                Spacer()
                Text("weight")
                    .padding(.trailing, 40)
                    .foregroundColor(.secondary)
            }
            
            ForEach (0 ..< self.weights.count, id: \.self) { index in
                HStack {
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
    
    
    func saveSeries() {
        for index in 0..<(exercise.exerciseNumberOfSerises) {
            self.exercise.exerciseSeries[index] = Series(repeats: Int(repeats[index])!, weight: Int(weights[index])!)
        }
    }
}

struct ExerciseView_Previews: PreviewProvider {
    
    static var prevExercise = Exercise(name: "My Exercise")
    @State static var prevConform = false
    
    static var previews: some View {
        ExerciseView(exercise: prevExercise, conform: $prevConform)
    }
}
