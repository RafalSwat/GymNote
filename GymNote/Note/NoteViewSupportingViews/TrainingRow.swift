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
    var training: Training
    @State private var showButtons = false
    @State var showDetails = false
    @State var goToTraining = false
    @Binding var listOfTraining: [Training]
    
    var body: some View {
        VStack {
            HStack {
                if showDetails {
                    VStack(alignment: .leading) {
                        Text(training.trainingName)
                            .font(.title)
                        Text(training.trainingSubscription)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }.padding(.bottom)
                } else {
                    VStack(alignment: .leading) {
                        Text(training.trainingName)
                            .font(.headline)
                        Text(training.trainingSubscription)
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
                       
                        DeleteButton(deleteAction: {
                            self.removeTraining(at: self.listOfTraining.firstIndex(of: self.training)!)
                            
                            
                            
                            print("Delete Action")
                            
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
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation { self.showDetails.toggle() }
        }
    }
    
    func removeTraining(at index: Int) {

        self.listOfTraining.remove(at: index)
        self.session.deleteTrainingFromFBR(userTrainings: self.session.userSession!.userTrainings, training: training)
    }
    
}


struct TrainingRow_Previews: PreviewProvider {
    
    static var prevTraining = Training(id: UUID().uuidString,
                                       name: "My Program",
                                       subscription: "My litte subscription ",
                                       date: "01-Jan-2020",
                                       exercises: [Exercise(name: "My Exercise")])
    
    @State static var prevListOfTraining = [Training]()
    
    static var previews: some View {
        TrainingRow(training: prevTraining, listOfTraining: $prevListOfTraining)
    }
}

