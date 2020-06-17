//
//  TrainingRow.swift
//  GymNote
//
//  Created by Rafał Swat on 08/06/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct TrainingRow: View {
    
    var training: Training
    @State private var showButtons = false
    @State var showDetails = false
    @State var goToTraining = false
    
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
                    }
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
                        
                        Button(action: {
                            print("tapped button 1")
                        }) {
                            Text("1")
                        }.buttonStyle(RectangularButtonStyle())
                            .opacity(showButtons ? 1 : 0).animation(.default)
                            .frame(width: UIScreen.main.bounds.width/7, height: UIScreen.main.bounds.width/7, alignment: .leading)
                        Button(action: {
                            print("tapped button 2")
                        }) {
                            Text("2")
                        }.buttonStyle(RectangularButtonStyle())
                            .opacity(showButtons ? 1 : 0).animation(.default)
                            .frame(width: UIScreen.main.bounds.width/7, height: UIScreen.main.bounds.width/7, alignment: .leading)
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
}


struct TrainingRow_Previews: PreviewProvider {
    
    static var prevTraining = Training(id: UUID().uuidString,
                                       name: "My Program",
                                       subscription: "My litte subscription ",
                                       date: "01-Jan-2020",
                                       exercises: [Exercise(name: "My Exercise")])
    static var previews: some View {
        TrainingRow(training: prevTraining)
    }
}

