//
//  ExerciseListRow.swift
//  GymNote
//
//  Created by Rafał Swat on 01/03/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct ExerciseListRow: View {
    
    var exerciseName: String
    var isCheck: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(self.exerciseName)
                if self.isCheck {
                    Spacer()
                    DualColorCheckmark()
                }
            }
        }
    }
}

struct ExerciseListRow_Previews: PreviewProvider {
    
    static var prevExercise = Exercise(name: "example exercise")
    static func prevAction(){return}
    
    static var previews: some View {
        ExerciseListRow(exerciseName: "exercise", isCheck: false, action: prevAction)
    }
}

//import SwiftUI
//
//struct ExerciseListRow: View {
//
//    @Environment(\.colorScheme) var colorScheme: ColorScheme
//    @State var isCheck: Bool = false
//
//    var exercise: Exercise
//    var checkmark = Image(systemName: "checkmark")
//
//
//    var body: some View {
//        HStack {
//            Text(exercise.exerciseName)
//                .font(.headline)
//            Spacer()
//            if isCheck {
//                self.checkmarkImage
//                    .foregroundColor(colorScheme == .light ? .black : .secondary)
//                    .font(.headline)
//            }
//        }.onTapGesture { self.isCheck.toggle() }
//    }
//}
//
//struct ExerciseListRow_Previews: PreviewProvider {
//
//    static var prevExercise = Exercise(name: "example exercise")
//
//    static var previews: some View {
//        ExerciseListRow(exercise: prevExercise)
//    }
//}

