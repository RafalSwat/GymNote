//
//  ProgramSessionListRow.swift
//  GymNote
//
//  Created by Rafał Swat on 24/04/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct ProgramSessionListRow: View {
    
    var exercise: Exercise
    
    @State var repeats = [String]()
    @State var weights = [String]()
    @State var weight = ""
    @State var rep = ""
    
    var body: some View {
        VStack {
            Text(exercise.exerciseName)
                .font(.headline)
                .foregroundColor(Color.white)
                .padding()

            HStack {
                Spacer()
                Text("repeats")
                    .offset(x: -15)
                Spacer()
                Text("weight")
                    .offset(x: 15)
                Spacer()
                    
            }
            .font(.subheadline)
            .foregroundColor(.magnesium)
            
            ForEach (0 ..< self.weights.count, id: \.self) { index in
                HStack {
                    SeriesTextFields(repeats: self.$repeats,
                                     weights: self.$weights,
                                     index: index,
                                     reps: self.rep,
                                     weight: self.weight)
                    
                }
            }
            
        }.onAppear() {
            self.repeats = Array(repeating: "", count: self.exercise.exerciseNumberOfSerises)
            self.weights = Array(repeating: "", count: self.exercise.exerciseNumberOfSerises)
        }
        .padding(.horizontal)
        .padding(.bottom)
        .background(LinearGradient(gradient: Gradient(colors: [.gray ,.customDark]),
                                   startPoint: .leading, endPoint: .trailing))
    }
}

struct ProgramSessionListRow_Previews: PreviewProvider {
    
      static var prevTempExercise = Exercise(name: "Hard Exercise!")
    
    static var previews: some View {
        ProgramSessionListRow(exercise: prevTempExercise)
    }
}
