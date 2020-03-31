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
            Button("-", action: {
                if self.series >= 2 {
                    self.series -= 1
                    self.exercise.exerciseNumberOfSerises = self.series
                }
            }).buttonStyle(RectangularButtonStyle(
                    fromColor: .black,
                    toColor: .red,
                    minWidth: 15, maxWidth: 30,
                    minHeight:15, maxHeight: 25))
                .padding(.horizontal)
            
            Spacer()
            Text("\(series) series").padding(10)
            Spacer()
            
            Button("+", action: {
                self.series += 1
                self.exercise.exerciseNumberOfSerises = self.series
            }).buttonStyle(RectangularButtonStyle(
                    fromColor: .black,
                    toColor: .green,
                    minWidth: 15, maxWidth: 30,
                    minHeight:15, maxHeight: 25))
                .padding(.horizontal)
            
        }
        .background(LinearGradient(gradient: Gradient(
            colors: colorScheme == .light ? [.white ,.gray] : [.black, .gray]),
                                    startPoint: .bottom, endPoint: .top))
        
    }
}

struct SetSeriesView_Previews: PreviewProvider {
    
    @State static var prevTempExercise = Exercise(name: "example1")
    
    static var previews: some View {
        SetSeriesView(exercise: $prevTempExercise)
    }
}
