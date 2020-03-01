//
//  ExerciseListRow.swift
//  GymNote
//
//  Created by Rafał Swat on 01/03/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct ExerciseListRow: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State var isCheck = false
    var exercise: Exercise
    var checkmark = Image(systemName: "checkmark")
    
    
    var body: some View {
        HStack {
            Text(exercise.exerciseName)
                .font(.headline)
            Spacer()
            if isCheck {
                self.checkmark
                    .foregroundColor(colorScheme == .light ? .black : .secondary)
                    .font(.headline)
                
            }
        }.onTapGesture { self.isCheck.toggle() }
    }
}

struct ExerciseListRow_Previews: PreviewProvider {
    
    static var prevExercise = Exercise(name: "example exercise")
    
    static var previews: some View {
        ExerciseListRow(exercise: prevExercise)
    }
}
