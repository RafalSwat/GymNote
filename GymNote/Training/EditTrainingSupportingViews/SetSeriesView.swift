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
    @Binding var exercise: Exercise // binding from list of selected 
    @State var series = 1
    
    var body: some View {
        HStack {
            
            Text("number of series:")
                .font(.callout)
                .foregroundColor(.secondary)
            Text(String(series))
            Spacer()
            
            Button(action: {
                self.series += 1
                self.exercise.exerciseNumberOfSerises = self.series
            }) {
                Image(systemName: "plus.square")
                    .font(.largeTitle)
                    .foregroundColor(Color.orange)
                    .padding(.horizontal)
            }.buttonStyle(BorderlessButtonStyle())

            
            Button(action: {
                if self.series >= 2 {
                    self.series -= 1
                    self.exercise.exerciseNumberOfSerises = self.series
                }
            }) {
                Image(systemName: "minus.square")
                    .font(.largeTitle)
                    .foregroundColor(Color.red)
            }.buttonStyle(BorderlessButtonStyle())

            
            
        }
        .onAppear() {
            self.series = self.exercise.exerciseNumberOfSerises
        }
        
    }
}

struct SetSeriesView_Previews: PreviewProvider {
    
    @State static var prevTempExercise = Exercise(name: "example1")
    
    static var previews: some View {
        SetSeriesView(exercise: $prevTempExercise)
    }
}
