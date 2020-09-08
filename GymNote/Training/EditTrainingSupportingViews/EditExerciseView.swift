//
//  EditExerciseView.swift
//  GymNote
//
//  Created by Rafał Swat on 21/06/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct EditExerciseView: View {
    
    @Binding var exercise: Exercise
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    if exercise.exerciseCreatedByUser {
                        Image(systemName: "hammer")
                    }
                    Text(exercise.exerciseName)
                        .font(.headline)
                    Spacer()
                }
                SetSeriesView(exercise: $exercise)
            }
        }.padding(.bottom, 10)
    }
}

struct EditE$xerciseView_Previews: PreviewProvider {
    
    @State static var prevExercise = Exercise(name: "My Exercise")
    
    static var previews: some View {
        EditExerciseView(exercise: $prevExercise)
    }
}
