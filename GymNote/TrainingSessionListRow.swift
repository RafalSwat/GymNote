//
//  TrainingSessionListRow.swift
//  GymNote
//
//  Created by Rafał Swat on 09/03/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct TrainingSessionListRow: View {
    
    @Binding var exercise: Exercise
    @State var tempExercise = Exercise(name: "")
    @State var showDetails = false
    @State var numberOfSeries = 3
    
    
    var body: some View {
        
        VStack {
            Button(action: {
                withAnimation { self.showDetails.toggle() }
            }) {
                VStack {
                    HStack {
                        Text(exercise.exerciseName)
                        Spacer()
                        if showDetails {
                            Image(systemName: "chevron.up")
                                .font(.headline)
                        } else {
                            Image(systemName: "chevron.down")
                                .font(.headline)
                        }
                    }.padding()
                }
            }
            if showDetails {
                ExerciseDetails(numberOfSeries: $numberOfSeries, tempExercise: $exercise)
            }
        }
        
    }
}

struct TrainingSessionListRow_Previews: PreviewProvider {
    
    @State static var prevExercise = Exercise(name: "pull up")
    
    static var previews: some View {
        TrainingSessionListRow(exercise: $prevExercise)
    }
}

