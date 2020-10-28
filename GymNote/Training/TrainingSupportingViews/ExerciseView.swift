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
    @State var repeats = ""
    @State var weight = ""
    
    
    var body: some View {
        
        VStack {
            HStack {
                if exercise.exerciseCreatedByUser {
                    Image(systemName: "hammer")
                }
                Text(exercise.exerciseName)
                    .font(.title)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                Text("Series:")
                    .foregroundColor(.secondary)
                Text("\(exercise.exerciseNumberOfSeries)")
            }
            .padding(.bottom)
            
            ForEach (0 ..< self.exercise.exerciseNumberOfSeries, id: \.self) { index in
                HStack {
                    Text("\(index + 1).   ")
                        .frame(minWidth: 10, maxWidth: 20, minHeight: 0, maxHeight: .infinity)
                    
                    SeriesTextFields(repetitions: $repeats,
                                     weight: $weight)

//                    Try(index: index,
//                        reps: self.repeats,
//                        weight: self.weight
//                    )
                }
            }
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
