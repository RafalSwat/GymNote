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
    @State var conform = false
    
    var body: some View {
        KeyboardHost {
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
                            ExerciseView(exercise: exercise, conform: self.$conform)
                        }
                    }
                    Section(header: Text("")) {
                        VStack {
                            Button(action: {
                                
                                self.conform = true
                                
                                let userID = self.session.userSession!.userTrainings.userID
                                let currentDate = DateConverter.dateFormat.string(from: Date())
                                
                                for exercise in self.training.listOfExercises {
                                    self.session.userSession!.userStats.insert(exercise, at: self.session.userSession!.userStats.startIndex)
                                    self.session.addExerciseStatstoFBR(id: userID, date: currentDate, exercise: exercise)
                                }
                                
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
