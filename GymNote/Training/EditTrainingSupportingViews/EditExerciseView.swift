//
//  EditExerciseView.swift
//  GymNote
//
//  Created by Rafał Swat on 21/06/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct EditExerciseView: View {
    
    @ObservedObject var trainingComponent: TrainingsComponent
    @Binding var editMode: EditMode
    @Binding var deleteMode: Bool
    @State var series = 1
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Text("\(trainingComponent.exerciseOrderInList + 1). ")
                        .font(.headline)
                     
                    if trainingComponent.exercise.exerciseCreatedByUser {
                        Image(systemName: "hammer")
                    }
                    Text(trainingComponent.exercise.exerciseName)
                        .font(.headline)
                    Spacer()
                }
                HStack {
                    Text("number of series:")
                        .font(.callout)
                        .foregroundColor(.secondary)
                    Text(String(series))
                        .onAppear() {
                            self.series = self.trainingComponent.exerciseNumberOfSeries
                        }
                    Spacer()
                }
                
            }
            .offset(x: editMode == .active ? -40 : 0)
            
            
            Spacer()
            SetSeriesView(trainingComponent: trainingComponent,
                          series: $series,
                          deleteMode: $deleteMode)
        }
        .padding(.bottom, 10)
        
    }
}

struct EditE$xerciseView_Previews: PreviewProvider {
    
    //static var prevListOfExercises = [Exercise]()
    @State static var prevExercise = TrainingsComponent(exercise: Exercise(), numberOfSeries: 1, orderInList: 1)
    @State static var prevEditMode = EditMode.inactive
    @State static var prevDeleteMode = false
    
    static var previews: some View {
        EditExerciseView(trainingComponent: prevExercise,
                         editMode: $prevEditMode,
                         deleteMode: $prevDeleteMode)
    }
}
