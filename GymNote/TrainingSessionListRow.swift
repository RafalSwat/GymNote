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
    @State var more = true
    var action: () -> Void
    @State var dupa = ""
    
    
    var body: some View {
        
        Button(action: {
            withAnimation { self.more.toggle() }
        }) {
            VStack {
                HStack {
                    Text(exercise.exerciseName)
                    Spacer()
                    if more {
                        Image(systemName: "chevron.up")
                            .font(.headline)
                    } else {
                        Image(systemName: "chevron.down")
                            .font(.headline)
                    }
                }.padding()
                if more {
                    List {
                        Section(header: Text("dupa blada")) {
                            HStack {
                                Text("Number of series:")
                                Spacer()
                                Button(action: {
                                    self.tempExercise.exerciseSeries += 1
                                }) {
                                    Text("add")
                                }
                            }
                            HStack {
                                VStack {
                                    Text("repeats")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    TextField("...", text: $dupa)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                    
                                }
                                VStack {
                                    Text("weight")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    HStack {
                                        TextField("...", text: self.$dupa)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
 
                                    }
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

