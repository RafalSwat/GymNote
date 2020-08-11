//
//  TrainingRow.swift
//  GymNote
//
//  Created by Rafał Swat on 08/06/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct TrainingRow: View {
    
    @EnvironmentObject var session: FireBaseSession
    @Binding var listOfTrainings: [Training]
    @State var training: Training
    @Binding var showButtons: Bool
    @Binding var showDetails: Bool
    @State var goToTraining = false

    var body: some View {
        VStack {
            HStack {
                if showDetails {
                    VStack(alignment: .leading) {
                        Text(training.trainingName)
                            .font(.title)
                        Text(training.trainingDescription)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }.padding(.bottom)
                } else {
                    VStack(alignment: .leading) {
                        Text(training.trainingName)
                            .font(.headline)
                        Text(training.trainingDescription)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                ZStack {
                    if !showButtons {
                        Image(systemName: "chevron.left")
                            .offset(x: UIScreen.main.bounds.width/7, y: 0)
                    }
                    HStack {
                        if showButtons {
                            Image(systemName: "chevron.right")
                        }
                        
                        UseButton(useAction: {
                            self.goToTraining.toggle()
                        })
                            .opacity(showButtons ? 1 : 0).animation(.default)
                            .buttonStyle(BorderlessButtonStyle())
                            .offset(x: 0, y: 2)
                        
                        DeleteButton(deleteAction: {
                            if let indexOfTrainingToRemove = self.session.userSession?.userTrainings.firstIndex(of: self.training) {
                                self.removeTraining(at: indexOfTrainingToRemove)
                                self.session.userSession?.userTrainings.remove(at: indexOfTrainingToRemove)
                                self.listOfTrainings.remove(at: indexOfTrainingToRemove)
                            }
                        })
                            .opacity(showButtons ? 1 : 0).animation(.default)
                            .buttonStyle(BorderlessButtonStyle())
                    }
                }
            }
            .modifier(SwipeGesture(direction: .horizontal, showContetnt: $showButtons))
            
            if showDetails {
                TrainingDetails(training: training)
            }
            NavigationLink(destination: TrainingHost(training: training, draftTraining: training), isActive: self.$goToTraining) { EmptyView() }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation { self.showDetails.toggle() }
        }
    }
    
    
    func removeTraining(at index: Int) {
        if let userID = self.session.userSession?.userProfile.userID {
            self.session.deleteTrainingFromDB(userID: userID, training: training) { errorOccur, errorDescription in
                if errorOccur {
                    print(errorDescription ?? "Unknow error occur during removing training!")
                }
                
            }
        }
    }
    
}


struct TrainingRow_Previews: PreviewProvider {
    
    @State static var prevTraining = Training(id: UUID().uuidString,
                                              name: "My Program",
                                              description: "My litte subscription ",
                                              date: "01-Jan-2020",
                                              exercises: [Exercise(name: "My Exercise")])
    
    @State static var prevListOfTraining = [Training]()
    @State static var prevShowButtons = false
    @State static var prevShowDetails = false
    
    static var previews: some View {
        TrainingRow(listOfTrainings: $prevListOfTraining,
                    training: prevTraining,
                    showButtons: $prevShowButtons,
                    showDetails: $prevShowDetails)
    }
}

