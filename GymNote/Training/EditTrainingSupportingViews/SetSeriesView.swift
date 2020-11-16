//
//  SetSeriesView.swift
//  GymNote
//
//  Created by Rafał Swat on 31/03/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct SetSeriesView: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @ObservedObject var trainingComponent: TrainingsComponent // binding from list of selected
    @Binding var series: Int
    @Binding var deleteMode: Bool
    
    var body: some View {
        HStack {
            Button(action: {
                self.series += 1
                self.trainingComponent.exerciseNumberOfSeries = self.series
            }) {
                Image(systemName: "plus.square")
                    .font(.largeTitle)
                    .foregroundColor(Color.orange)
                    .padding(.horizontal)
            }.buttonStyle(BorderlessButtonStyle())

            Button(action: {
                if self.series >= 2 {
                    self.series -= 1
                    self.trainingComponent.exerciseNumberOfSeries = self.series
                }
            }) {
                Image(systemName: "minus.square")
                    .font(.largeTitle)
                    .foregroundColor(Color.red)
            }.buttonStyle(BorderlessButtonStyle())
        }
    }
}

struct SetSeriesView_Previews: PreviewProvider {
    
    @State static var prevTempExercise = TrainingsComponent(exercise: Exercise(), numberOfSeries: 1, orderInList: 1)
    @State static var prevSeries = 1
    @State static var prevDeleteMode = false
    
    static var previews: some View {
        SetSeriesView(trainingComponent: prevTempExercise, series: $prevSeries, deleteMode: $prevDeleteMode)
    }
}
