//
//  TrainingRow.swift
//  GymNote
//
//  Created by Rafał Swat on 08/06/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
struct TrainingRow: View {
    
    @EnvironmentObject var session: FireBaseSession
    @ObservedObject var listOfTrainings: ObservableArray<Training>
    @StateObject var training: Training
    @State var showButtons = false
    @State var showDetails = false
    @State var goToTraining = false
    @Binding var showAlert: Bool
    @Binding var selectedTraining: Training?


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
                    HStack {
                        if showButtons {
                            Image(systemName: "chevron.right")
                        } else {
                            Image(systemName: "chevron.left")
                                .offset(x: UIScreen.main.bounds.width/3.6, y: 0)
                        }
                        
                        UseButton(useAction: {
                            self.goToTraining.toggle()
                        })
                            .opacity(showButtons ? 1 : 0).animation(.default)
                            .buttonStyle(BorderlessButtonStyle())
                            .offset(x: 0, y: 2)
                            .shadow(color: Color.customShadow, radius: 2)
                        
                        DeleteButton(deleteAction: {
                            withAnimation(.easeInOut) {
                                self.showAlert.toggle()
                                self.selectedTraining = training
                            }
                        })
                            .opacity(showButtons ? 1 : 0).animation(.default)
                            .buttonStyle(BorderlessButtonStyle())
                            .shadow(color: Color.customShadow, radius: 2)
                    }
                }
            }
            .modifier(SwipeGesture(direction: .horizontal, showContetnt: $showButtons))
            
            if showDetails {
                TrainingDetails(training: training)
            }
            
            NavigationLink(destination: TrainingHost(training: training, draftTraining: training), isActive: self.$goToTraining) { EmptyView()}
                .frame(width: 0)
                .opacity(0)

        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation { self.showDetails.toggle() }
        }
        .onAppear {
            withAnimation {
                self.showButtons = false
                self.showDetails = false
            }
            
        }
        .padding(.horizontal)
        .contentShape(Rectangle())
        .frame(maxWidth: .infinity)
        .background(LinearGradient(gradient: Gradient(colors: [.customLight, .customDark]), startPoint: .leading, endPoint: .trailing))
        .cornerRadius(7)
        .shadow(color: Color.customShadow, radius: 3)
        .padding(2)
        
    }
}


struct TrainingRow_Previews: PreviewProvider {
    
    @State static var prevTraining = Training(id: UUID().uuidString,
                                              name: "My Program",
                                              description: "My litte subscription ",
                                              date: "01-Jan-2020",
                                              exercises: [TrainingsComponent(exercise: Exercise(), numberOfSeries: 1, orderInList: 1)])
    
    @State static var prevListOfTraining = [Training]()
    @State static var prevShowButtons = false
    @State static var prevShowDetails = false
    @State static var prevShowAlert = false
    @State static var prevSelectedTraining: Training?

    
    static var previews: some View {
        if #available(iOS 14.0, *) {
            TrainingRow(listOfTrainings: ObservableArray(array: [Training]()).observeChildrenChanges(),
                        training: prevTraining,
                        showAlert: $prevShowAlert,
                        selectedTraining: $prevSelectedTraining)
        } else {
            // Fallback on earlier versions
        }
    }
}

