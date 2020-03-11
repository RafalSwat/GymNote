//
//  TrainingSessionListRow.swift
//  GymNote
//
//  Created by Rafał Swat on 09/03/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct TrainingSessionListRow: View {
    
    @Binding var exercise: Exercise
    @State var tempExercise = Exercise(name: "")
    @State var showDetails = true
    @State var numberOfSeries = 1
    var action: () -> Void
    
    
    
    var body: some View {
        
        Button(action: {
            withAnimation { self.showDetails.toggle() }
        }) {
            VStack {
                HStack {
                    Text(exercise.exerciseName)
                    Spacer()
                    if showDetails {
                        Image(systemName: "chevron.up")
                            .font(.headline)
                    } else {
                        Image(systemName: "chevron.down")
                            .font(.headline)
                    }
                }.padding()
                if showDetails {
                    List {
                        Section(header: Text("dupa blada")) {
                            HStack {
                                Text("Number of series:")
                                Spacer()
                                Button(action: {
                                    self.numberOfSeries += 1
                                }) {
                                    Text("add")
                                }
                            }
                            
                        }
                    }
                }
            }
        }
    }
}

struct TrainingSessionListRow_Previews: PreviewProvider {
    
    @State static var prevExercise = Exercise(name: "pull up")
    
    static var previews: some View {
        TrainingSessionListRow(exercise: $prevExercise, action:
            { print("Previews TrainingSessionListRow action is going") } )
    }
}

