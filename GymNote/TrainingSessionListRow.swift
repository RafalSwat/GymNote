//
//  TrainingSessionListRow.swift
//  GymNote
//
//  Created by Rafał Swat on 09/03/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct TrainingSessionListRow: View {
    
    @Binding var exercise: Exercise // binding from list of selected exercises
    @State var showDetails = false

    var body: some View {
        
        VStack {
            Button(action: {
                withAnimation { self.showDetails.toggle() }
            }) {
                VStack {
                    HStack {
                        Text(exercise.exerciseName)
                            .font(.callout)
                        Spacer()
                        if showDetails {
                            Image(systemName: "chevron.up")
                                .font(.callout)
                        } else {
                            Image(systemName: "chevron.down")
                                .font(.callout)
                        }
                    }.padding()
                }
            }
            if showDetails {
                ExerciseDetails(exercise: $exercise)
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

