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

