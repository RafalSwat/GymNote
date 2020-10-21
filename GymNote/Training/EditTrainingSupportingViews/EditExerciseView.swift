//
//  EditExerciseView.swift
//  GymNote
//
//  Created by Rafał Swat on 21/06/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct EditExerciseView: View {
    
    @ObservedObject var exercise: Exercise
    @Binding var editMode: EditMode
    @State var series = 1
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Text("\(exercise.exerciseOrderInList + 1). ")
                        .font(.headline)
                     
                    if exercise.exerciseCreatedByUser {
                        Image(systemName: "hammer")
                    }
                    Text(exercise.exerciseName)
                        .font(.headline)
                    Spacer()
                }
                HStack {
                    Text("number of series:")
                        .font(.callout)
                        .foregroundColor(.secondary)
                    Text(String(series))
                        .onAppear() {
                            self.series = self.exercise.exerciseNumberOfSeries
                        }
                    Spacer()
                }
                
            }
            .offset(x: editMode == .active ? -40 : 0)
            
            Spacer()
            SetSeriesView(exercise: exercise, series: $series)
        }
        .padding(.bottom, 10)
        
    }
}

struct EditE$xerciseView_Previews: PreviewProvider {
    
    @State static var prevExercise = Exercise(name: "My Exercise")
    @State static var prevEditMode = EditMode.inactive
    
    static var previews: some View {
        EditExerciseView(exercise: prevExercise,
                         editMode: $prevEditMode)
    }
}
