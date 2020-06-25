//
//  TrainingView.swift
//  GymNote
//
//  Created by Rafał Swat on 20/06/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct TrainingView: View {
    
    @EnvironmentObject var session: FireBaseSession
    var training: Training
    let dataString = DateConverter.dateFormat.string(from: Date())
    
    var body: some View {
        VStack(alignment: .leading) {
            List {
                Section(header: Text("")) {
                    
                    VStack(alignment: .leading) {
                        Text(training.trainingName)
                            .font(.largeTitle)
                            .padding(.horizontal)
                            .padding(.bottom)
                        
                        Text(training.trainingSubscription)
                            .padding(.horizontal)
                        Text("last training: \(dataString)")
                            .padding(.horizontal)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    
                }
                Section(header: Text("")) {
                    ForEach(training.listOfExercises, id: \.self) { exercise in
                        ExerciseView(exercise: exercise)
                    }
                }
                Section(header: Text("")) {
                    VStack {
                        Button(action: {
                            print("Some Action")
                        }) {
                            HStack {
                                Image(systemName: "checkmark.circle")
                                    .font(.largeTitle)
                                Spacer()
                                Text("Confirm finished training")
                                Spacer()
                            }.padding()
                        }.buttonStyle(RectangularButtonStyle())
                            .padding(.vertical)
                    }
                }
                .listStyle(PlainListStyle())
                .navigationBarBackButtonHidden(false)
                .navigationBarTitle(Text(training.trainingName), displayMode: .inline)
            }
        }
    }
}

struct TrainingView_Previews: PreviewProvider {
    
    static var prevTraining = Training()
    
    static var previews: some View {
        NavigationView {
            TrainingView(training: prevTraining)
        }
    }
}
